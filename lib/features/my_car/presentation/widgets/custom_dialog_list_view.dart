import 'package:flutter/material.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/my_car/presentation/widgets/custom_radio_button.dart';

class CustomDialogListView<T> extends StatefulWidget {
  final List<String> items;
  final void Function(String)? onItemSelected;

  const CustomDialogListView({
    super.key,
    required this.items,
    this.onItemSelected,
  });

  @override
  State<CustomDialogListView<T>> createState() =>
      _CustomDialogListViewState<T>();
}

class _CustomDialogListViewState<T> extends State<CustomDialogListView<T>> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      // physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return Padding(
          padding: HWEdgeInsets.only(top: 30),
          child: CustomRadioButton(
            title: item,
            isSelected: selectedIndex == index,
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              if (widget.onItemSelected != null) {
                widget.onItemSelected!(item);
              }
              Future.delayed(
                const Duration(milliseconds: 200),
                () => Navigator.of(context).pop(),
              );
            },
          ),
        );
      },
    );
  }
}
