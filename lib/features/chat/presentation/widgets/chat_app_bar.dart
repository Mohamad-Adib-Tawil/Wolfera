import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final String? otherUserName;
  final String? carTitle;
  final String? otherUserAvatar;
  final VoidCallback? onTapHeader;
  
  const ChatAppbar({
    super.key,
    this.otherUserName,
    this.carTitle,
    this.otherUserAvatar,
    this.onTapHeader,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 58.h,
      titleSpacing: 10.w,
      backgroundColor: Colors.transparent,
      title: InkWell(
        onTap: onTapHeader,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3.5),
              child: CirclueUserImageWidget(
                width: 42,
                userImage: otherUserAvatar,
              ),
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    otherUserName ?? 'Seller'.tr(),
                    style: context.textTheme.titleMedium?.s18.m,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    translation: false,
                  ),
                  if (carTitle != null && carTitle!.isNotEmpty)
                    AppText(
                      carTitle!,
                      style: context.textTheme.bodySmall?.s13,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      translation: false,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      leading: GestureDetector(
        onTap: () => GoRouter.of(context).pop(),
        child: Container(
          height: 35.h,
          width: 35.w,
          padding: HWEdgeInsets.only(left: 8, top: 5, bottom: 5),
          child: Transform.rotate(
            angle: context.locale.languageCode == 'ar' ? 3.14 : 0,
            child: AppSvgPicture(
              Assets.svgArrowLeft,
              height: 35.h,
              width: 35.w,
            ),
          ),
        ),
      ),
      automaticallyImplyLeading: true,
    );
  }
}
