import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/enums/car_makers.dart';
import 'package:wolfera/core/utils/extensions/parse_string_to_enum.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/animated_dialog.dart';
import 'package:wolfera/features/my_car/presentation/widgets/makers_dialog.dart';
import 'package:wolfera/features/my_car/presentation/widgets/models_dialog.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/see_full_list_button_widget.dart';

class ShowCarMakersListViewWidget extends StatelessWidget {
  const ShowCarMakersListViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    return SeeFullListButtonWidget(
        onTap: () => AnimatedDialog.show(
              context,
              insetPadding:
                  HWEdgeInsets.only(top: 60, left: 40, right: 40, bottom: 30),
              child: CarsMakersDialog(
                isMultiSelect: true,
                selectedCarMakers: searchCubit.state.selectedCarMakersFilter
                    .map((e) => e.toEnum())
                    .toList(),
                onSelectionConfirmed: (selectedMakers) {
                  if (selectedMakers is List<CarMaker>) {
                    for (CarMaker carMaker in selectedMakers) {
                      searchCubit.toggleMakerSelection(carMaker.name);
                    }
                    // Auto-open models dialog immediately after makers selection
                    AnimatedDialog.show(
                      context,
                      insetPadding: HWEdgeInsets.only(top: 60, left: 40, right: 40, bottom: 30),
                      child: CarModelsDialog(
                        isMultiSelect: true,
                        makers: selectedMakers,
                        selectedModels: searchCubit.state.selectedCarModelsFilter,
                        includeAllOption: true,
                        onSelectionConfirmed: (selected) {
                          if (selected is List<String>) {
                            searchCubit.setModelsSelection(selected);
                          } else {
                            searchCubit.resetModelSelectionFilter();
                          }
                        },
                      ),
                      barrierDismissible: true,
                      barrierLabel: 'ModelsDialogAfterMakers',
                    );
                  } else {
                    searchCubit.resetMakerSelectionFilter();
                  }
                },
              ),
              barrierDismissible: true,
              barrierLabel: "MakersDialog",
            ));
  }
}
