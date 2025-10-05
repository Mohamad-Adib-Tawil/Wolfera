import 'package:flutter/material.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';

class CustomDivider extends StatelessWidget {
  final double thickness;
  final double indent;
  final double endIndent;
  final Color color;
  final double? height;
  const CustomDivider({
    super.key,
    this.thickness = 0.5,
    this.indent = 0,
    this.endIndent = 0,
    this.color = AppColors.whiteLess,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      indent: indent,
      height: height,
      endIndent: endIndent,
      thickness: thickness,
    );
  }
}
