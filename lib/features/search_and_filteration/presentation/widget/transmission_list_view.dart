import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/enums/transmission_type.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/text_with_border_item_widget.dart';

class TransmissionListView extends StatelessWidget {
  const TransmissionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          padding: HWEdgeInsets.only(right: 10),
          scrollDirection: Axis.horizontal,
          itemCount: TransmissionType.values.length,
          itemBuilder: (context, index) {
            final item = TransmissionType.values[index];
            final isSelected = item.name == state.selectedTransmission;
            return TextWithBorderItemWidget(
                title: item.name,
                isSelected: isSelected,
                onTap: () =>
                    context.read<SearchCubit>().selectTransmission(item.name));
          },
        );
      },
    );
  }
}
