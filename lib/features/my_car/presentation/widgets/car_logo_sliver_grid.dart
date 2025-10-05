import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:wolfera/common/enums/car_makers.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/my_car/presentation/widgets/car_logo_item.dart';
import 'package:wolfera/generated/assets.dart';

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
        delegate: SliverChildListDelegate(
          [
            CarLogoItem(
                onTap: () => onMakerSelected(CarMaker.mercedes),
                isSelected: selectedCarMakers.contains(CarMaker.mercedes),
                assetPath: Assets.makersMercedes,
                svgColor: AppColors.white),
            CarLogoItem(
                onTap: () => onMakerSelected(CarMaker.bmw),
                isSelected: selectedCarMakers.contains(CarMaker.bmw),
                assetPath: Assets.makersBmwWhiteBlack,
                svgColor: null),
            CarLogoItem(
                onTap: () => onMakerSelected(CarMaker.volkswagen),
                isSelected: selectedCarMakers.contains(CarMaker.volkswagen),
                assetPath: Assets.makersVolkswagen,
                svgColor: AppColors.white),
            CarLogoItem(
                onTap: () => onMakerSelected(CarMaker.honda),
                isSelected: selectedCarMakers.contains(CarMaker.honda),
                assetPath: Assets.makersHonda,
                svgColor: AppColors.white),
            CarLogoItem(
                onTap: () => onMakerSelected(CarMaker.jeep),
                isSelected: selectedCarMakers.contains(CarMaker.jeep),
                assetPath: Assets.makersJeep,
                svgColor: AppColors.white),
            CarLogoItem(
                onTap: () => onMakerSelected(CarMaker.audi),
                isSelected: selectedCarMakers.contains(CarMaker.audi),
                assetPath: Assets.makersAudi,
                svgColor: AppColors.white),
          ],
        ),
      ),
    );
  }
}
