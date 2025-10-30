import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/bloc/app_manager_cubit.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';
import 'package:wolfera/features/home/presentation/widgets/city_dropdown.dart';
import 'package:wolfera/generated/assets.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    this.animate = false,
  });

  final bool animate;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      toolbarHeight: 65.0.h,
      expandedHeight: 65.0.h,
      backgroundColor: AppColors.blackLight,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        centerTitle: true,
        title: Builder(
          builder: (context) {
            final baseChildren = <Widget>[
              GestureDetector(
                onTap: () {
                  GRouter.router.pushNamed(
                      GRouter.config.notificationsRoutes.notifications);
                },
                child: AppSvgPicture(
                  Assets.svgBell,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              CityDropdown(
                onChanged: (m) {},
              ),
              GestureDetector(
                onTap: () {
                  GRouter.router
                      .pushNamed(GRouter.config.profileRoutes.profile);
                },
                child: BlocBuilder<AppManagerCubit, AppManagerState>(
                  builder: (context, state) {
                    final imageUrl = state.user?.photoURL;
                    return CirclueUserImageWidget(
                      width: 40,
                      height: 40,
                      userImage: (imageUrl != null && imageUrl.isNotEmpty)
                          ? imageUrl
                          : null,
                    );
                  },
                ),
              ),
            ];

            if (!animate) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: baseChildren,
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DelayedFadeSlide(
                  delay: const Duration(milliseconds: 80),
                  duration: const Duration(milliseconds: 1000),
                  beginOffset: const Offset(0, -0.24),
                  child: baseChildren[0],
                ),
                _DelayedFadeSlide(
                  delay: const Duration(milliseconds: 220),
                  duration: const Duration(milliseconds: 1000),
                  beginOffset: const Offset(0, -0.24),
                  child: baseChildren[1],
                ),
                _DelayedFadeSlide(
                  delay: const Duration(milliseconds: 360),
                  duration: const Duration(milliseconds: 1000),
                  beginOffset: const Offset(0, -0.24),
                  child: baseChildren[2],
                ),
              ],
            );
          },
        ),
        background: Container(
          color: AppColors.blackLight,
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
