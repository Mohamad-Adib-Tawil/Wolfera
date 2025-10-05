import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/common/enums/seats_filter.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/extensions/seats_extension.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/my_car/presentation/widgets/custom_dialog_list_view.dart';

class SeatsNumberDialog extends StatefulWidget {
  final Function(String)? onItemSelected;

  const SeatsNumberDialog({super.key, this.onItemSelected});

  @override
  State<SeatsNumberDialog> createState() => _TranmissionDialogState();
}

class _TranmissionDialogState extends State<SeatsNumberDialog> {
  @override
  Widget build(BuildContext context) {
    return _buildDialog(context);
  }

  final List<String> _seatsNumber =
      List.from(Seats.values.map((e) => e.displayName));

  Widget _buildDialog(BuildContext context) {
    return Container(
      height: 600.h,
      padding: HWEdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: _buildBoxDecoration(),
      child: Column(
        children: [
          _buildHeader(context),
          15.verticalSpace,
          Expanded(
              child: CustomDialogListView(
            items: _seatsNumber,
            onItemSelected: widget.onItemSelected,
          ))
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          'Seats Number',
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
