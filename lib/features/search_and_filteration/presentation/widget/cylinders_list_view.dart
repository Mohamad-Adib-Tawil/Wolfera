import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/enums/cylinders.dart';
import 'package:wolfera/core/utils/extensions/cylinders_extension.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/text_with_border_item_widget.dart';

class CylindersListView extends StatelessWidget {
  const CylindersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          padding: HWEdgeInsets.only(left: 4, right: 10),
          scrollDirection: Axis.horizontal,
          itemCount: Cylinders.values.length,
          itemBuilder: (context, index) {
            final item = Cylinders.values[index];
            final isSelected = item.name == state.seletedCylinders;
            return TextWithBorderItemWidget(
                title: item.displayName,
                isSelected: isSelected,
                onTap: () =>
                    context.read<SearchCubit>().selectCylinders(item.name));
          },
        );
      },
    );
  }
}
