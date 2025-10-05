import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/kilometers_list_view.dart';

class KilometersDialog extends StatefulWidget {
  final bool isMin;
  final VoidCallback? onReset;
  final Function(String) onSelectionConfirmed;

  const KilometersDialog({
    Key? key,
    required this.onSelectionConfirmed,
    required this.isMin,
    this.onReset,
  }) : super(key: key);

  @override
  State<KilometersDialog> createState() => _KilometersDialogState();
}

class _KilometersDialogState extends State<KilometersDialog> {
  String? selectedKilometers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: HWEdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          _buildHeader(context),
          20.verticalSpace,
          _buildKilometersContent(),
          20.verticalSpace,
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildKilometersContent() {
    return Expanded(
        child: KilometersListView(
            isMin: widget.isMin, onTap: widget.onSelectionConfirmed));
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.isMin ? "Min Kilometers" : "Max Kilometers",
          style: context.textTheme.bodyMedium.s20.b,
        ),
        IconButton(
          icon: const Icon(CupertinoIcons.xmark, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: widget.onReset,
      style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(AppColors.grey),
          minimumSize: WidgetStatePropertyAll(
            Size(75.w, 45.h),
          )),
      child: AppText(
        'Reset',
        style: context.textTheme.bodyMedium.b,
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: AppColors.blackLight,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [
        BoxShadow(
          blurRadius: 8,
          color: AppColors.primary,
        )
      ],
    );
  }
}
