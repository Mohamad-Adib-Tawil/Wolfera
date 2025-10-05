import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';

class CarDetalisAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CarDetalisAppbar({
    super.key,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  PreferredSizeWidget build(BuildContext context) {
    return CustomAppbar(
      automaticallyImplyLeading: true,
      action: Padding(
        padding: HWEdgeInsetsDirectional.only(end: 20, top: 5),
        child: Icon(
          CupertinoIcons.heart,
          size: 30.r,
        ),
      ),
    );
  }
}
