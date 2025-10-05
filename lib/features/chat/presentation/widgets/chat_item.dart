import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/circlue_user_image_widget.dart';

class ChatItem extends StatelessWidget {
  final int? index;
  final VoidCallback? onTap;
  const ChatItem({super.key, this.onTap, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CirclueUserImageWidget(
            width: 55,
            userImage: Faker()
                .image
                .loremPicsum(random: index, height: 200, width: 200),
          ),
          14.horizontalSpace,
          Padding(
            padding: HWEdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileName(context),
                8.verticalSpace,
                lastMessage(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ConstrainedBox lastMessage(BuildContext context) {
    final vehicle = Faker().vehicle;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 0, maxWidth: 210.w),
      child: AppText(
        vehicle.colorYearMakeModel(),
        style: context.textTheme.titleSmall.s13.l.withColor(AppColors.grey),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  SizedBox profileName(BuildContext context) {
    DateTime dateTime = Faker().date.dateTime();
    return SizedBox(
      width: 265.w,
      child: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 0, maxWidth: 210.w),
            child: AppText(
              Faker().person.name(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium.s15.r,
            ),
          ),
          const Spacer(),
          AppText(
            DateFormat('EEE').format(dateTime),
            style: context.textTheme.titleMedium?.copyWith(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
