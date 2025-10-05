import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/common/enums/car_color.dart';
import 'package:wolfera/core/utils/extensions/color_extension.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/my_car/presentation/widgets/custom_radio_button.dart';

class ColorsListView extends StatefulWidget {
  final List<CarColor> items;

  final void Function(String)? onItemSelected;

  const ColorsListView({
    super.key,
    required this.items,
    this.onItemSelected,
  });

  @override
  State<ColorsListView> createState() => _ColorsListViewState();
}

class _ColorsListViewState extends State<ColorsListView> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: HWEdgeInsets.only(bottom: 20),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return Padding(
          padding: HWEdgeInsets.only(top: 20),
          child: CustomRadioButton(
            title: item.name,
            leading: cirleColorWidget(item),
            isSelected: selectedIndex == index,
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              if (widget.onItemSelected != null) {
                widget.onItemSelected!(item.name);
              }
              Future.delayed(
                const Duration(milliseconds: 200),
                () => context.pop(),
              );
            },
          ),
        );
      },
    );
  }

  Container cirleColorWidget(CarColor item) {
    return Container(
      height: 20.h,
      width: 20.w,
      decoration: BoxDecoration(color: item.colorValue, shape: BoxShape.circle),
    );
  }
}
