import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/common/enums/exterior_features.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/extensions/exterior_features_extension.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/my_car/presentation/widgets/feautres_list_view.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

class ExteriorFeaturesDialog extends StatefulWidget {
  final Function(List<String>?) onItemSelected;

  const ExteriorFeaturesDialog({super.key, required this.onItemSelected});

  @override
  State<ExteriorFeaturesDialog> createState() => _ExteriorFeaturesDialogState();
}

class _ExteriorFeaturesDialogState extends State<ExteriorFeaturesDialog> {
  final Set<String> _selectedFeatures = {};

  final List<String> _exteriorFeatures =
      ExteriorFeature.values.map((e) => e.featureName).toList();

  void _onFeatureToggle(String selectedItem, bool isSelected) {
    setState(() {
      isSelected
          ? _selectedFeatures.add(selectedItem)
          : _selectedFeatures.remove(selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 650.h,
      padding: HWEdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          _buildHeader(context),
          15.verticalSpace,
          Expanded(
            child: DialogFeaturesListView(
              items: _exteriorFeatures,
              selectedItems: _selectedFeatures,
              onItemSelected: _onFeatureToggle,
            ),
          ),
          22.verticalSpace,
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            widget.onItemSelected(_selectedFeatures.toList());
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
              minimumSize: WidgetStatePropertyAll(
                Size(140.w, 45.h),
              )),
          child: AppText(
            'Confirm',
            style: context.textTheme.bodyMedium.b,
          ),
        ),
        10.horizontalSpace,
        ElevatedButton(
          onPressed: () {
            widget.onItemSelected([]);
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(AppColors.grey),
              minimumSize: WidgetStatePropertyAll(
                Size(35.w, 45.h),
              )),
          child: AppText(
            'Reset',
            style: context.textTheme.bodyMedium.b,
          ),
        ),
      ],
    );
  }

  GestureDetector dialogButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AppText(
        title,
        style: context.textTheme.bodyMedium.s18.b,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          'Exterior',
          style: context.textTheme.titleMedium?.s20.b,
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: AppColors.blackLight,
      borderRadius: BorderRadius.circular(10.r),
      boxShadow: const [
        BoxShadow(
          blurRadius: 8,
          color: AppColors.primary,
        )
      ],
    );
  }
}
