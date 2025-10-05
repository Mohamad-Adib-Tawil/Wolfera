import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';

class CirclarCheckIcon extends StatelessWidget {
  const CirclarCheckIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.white,
      radius: (75 / 2).r,
      child: const Icon(
        CupertinoIcons.check_mark,
        weight: 40,
        size: 35,
      ),
    );
  }
}
