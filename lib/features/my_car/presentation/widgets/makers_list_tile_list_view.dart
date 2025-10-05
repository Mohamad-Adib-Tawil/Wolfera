import 'package:flutter/cupertino.dart';
import 'package:wolfera/common/enums/car_makers.dart';
import 'package:wolfera/features/my_car/presentation/widgets/makers_list_tile_item.dart';

class MakersSliverListTileListView extends StatelessWidget {
  final List<CarMaker> carMakers;
  final List<CarMaker> selectedMakers;
  final Function(CarMaker) onMakerSelected;

  const MakersSliverListTileListView({
    Key? key,
    required this.carMakers,
    required this.selectedMakers,
    required this.onMakerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final carMaker = carMakers[index];
          final isSelected = selectedMakers.contains(carMaker);

          return MakerListTileItem(
            context: context,
            name: carMaker.name,
            isSelected: isSelected,
            onTap: () => onMakerSelected(carMaker),
          );
        },
        childCount: carMakers.length,
      ),
    );
  }
}
