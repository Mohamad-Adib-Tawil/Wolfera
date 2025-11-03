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
    // Show delete-all only if user has cars
    final showDeleteAll = context.select<MyCarsBloc, bool>(
      (bloc) => bloc.state.myCars.isNotEmpty,
    );
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: Padding(
          padding: HWEdgeInsets.only(bottom: 18),
          child: _shouldAnimateEntrance
              ? _DelayedFadeSlide(
                  delay: const Duration(milliseconds: 360),
                  duration: const Duration(milliseconds: 1000),
                  beginOffset: const Offset(0, 0.24),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          alignment: Alignment.center,
                          minimumSize: WidgetStatePropertyAll(Size(200.w, 40.h)),
                          backgroundColor:
                              const WidgetStatePropertyAll(AppColors.white)),
                      onPressed: () {
                        GRouter.router
                            .pushNamed(GRouter.config.myCarsRoutes.sellMyCarPage);
                      },
                      child: AppText(
                        "Sell My Car".tr(),
                        style: context.textTheme.bodyLarge?.b
                            .withColor(AppColors.blackLight),
                      )),
                )
              : ElevatedButton(
              style: ButtonStyle(
                  alignment: Alignment.center,
                  minimumSize: WidgetStatePropertyAll(Size(200.w, 40.h)),
                  backgroundColor:
                      const WidgetStatePropertyAll(AppColors.white)),
              onPressed: () {
                GRouter.router
                    .pushNamed(GRouter.config.myCarsRoutes.sellMyCarPage);
              },
              child: AppText(
                "Sell My Car".tr(),
                style: context.textTheme.bodyLarge?.b
                    .withColor(AppColors.blackLight),
              )),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _shouldAnimateEntrance
              ? _DelayedFadeSlide(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 1000),
                  beginOffset: const Offset(0, -0.24),
                  child: CustomAppbar(
                    text: 'My Cars'.tr(),
                    action: showDeleteAll
                        ? IconButton(
                            tooltip: 'Delete all',
                            icon: const Icon(Icons.delete_forever_outlined, color: Colors.white),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete all cars?'),
                                      content: const Text('Are you sure you want to delete all your cars? This action cannot be undone.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(true),
                                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                  false;
                              if (confirmed) {
                                context.read<MyCarsBloc>().add(DeleteAllMyCarsEvent());
                              }
                            },
                          )
                        : null,
                  ),
                )
              : CustomAppbar(
                  text: 'My Cars'.tr(),
                  action: showDeleteAll
                      ? IconButton(
                          tooltip: 'Delete all',
                          icon: const Icon(Icons.delete_forever_outlined, color: Colors.white),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Delete all cars?'),
                                    content: const Text('Are you sure you want to delete all your cars? This action cannot be undone.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(ctx).pop(true),
                                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                ) ??
                                false;
                            if (confirmed) {
                              context.read<MyCarsBloc>().add(DeleteAllMyCarsEvent());
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
