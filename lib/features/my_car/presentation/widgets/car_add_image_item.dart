import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

class CarAddImageItem extends StatefulWidget {
  const CarAddImageItem({
    super.key,
    required this.text,
    required this.formControlName,
  });
  final String text;
  final String formControlName;

  @override
  State<CarAddImageItem> createState() => _CarAddImageItemState();
}

class _CarAddImageItemState extends State<CarAddImageItem> {
  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<File?, File?>(
      formControlName: widget.formControlName,
      builder: (field) {
        final control = field.control;
        return GestureDetector(
          onTap: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) {
                return CupertinoActionSheet(
                  title: const AppText(LocaleKeys.photoOptions),
                  actions: [
                    CupertinoActionSheetAction(
                      child: AppText(
                        LocaleKeys.chooseAnImageFromTheGallery,
                        style: context.textTheme.bodyLarge.b
                            .withColor(AppColors.white),
                      ),
                      onPressed: () {
                        pickImage(
                            source: ImageSource.gallery, control: control);
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: AppText(
                        LocaleKeys.takePictureFromTheCamera,
                        style: context.textTheme.bodyLarge.b
                            .withColor(AppColors.white),
                      ),
                      onPressed: () {
                        pickImage(source: ImageSource.camera, control: control);
                      },
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const AppText(LocaleKeys.cancel),
                  ),
                );
              },
            );
          },
          child: SizedBox(
            width: 150.w,
            child: Column(
              children: [
                Container(
                    width: 150.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                        image: control.value != null
                            ? DecorationImage(
                                image: FileImage(control.value!),
                                fit: BoxFit.cover)
                            : null,
                        color: control.value == null
                            ? AppColors.grey.withValues(alpha: .2)
                            : null,
                        border: control.touched && control.invalid
                            ? Border.all(color: AppColors.red)
                            : null,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: control.value == null
                        ? Stack(
                            children: [
                              Positioned(
                                top: 10,
                                right: 10,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.orange,
                                  radius: 10.r,
                                  child: const AppSvgPicture(Assets.svgPlusAdd),
                                ),
                              )
                            ],
                          )
                        : null),
                10.verticalSpace,
                Padding(
                  padding: HWEdgeInsets.symmetric(horizontal: 5),
                  child: AppText(
                    widget.text,
                    maxLines: 2,
                    style: context.textTheme.bodyMedium?.m.s14
                        .withColor(AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  pickImage(
      {required ImageSource source,
      required FormControl<File?> control}) async {
    final file = await ImagePicker().pickImage(source: source);

    if (file == null) return;

    if (mounted) {
      Navigator.pop(context);
    }
    final original = File(file.path);
    final compressed = await _compressIfNeeded(original);
    control.updateValue(compressed);
  }

  Future<File> _compressIfNeeded(File file) async {
    try {
      final size = await file.length();
      const threshold = 1024 * 1024; // 1MB
      if (size <= threshold) return file;

      final tmpDir = await getTemporaryDirectory();
      final targetPath =
          '${tmpDir.path}/wolfera_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // اضغط الصورة بجودة مناسبة للحفاظ على التفاصيل مع تقليل الحجم
      int quality = 80;
      if (size > 5 * threshold) {
        quality = 60;
      } else if (size > 2 * threshold) {
        quality = 70;
      }
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        format: CompressFormat.jpeg,
        keepExif: true,
      );

      if (result == null) return file;
      return File(result.path);
    } catch (_) {
      return file;
    }
  }
}
