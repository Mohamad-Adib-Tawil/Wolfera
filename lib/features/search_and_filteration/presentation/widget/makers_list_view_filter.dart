import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/enums/car_makers.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'maker_item_filter_widget.dart';

class MakersListViewFilter extends StatelessWidget {
  const MakersListViewFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: CarMaker.values.length,
          padding: const EdgeInsets.only(left: 10),
          itemBuilder: (context, index) {
            bool isSelected = state.selectedCarMakersFilter
                .contains(CarMaker.values[index].name);

            return MakerItemFilterWidget(
              makersLogoPath: CarMaker.values[index].logoAsset,
              isSelected: isSelected,
              onTap: () {
                context
                    .read<SearchCubit>()
                    .toggleMakerSelection(CarMaker.values[index].name);
              },
            );
          },
        );
      },
    );
  }
}
