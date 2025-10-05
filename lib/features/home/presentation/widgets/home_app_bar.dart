import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';
import 'package:wolfera/features/home/presentation/widgets/city_dropdown.dart';
import 'package:wolfera/generated/assets.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
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
                GRouter.router.pushNamed(GRouter.config.profileRoutes.profile);
              },
              child: const CirclueUserImageWidget(width: 40, height: 40),
            ),
          ],
        ),
        background: Container(
          color: AppColors.blackLight,
        ),
      ),
    );
  }
}
