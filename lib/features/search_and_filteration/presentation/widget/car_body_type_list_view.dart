import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/enums/vehicle_types.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/car_type_item.dart';

class CarBodyTypeListView extends StatelessWidget {
  const CarBodyTypeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          padding: HWEdgeInsets.only(left: 8, right: 10),
          scrollDirection: Axis.horizontal,
          itemCount: VehicleType.values.length,
          itemBuilder: (context, index) {
            final item = VehicleType.values[index];
            final isSelected = item.name == state.seletedBodyType;
            return CarTypeItem(
                vehicleType: item,
                isSelected: isSelected,
                onTap: () =>
                    context.read<SearchCubit>().selectBodyType(item.name));
          },
        );
      },
    );
  }
}
