import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text_button.dart';
import 'package:wolfera/generated/assets.dart';

class SellDialogBody extends StatelessWidget {
  const SellDialogBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HWEdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          10.verticalSpace,
          Center(child: AppSvgPicture(Assets.svgLogout, height: 50.r)),
          25.verticalSpace,
          AppText(
            "if you exit\nthe information will be lost",
            style: context.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          15.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppTextButton(
                text: "Keep",
                onPressed: () {
                  GRouter.router.pop();
                },
              ),
              AppTextButton(
                text: "Exit",
                // appButtonStyle: AppButtonStyle.secondary,
                onPressed: () {
                  GRouter.router.pop();
                  GRouter.router.pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
