import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/generated/assets.dart';

class CarImagesPreviewer extends StatefulWidget {
  const CarImagesPreviewer({
    super.key,
  });

  @override
  State<CarImagesPreviewer> createState() => _CarImagesPreviewerState();
}

class _CarImagesPreviewerState extends State<CarImagesPreviewer> {
  late PageController pageController;
  final List<String> images = [
    Assets.imagesCar1,
    Assets.imagesCar2,
    Assets.imagesCar1,
    Assets.imagesCar2,
    Assets.imagesCar1,
    Assets.imagesCar2,
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppbar(
          automaticallyImplyLeading: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: PhotoViewGallery.builder(
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: AssetImage(images[index]),
                    initialScale: PhotoViewComputedScale.contained,
                    heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
                  );
                },
                itemCount: images.length,
                loadingBuilder: (context, event) => Center(
                  child: SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null || event.expectedTotalBytes == null
                          ? null
                          : event.cumulativeBytesLoaded /
                              (event.expectedTotalBytes ?? 1),
                    ),
                  ),
                ),
                pageController: pageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
            10.verticalSpace,
            SizedBox(
              height: 70.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 1.r)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          images[index],
                          width: 110.w,
                          height: 70.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }
}
