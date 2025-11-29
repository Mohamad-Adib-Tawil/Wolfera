import 'package:flutter/cupertino.dart';
import 'package:wolfera/common/enums/car_makers.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/my_car/presentation/widgets/car_logo_item.dart';

class CarLogoSliverGrid extends StatelessWidget {
  final List<CarMaker> selectedCarMakers;
  final Function(CarMaker) onMakerSelected;
  final bool isMultiSelect;
  const CarLogoSliverGrid({
    super.key,
    required this.selectedCarMakers,
    required this.onMakerSelected,
    required this.isMultiSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: HWEdgeInsets.only(top: 30, right: 8, left: 8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final maker = CarMaker.values[index];
            // Some logos work better without a forced color. Use null to keep original.
            final forceWhite = <CarMaker>{
              CarMaker.mercedes,
              CarMaker.volkswagen,
              CarMaker.honda,
              CarMaker.audi,
              CarMaker.jeep,
            };
            return CarLogoItem(
              onTap: () => onMakerSelected(maker),
              isSelected: selectedCarMakers.contains(maker),
              assetPath: maker.logoAsset,
              svgColor: forceWhite.contains(maker) ? AppColors.white : null,
              label: maker.name,
            );
          },
          childCount: CarMaker.values.length,
        ),
      ),
    );
  }
}
