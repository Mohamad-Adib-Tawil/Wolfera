import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/my_car/presentation/manager/my_cars_bloc.dart';
import 'package:wolfera/features/my_car/presentation/widgets/my_cars_list_view_builder.dart';

class MyCarsPage extends StatefulWidget {
  const MyCarsPage({super.key});

  @override
  State<MyCarsPage> createState() => _MyCarsPageState();
}

class _MyCarsPageState extends State<MyCarsPage> {
  // One-time entrance animation per session
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;
  @override
  void initState() {
    super.initState();
    // تحميل سيارات المستخدم عند فتح الصفحة
    Future.microtask(() => context.read<MyCarsBloc>().add(LoadMyCarsEvent()));
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
  }

  @override
  Widget build(BuildContext context) {
    // Show delete-all only if loading finished successfully AND user has cars
    final showDeleteAll = context.select<MyCarsBloc, bool>(
      (bloc) =>
          bloc.state.loadCarsStatus.isSuccess() && bloc.state.myCars.isNotEmpty,
    );
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: HWEdgeInsets.only(left: 16, right: 16, bottom: 40),
          child: _shouldAnimateEntrance
              ? _DelayedFadeSlide(
                  delay: const Duration(milliseconds: 360),
                  duration: const Duration(milliseconds: 1000),
                  beginOffset: const Offset(0, 0.24),
                  child: _SellCarCta(
                    onTap: () => GRouter.router
                        .pushNamed(GRouter.config.myCarsRoutes.sellMyCarPage),
                  ),
                )
              : _SellCarCta(
                  onTap: () => GRouter.router
                      .pushNamed(GRouter.config.myCarsRoutes.sellMyCarPage),
                ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _shouldAnimateEntrance
              ? _DelayedFadeSlide(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 1000),
                  beginOffset: const Offset(0, -0.24),
                  child: CustomAppbar(
                    text: 'my_cars'.tr(),
                    action: showDeleteAll
                        ? IconButton(
                            tooltip: 'Delete all',
                            icon: const Icon(Icons.delete_forever_outlined,
                                color: Colors.white),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete all cars?'),
                                      content: const Text(
                                          'Are you sure you want to delete all your cars? This action cannot be undone.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: const Text('Delete',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                              if (confirmed) {
                                context
                                    .read<MyCarsBloc>()
                                    .add(DeleteAllMyCarsEvent());
                              }
                            },
                          )
                        : null,
                  ),
                )
              : CustomAppbar(
                  text: 'my_cars'.tr(),
                  action: showDeleteAll
                      ? IconButton(
                          tooltip: 'Delete all',
                          icon: const Icon(Icons.delete_forever_outlined,
                              color: Colors.white),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete all cars?'),
                                    content: const Text(
                                        'Are you sure you want to delete all your cars? This action cannot be undone.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(true),
                                        child: const Text('Delete',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                ) ??
                                false;
                            if (confirmed) {
                              context
                                  .read<MyCarsBloc>()
                                  .add(DeleteAllMyCarsEvent());
                            }
                          },
                        )
                      : null,
                ),
        ),
        body: BlocBuilder<MyCarsBloc, MyCarsState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: _shouldAnimateEntrance
                      ? _DelayedFadeSlide(
                          delay: const Duration(milliseconds: 260),
                          duration: const Duration(milliseconds: 1000),
                          beginOffset: const Offset(-0.24, 0),
                          child: MyCarsListViewBuilder(
                            loadCarsStatus: state.loadCarsStatus,
                            myCars: state.myCars,
                          ),
                        )
                      : MyCarsListViewBuilder(
                          loadCarsStatus: state.loadCarsStatus,
                          myCars: state.myCars,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SellCarCta extends StatelessWidget {
  const _SellCarCta({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = 18.r;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Ink(
            height: 62.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFA742),
                  AppColors.primary,
                  Color(0xFFE67E00),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
                width: 1.1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.28),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  Container(
                    width: 34.r,
                    height: 34.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sell_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: AppText(
                      'sell_my_car',
                      style: context.textTheme.titleMedium?.s18.xb
                          .withColor(Colors.white),
                    ),
                  ),
                  Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DelayedFadeSlide extends StatefulWidget {
  const _DelayedFadeSlide({
    required this.child,
    required this.delay,
    this.duration = const Duration(milliseconds: 820),
    this.beginOffset = const Offset(0, 0.08),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;

  @override
  State<_DelayedFadeSlide> createState() => _DelayedFadeSlideState();
}

class _DelayedFadeSlideState extends State<_DelayedFadeSlide> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        offset: _visible ? Offset.zero : widget.beginOffset,
        child: widget.child,
      ),
    );
  }
}
