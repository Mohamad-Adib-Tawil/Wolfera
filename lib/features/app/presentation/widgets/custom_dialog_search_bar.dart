import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';

class CustomDialogSearchBar extends StatelessWidget {
  const CustomDialogSearchBar({
    super.key,
    required TextEditingController searchController,
    required this.hintText,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        hintText: hintText,
        contentPadding: HWEdgeInsetsDirectional.only(end: 22),
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Padding(
          padding: HWEdgeInsets.only(left: 28, right: 12.5),
          child: const Icon(CupertinoIcons.search, color: Colors.grey),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
      style: context.textTheme.bodyMedium?.s15.sb,
    );
  }
}
