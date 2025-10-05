import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';
import 'package:wolfera/generated/assets.dart';

class ChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppbar({
    super.key,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: AppBar(
          toolbarHeight: 58.h,
          titleSpacing: 10.w,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 3.5),
                child: CirclueUserImageWidget(width: 42),
              ),
              14.horizontalSpace,
              AppText(
                "Mohamad Adib Tawil",
                style: context.textTheme.titleMedium?.s20.m,
              ),
            ],
          ),
          // centerTitle: true,
          leading: GestureDetector(
            onTap: () => GoRouter.of(context).pop(),
            child: Container(
              height: 35.h,
              width: 35.w,
              padding: HWEdgeInsets.only(left: 8, top: 5, bottom: 5),
              child: AppSvgPicture(
                Assets.svgArrowLeft,
                height: 35.h,
                width: 35.w,
              ),
            ),
          ),
          automaticallyImplyLeading: true),
    );
  }
}
