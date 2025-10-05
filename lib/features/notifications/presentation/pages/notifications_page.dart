import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackLight,
      appBar: CustomAppbar(
        text: 'Notifications'.tr(),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            20.verticalSpace,
            const NotificationItemWidget(),
            const NotificationItemWidget(),
            const NotificationItemWidget(),
            const NotificationItemWidget(),
            const NotificationItemWidget(),
            const NotificationItemWidget(),
            const NotificationItemWidget(),
            const NotificationItemWidget(),
            const NotificationItemWidget(),
          ],
        ),
      ),
    );
  }
}

class NotificationItemWidget extends StatelessWidget {
  const NotificationItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: HWEdgeInsets.all(20),
      margin: HWEdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: context.mediaQuery.size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.white,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'From Mohamad Adib Tawil'.tr(),
            style:
                context.textTheme.bodyLarge?.b.s15.withColor(AppColors.white),
          ),
          10.verticalSpace,
          AppText(
            "Let's go".tr(),
            style: context.textTheme.bodyLarge?.s14.withColor(AppColors.white),
          ),
        ],
      ),
    );
  }
}
