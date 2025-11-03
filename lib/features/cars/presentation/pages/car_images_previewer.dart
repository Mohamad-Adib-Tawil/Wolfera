import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';
import 'package:wolfera/generated/assets.dart';

class CarImagesPreviewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const CarImagesPreviewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<CarImagesPreviewer> createState() => _CarImagesPreviewerState();
}

class _CarImagesPreviewerState extends State<CarImagesPreviewer> {
  late PageController pageController;
  late int selectedIndex;
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;

  @override
  void initState() {
    super.initState();
    selectedIndex = (widget.initialIndex >= 0 && widget.initialIndex < _images.length)
        ? widget.initialIndex
        : 0;
    pageController = PageController(initialPage: selectedIndex);
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
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
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: _shouldAnimateEntrance
              ? const DelayedFadeSlide(
                  delay: Duration(milliseconds: 100),
                  duration: Duration(milliseconds: 1000),
                  beginOffset: Offset(0, -0.24),
                  child: CustomAppbar(
                    automaticallyImplyLeading: true,
                  ),
                )
              : const CustomAppbar(
                  automaticallyImplyLeading: true,
                ),
        ),
        body: _shouldAnimateEntrance
            ? DelayedFadeSlide(
                delay: const Duration(milliseconds: 240),
                duration: const Duration(milliseconds: 1000),
                beginOffset: const Offset(-0.24, 0),
                child: _buildContent(),
              )
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: PhotoViewGallery.builder(
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              final src = _images[index];
              final isNetwork = src.startsWith('http://') || src.startsWith('https://');
              final ImageProvider<Object> provider = (isNetwork
                      ? NetworkImage(src)
                      : AssetImage(src))
                  as ImageProvider<Object>;
              return PhotoViewGalleryPageOptions(
                imageProvider: provider,
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(tag: src),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
              );
            },
            itemCount: _images.length,
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
            itemCount: _images.length,
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              final src = _images[index];
              final isNetwork = src.startsWith('http://') || src.startsWith('https://');
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
                    child: isNetwork
                        ? Image.network(
                            src,
                            width: 110.w,
                            height: 70.h,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            src,
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
    );
  }

  List<String> get _images => widget.images.isNotEmpty
      ? widget.images
      : [
          Assets.imagesCar1,
          Assets.imagesCar2,
          Assets.imagesCar1,
          Assets.imagesCar2,
        ];
}
