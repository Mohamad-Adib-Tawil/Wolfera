import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/money_formatter.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/features/app/presentation/widgets/app_cached_network_image.dart';
import 'package:wolfera/features/app/presentation/widgets/app_elvated_button.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:wolfera/features/home/presentation/pages/home_page.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/services/supabase_service.dart';

class CarApprovalPage extends StatefulWidget {
  const CarApprovalPage({super.key});

  static final ValueNotifier<int> refreshTick = ValueNotifier<int>(0);

  static void requestRefresh() {
    refreshTick.value++;
  }

  @override
  State<CarApprovalPage> createState() => _CarApprovalPageState();
}

class _CarApprovalPageState extends State<CarApprovalPage> {
  late Future<_ApprovalPageData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
    CarApprovalPage.refreshTick.addListener(_handleExternalRefresh);
  }

  @override
  void dispose() {
    CarApprovalPage.refreshTick.removeListener(_handleExternalRefresh);
    super.dispose();
  }

  void _handleExternalRefresh() {
    if (!mounted) return;
    setState(() {
      _future = _load();
    });
  }

  Future<_ApprovalPageData> _load() async {
    final isAdmin = await SupabaseService.isCurrentUserAdmin();
    if (!isAdmin) {
      return const _ApprovalPageData(isAdmin: false, cars: []);
    }

    final cars = await SupabaseService.fetchPendingCars();
    return _ApprovalPageData(isAdmin: true, cars: cars);
  }

  Future<void> _refresh() async {
    if (!mounted) return;
    setState(() {
      _future = _load();
    });
    await _future;
  }

  Future<void> _approve(String carId) async {
    try {
      EasyLoading.show(status: 'approval_approving'.tr());
      await SupabaseService.approveCar(carId);
      _refreshPublicCarLists();
      EasyLoading.showSuccess('approval_car_approved'.tr());
    } catch (e) {
      EasyLoading.showError('approval_action_failed'.tr(args: [e.toString()]));
      return;
    }

    await _refreshAfterAction();
  }

  Future<void> _reject(Map<String, dynamic> car) async {
    final reason = await _showRejectionReasonDialog();
    if (reason == null || reason.trim().isEmpty) return;

    try {
      EasyLoading.show(status: 'approval_rejecting'.tr());
      await SupabaseService.rejectCar(
        carId: car['id'].toString(),
        reason: reason.trim(),
      );
      _refreshPublicCarLists();
      EasyLoading.showSuccess('approval_car_rejected'.tr());
    } catch (e) {
      EasyLoading.showError('approval_action_failed'.tr(args: [e.toString()]));
      return;
    }

    await _refreshAfterAction();
  }

  Future<void> _refreshAfterAction() async {
    try {
      await _refresh();
    } catch (_) {
      if (!mounted) return;
      setState(() => _future = _load());
    }
  }

  Future<String?> _showRejectionReasonDialog() {
    return showDialog<String>(
      context: context,
      builder: (_) => const _RejectionReasonDialog(),
    );
  }

  void _refreshPublicCarLists() {
    HomePage.requestRefresh();
    try {
      GetIt.I<HomeCubit>().getHomeData();
      GetIt.I<SearchCubit>().searchCars();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.blackLight,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: const CustomAppbar(text: 'car_approval'),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<_ApprovalPageData>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: AppLoader(color: AppColors.primary));
              }

              if (snapshot.hasError) {
                return _MessageState(
                  title: 'somethingWentWrong',
                  subtitle: snapshot.error.toString(),
                  subtitleTranslation: false,
                );
              }

              final data = snapshot.data;
              if (data == null || !data.isAdmin) {
                return _MessageState(
                  title: 'approval_unauthorized_title',
                  subtitle: 'approval_unauthorized_subtitle',
                );
              }

              if (data.cars.isEmpty) {
                return _MessageState(
                  title: 'approval_empty_title',
                  subtitle: 'approval_empty_subtitle',
                );
              }

              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: HWEdgeInsets.only(
                  left: 14,
                  right: 14,
                  top: 14,
                  bottom: 92,
                ),
                itemCount: data.cars.length,
                separatorBuilder: (_, __) => 12.verticalSpace,
                itemBuilder: (context, index) {
                  final car = data.cars[index];
                  return _ApprovalCarCard(
                    car: car,
                    onApprove: () => _approve(car['id'].toString()),
                    onReject: () => _reject(car),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RejectionReasonDialog extends StatefulWidget {
  const _RejectionReasonDialog();

  @override
  State<_RejectionReasonDialog> createState() => _RejectionReasonDialogState();
}

class _RejectionReasonDialogState extends State<_RejectionReasonDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1F24),
      title: Text(
        'approval_rejection_reason'.tr(),
        style: const TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: 4,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'approval_rejection_reason_hint'.tr(),
          hintStyle: const TextStyle(color: Colors.white54),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('cancel'.tr()),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text('approval_reject'.tr()),
        ),
      ],
    );
  }
}

