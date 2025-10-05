import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/enums/seats_filter.dart';
import 'package:wolfera/core/utils/extensions/seats_extension.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/text_with_border_item_widget.dart';

class SeatsListView extends StatelessWidget {
  const SeatsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          padding: HWEdgeInsets.only(left: 4, right: 10),
          scrollDirection: Axis.horizontal,
          itemCount: Seats.values.length,
          itemBuilder: (context, index) {
            final item = Seats.values[index];
            final isSelected = item.name == state.seletedSeatsCount;
            return TextWithBorderItemWidget(
                title: item.displayName,
                isSelected: isSelected,
                onTap: () =>
                    context.read<SearchCubit>().selectSeats(item.name));
          },
        );
      },
    );
  }
}
