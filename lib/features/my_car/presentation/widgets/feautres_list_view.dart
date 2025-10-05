import 'package:flutter/material.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/my_car/presentation/widgets/custom_check_box_button.dart';

class DialogFeaturesListView<T> extends StatelessWidget {
  final List<String> items;
  final Set<String> selectedItems;
  final void Function(String, bool)? onItemSelected;

  const DialogFeaturesListView({
    super.key,
    required this.items,
    required this.selectedItems,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: HWEdgeInsets.only(bottom: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = selectedItems.contains(item);

        return Padding(
          padding: HWEdgeInsets.only(top: 20),
          child: CustomCheckBoxButton(
            title: item,
            isSelected: isSelected,
            onTap: () {
              onItemSelected?.call(item, !isSelected); // Toggle selection
            },
          ),
        );
      },
    );
  }
}
