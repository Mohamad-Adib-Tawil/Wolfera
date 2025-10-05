import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class MakerListTileItem extends StatelessWidget {
  const MakerListTileItem({
    Key? key,
    required this.context,
    required this.name,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final BuildContext context;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 8.0,
      leading: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(Icons.circle_outlined),
      title: AppText(
        name,
        style: context.textTheme.titleMedium?.r
            .withColor(isSelected ? AppColors.primary : AppColors.white),
      ),
      onTap: onTap,
    );
  }
}