class _ApprovalCarCard extends StatelessWidget {
  const _ApprovalCarCard({
    required this.car,
    required this.onApprove,
    required this.onReject,
  });

  final Map<String, dynamic> car;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final owner = car['owner'] is Map<String, dynamic>
        ? car['owner'] as Map<String, dynamic>
        : null;
    final image = _resolveImage(car);
    final title = _resolveTitle(car);
    final seller = _firstNonEmpty([
          owner?['dealer_name'],
          owner?['full_name'],
          owner?['email'],
        ]) ??
        'noName'.tr();
    final location =
        _firstNonEmpty([car['city'], car['country'], car['location']]);
    final prefs = GetIt.I<PrefsRepository>();
    final currency = car['currency']?.toString();
    final price = MoneyFormatter.compactFromString(
          car['price']?.toString(),
          symbol: currency == null || currency.isEmpty
              ? prefs.selectedCurrencyCode ?? 'USD'
              : currency,
        ) ??
        '-';
    final createdAt = DateTime.tryParse(car['created_at']?.toString() ?? '');

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1F24),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: image == null
                ? Container(
                    color: Colors.black26,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.directions_car_filled_rounded,
                      color: Colors.white38,
                      size: 42,
                    ),
                  )
                : AppCachedNetworkImageView(
                    url: image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
          Padding(
            padding: HWEdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium?.s18.xb
                            .withColor(Colors.white),
                      ),
                    ),
                    8.horizontalSpace,
                    Container(
                      padding:
                          HWEdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        price,
                        style: context.textTheme.bodyMedium?.s13.xb
                            .withColor(AppColors.primary),
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                _MetaRow(icon: Icons.person_outline, text: seller),
                if (location != null) ...[
                  6.verticalSpace,
                  _MetaRow(icon: Icons.location_on_outlined, text: location),
                ],
                if (createdAt != null) ...[
                  6.verticalSpace,
                  _MetaRow(
                    icon: Icons.schedule_outlined,
                    text: DateFormat.yMMMd(context.locale.languageCode)
                        .add_Hm()
                        .format(createdAt),
                  ),
                ],
                14.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: AppElevatedButton(
                        text: 'approval_reject',
                        onPressed: onReject,
                        appButtonStyle: AppButtonStyle.secondary,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 46.h),
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: AppElevatedButton(
                        text: 'approval_approve',
                        onPressed: onApprove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: Size(double.infinity, 46.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _resolveImage(Map<String, dynamic> car) {
    final imageUrls = car['image_urls'];
    if (imageUrls is List && imageUrls.isNotEmpty) {
      final first = imageUrls.first?.toString();
      if (first != null && first.trim().isNotEmpty) return first;
    }
    final main = car['main_image_url']?.toString();
    return main != null && main.trim().isNotEmpty ? main : null;
  }

  String _resolveTitle(Map<String, dynamic> car) {
    final explicit = car['title']?.toString();
    if (explicit != null && explicit.trim().isNotEmpty) return explicit;

    final parts = [
      car['year']?.toString(),
      car['brand']?.toString(),
      car['model']?.toString(),
    ].where((part) => part != null && part.trim().isNotEmpty);
    final title = parts.join(' ');
    return title.isEmpty ? 'car'.tr() : title;
  }

  String? _firstNonEmpty(List<Object?> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) return text;
    }
    return null;
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 17.r),
        6.horizontalSpace,
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.s13.withColor(Colors.white70),
          ),
        ),
      ],
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.title,
    required this.subtitle,
    this.subtitleTranslation = true,
  });

  final String title;
  final String subtitle;
  final bool subtitleTranslation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: HWEdgeInsets.all(24),
          children: [
            SizedBox(
              height: constraints.maxHeight > 0 ? constraints.maxHeight : 420.h,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fact_check_outlined,
                      color: Colors.white54,
                      size: 56.r,
                    ),
                    14.verticalSpace,
                    AppText(
                      title,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium?.s18.xb
                          .withColor(Colors.white),
                    ),
                    8.verticalSpace,
                    AppText(
                      subtitle,
                      translation: subtitleTranslation,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: context.textTheme.bodyMedium
                          ?.withColor(Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ApprovalPageData {
  const _ApprovalPageData({
    required this.isAdmin,
    required this.cars,
  });

  final bool isAdmin;
  final List<Map<String, dynamic>> cars;
}
