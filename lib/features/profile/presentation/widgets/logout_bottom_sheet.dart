import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'logout_bottom_sheet_body.dart';

class LogoutBottomSheet extends StatefulWidget {
  const LogoutBottomSheet({super.key});

  @override
  State<LogoutBottomSheet> createState() => _LogoutBottomSheetState();
  static Future<void> showBasicModalBottomSheet(
    BuildContext context,
  ) async {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return const LogoutBottomSheet();
      },
    );
  }
}

class _LogoutBottomSheetState extends State<LogoutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: HWEdgeInsets.symmetric(horizontal: 30, vertical: 30),
      decoration: BoxDecoration(
        color: AppColors.blackLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60.r),
          topRight: Radius.circular(60.r),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.whiteLess,
            width: 1.w,
          ),
          left: BorderSide(
            color: AppColors.whiteLess,
            width: 1.w,
          ),
          right: BorderSide(
            color: AppColors.whiteLess,
            width: 1.w,
          ),
        ),
      ),
      width: 1.sw,
      child: const LogoutBottomSheetBody(),
    );
  }
}
