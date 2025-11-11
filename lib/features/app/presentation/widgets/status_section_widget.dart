import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';

class StatusSectionWidget extends StatelessWidget {
  const StatusSectionWidget({
    super.key,
    this.status,
  });
  
  final String? status;

  String _getStatusText() {
    if (status == null || status!.isEmpty) {
      return 'car_status.under_reviewing'.tr();
    }
    
    final statusKey = status!.toLowerCase();
    switch (statusKey) {
      case 'sold':
        return 'car_status.sold'.tr();
      case 'rented':
        return 'car_status.rented'.tr();
      case 'active':
        return 'car_status.active'.tr();
      case 'pending':
        return 'car_status.pending'.tr();
      case 'under_reviewing':
      default:
        return 'car_status.under_reviewing'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        2.verticalSpace,
        Divider(
          color: AppColors.grey,
          thickness: 1.r,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              '${'status_label'.tr()} : ${_getStatusText()}',
              style: context.textTheme.bodyLarge!.xb.withColor(AppColors.white),
            ))
      ],
    );
  }
}
