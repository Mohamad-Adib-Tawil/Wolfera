import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/cars/presentation/widget/car_image_viewer.dart';
import 'package:wolfera/generated/assets.dart';

class MoreImagesCarsList extends StatefulWidget {
  final List<String>? images;
  
  const MoreImagesCarsList({
    super.key,
    this.images,
  });

  @override
  State<MoreImagesCarsList> createState() => _MoreImagesCarsListState();
}

class _MoreImagesCarsListState extends State<MoreImagesCarsList> {
  int selectedIndex = 0;
  
  List<String> get carImages => widget.images?.isNotEmpty == true 
      ? widget.images! 
      : [
          Assets.imagesCar1,
          Assets.imagesCar2,
          Assets.imagesCar1,
          Assets.imagesCar2,
        ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => GRouter.router.pushNamed(
            GRouter.config.carRoutes.carImagesPreviewer,
            extra: {
              'images': carImages,
              'initialIndex': selectedIndex,
            },
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: CarImageViewer(
              key: ValueKey<String>(carImages[selectedIndex]),
              imagePath: carImages[selectedIndex],
              heroTag: carImages[selectedIndex],
            ),
          ),
        ),
        14.verticalSpace,
        SizedBox(
          height: 70.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: carImages.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              bool isSelected = selectedIndex == index;

              return Padding(
                padding: HWEdgeInsets.only(left: 11),
                child: GestureDetector(
                  onTap: () => setState(() {
                    selectedIndex = index;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isSelected ? 110.w : 100.w,
                    height: isSelected ? 80.h : 70.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
                        width: isSelected ? 2.r : 0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CarImageViewer(
                      imagePath: carImages[index],
                      isSelected: isSelected,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
