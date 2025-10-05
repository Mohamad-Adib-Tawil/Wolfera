import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/cars/presentation/widget/contect_button.dart';
import 'package:wolfera/features/cars/presentation/widget/user_section_with_location.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';
import 'package:wolfera/generated/assets.dart';

class SellerSctionDetalis extends StatelessWidget {
  const SellerSctionDetalis({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Seller',
            style: context.textTheme.bodyLarge!.s17.b.withColor(AppColors.grey),
          ),
          14.verticalSpace,
          const UserSectionWithLocation(),
          29.verticalSpace,
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ContectButton(svg: Assets.svgPhone, title: 'Call'),
              ContectButton(svg: Assets.svgWhatsapp, title: 'Chat'),
              ContectButton(svg: Assets.svgEmail, title: 'Email'),
            ],
          ),
          18.verticalSpace,
          ContectButton(
              textWidth: 260.w,
              svg: Assets.svgMessageSquare,
              title: 'Send Message to Mohammad'),
          15.verticalSpace,
          CustomDivider(color: AppColors.grey, thickness: 1.r),
          10.verticalSpace,
        ],
      ),
    );
  }
}
