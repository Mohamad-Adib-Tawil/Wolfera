import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? text;
  final bool automaticallyImplyLeading;
  final bool? goToHome;
  final Widget? action;
  const CustomAppbar(
      {super.key,
      this.text,
      this.automaticallyImplyLeading = false,
      this.goToHome,
      this.action});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        child: AppBar(
            backgroundColor: Colors.transparent,
            title: text != null
                ? AppText(
                    text!,
                    style: context.textTheme.titleMedium.s20.m,
                  )
                : null,
            centerTitle: true,
            leading: automaticallyImplyLeading
                ? GestureDetector(
                    onTap: () => GoRouter.of(context).pop(),
                    child: Container(
                      height: 35.h,
                      width: 35.w,
                      padding:
                          HWEdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: AppSvgPicture(
                        Assets.svgArrowLeft,
                        height: 35.h,
                        width: 35.w,
                      ),
                    ),
                  )
                : const SizedBox(),
            actions: [action ?? const SizedBox()],
            automaticallyImplyLeading: automaticallyImplyLeading));
  }
}
