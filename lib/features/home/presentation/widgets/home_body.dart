import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/features/home/presentation/widgets/body_types_filter_section.dart';
import 'package:wolfera/features/home/presentation/widgets/budget_filter_section.dart';
import 'package:wolfera/features/home/presentation/widgets/makers_filter_home_section.dart';
import 'package:wolfera/features/home/presentation/widgets/recommended_section.dart';
import 'package:wolfera/features/home/presentation/widgets/search_bar_button.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    this.animate = false,
  });

  final bool animate;

  @override
  Widget build(BuildContext context) {
    if (!animate) {
      return SliverList(
        delegate: SliverChildListDelegate([
          10.verticalSpace,
          SearchBarButton(
              onTap: () => StatefulNavigationShell.of(context).goBranch(1)),
          const RecommendedSection(),
          const BodyTypesFilterSection(),
          const BudgetFilterSection(),
          const MakersFilterHomeSection(),
          35.verticalSpace,
        ]),
      );
    }

    // Animated entrance (staggered)
    return SliverList(
      delegate: SliverChildListDelegate([
        10.verticalSpace,
        // Search from TOP
        _DelayedFadeSlide(
          delay: const Duration(milliseconds: 100),
          duration: const Duration(milliseconds: 1000),
          beginOffset: const Offset(0, -0.24),
          child: SearchBarButton(
              onTap: () => StatefulNavigationShell.of(context).goBranch(1)),
        ),
        // Recommended cars list from LEFT
        _DelayedFadeSlide(
          delay: const Duration(milliseconds: 220),
          beginOffset: const Offset(-0.18, 0),
          child: const RecommendedSection(),
        ),
        // Other sections from RIGHT
        _DelayedFadeSlide(
          delay: const Duration(milliseconds: 360),
          beginOffset: const Offset(0.18, 0),
          child: const BodyTypesFilterSection(),
        ),
        _DelayedFadeSlide(
          delay: const Duration(milliseconds: 500),
          beginOffset: const Offset(0.18, 0),
          child: const BudgetFilterSection(),
        ),
        _DelayedFadeSlide(
          delay: const Duration(milliseconds: 640),
          beginOffset: const Offset(0.18, 0),
          child: const MakersFilterHomeSection(),
        ),
        35.verticalSpace,
      ]),
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
