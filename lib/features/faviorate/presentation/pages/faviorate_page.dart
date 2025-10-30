import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_empty_state_widet/app_empty_state.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_cubit.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_state.dart';
import 'package:wolfera/features/home/presentation/widgets/cars_list_view_builder.dart';

class FavioratePage extends StatefulWidget {
  const FavioratePage({super.key});

  @override
  State<FavioratePage> createState() => _FavioratePageState();
}

class _FavioratePageState extends State<FavioratePage> {
  // Run entrance animation once per session
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;

  @override
  void initState() {
    super.initState();
    // إعادة تحميل المفضلات عند فتح الصفحة لضمان عرض البيانات الفعلية
    Future.microtask(() => context.read<FavoriteCubit>().init());
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _shouldAnimateEntrance
            ? _DelayedFadeSlide(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 1000),
                beginOffset: const Offset(0, -0.24),
                child: CustomAppbar(
                  text: 'Faviorate'.tr(),
                  automaticallyImplyLeading: false,
                ),
              )
            : CustomAppbar(
                text: 'Faviorate'.tr(),
                automaticallyImplyLeading: false,
              ),
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          final list = state.favoriteCars;
          if (list.isEmpty) {
            final empty = Center(child: AppEmptyState.favoritesEmpty());
            return _shouldAnimateEntrance
                ? _DelayedFadeSlide(
                    delay: const Duration(milliseconds: 220),
                    duration: const Duration(milliseconds: 1000),
                    beginOffset: const Offset(0, -0.24),
                    child: empty,
                  )
                : empty;
          }

          // عرض قائمة المفضلة باستخدام نفس تصميم بطاقات السيارات
          final listView = CarsListViewBuilder(
            scrollDirection: Axis.vertical,
            padding:
                HWEdgeInsetsDirectional.only(start: 14, end: 14, top: 10),
            cars: list,
          );
          return _shouldAnimateEntrance
              ? _DelayedFadeSlide(
                  delay: const Duration(milliseconds: 360),
                  duration: const Duration(milliseconds: 1000),
                  beginOffset: const Offset(-0.24, 0),
                  child: listView,
                )
              : listView;
        },
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
