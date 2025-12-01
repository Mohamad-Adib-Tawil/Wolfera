import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
// Removed legacy separate filter sections in favor of CombinedFiltersBar
import 'package:wolfera/features/home/presentation/widgets/combined_filters_bar.dart';
import 'package:wolfera/features/home/presentation/widgets/recommended_section.dart';
import 'package:wolfera/features/home/presentation/widgets/home_ad_banner.dart';
import 'package:wolfera/features/home/presentation/widgets/search_bar_button.dart';
import 'package:wolfera/features/home/presentation/widgets/search_results_vertical_list.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    this.animate = false,
    this.refreshToken = 0,
    this.onRegisterBannerReload,
    this.hasBanner = false,
    this.onBannerPresenceChanged,
  });

  final bool animate;
  final int refreshToken;
  final void Function(Future<void> Function())? onRegisterBannerReload;
  final bool hasBanner;
  final void Function(bool hasBanner)? onBannerPresenceChanged;

  @override
  Widget build(BuildContext context) {
    if (!animate) {
      return SliverList(
        delegate: SliverChildListDelegate([
          10.verticalSpace,
          SearchBarButton(
              onTap: () => StatefulNavigationShell.of(context).goBranch(1)),
          
          HomeAdBanner(
            refreshToken: refreshToken,
            onRegisterReload: onRegisterBannerReload,
            onPresenceChanged: onBannerPresenceChanged,
          ),
          const RecommendedSection(),
          const CombinedFiltersBar(),
          8.verticalSpace,
          SearchResultsVerticalList(
            bottomPadding: hasBanner ? 35.h : 0,
          ),
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
        // Ads banner from RIGHT
        _DelayedFadeSlide(
          delay: const Duration(milliseconds: 180),
          beginOffset: const Offset(0.18, 0),
          child: HomeAdBanner(
            refreshToken: refreshToken,
            onRegisterReload: onRegisterBannerReload,
            onPresenceChanged: onBannerPresenceChanged,
          ),
        ),
        // Recommended cars list from LEFT
        _DelayedFadeSlide(
          delay: const Duration(milliseconds: 220),
          beginOffset: const Offset(-0.18, 0),
          child: const RecommendedSection(),
        ),
        // Rental cars list from LEFT

        // Combined filters row + content below cars
        _DelayedFadeSlide(
          delay: const Duration(milliseconds: 360),
          beginOffset: const Offset(0.18, 0),
          child: const CombinedFiltersBar(),
        ),
        8.verticalSpace,
        // Vertical cars list from LEFT (reactive to filters)
        _DelayedFadeSlide(
          delay: const Duration(milliseconds: 520),
          beginOffset: const Offset(-0.18, 0),
          duration: const Duration(milliseconds: 1000),
          child: SearchResultsVerticalList(
            bottomPadding: hasBanner ? 35.h : 0,
          ),
        ),
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
