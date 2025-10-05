import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:flutter/foundation.dart' as foundation;

class EmojiPickerWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isEmojiPickerVisible;

  const EmojiPickerWidget({
    Key? key,
    required this.controller,
    required this.isEmojiPickerVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isEmojiPickerVisible,
      child: SizedBox(
        height: 250.h,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            controller.text += emoji.emoji;
          },
          onBackspacePressed: () {
            controller.text = controller.text.characters.skipLast(1).toString();
          },
          config: Config(
            height: 256.h,
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              backgroundColor: AppColors.blackLight,
              buttonMode: ButtonMode.CUPERTINO,
              emojiSizeMax: 28 *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.20
                      : 1.0),
            ),
            skinToneConfig: const SkinToneConfig(),
            categoryViewConfig: const CategoryViewConfig(
                backgroundColor: AppColors.blackLight,
                iconColorSelected: AppColors.primary,
                backspaceColor: AppColors.primary,
                indicatorColor: AppColors.primary,
                iconColor: AppColors.grey,
                dividerColor: AppColors.grey),
            bottomActionBarConfig: const BottomActionBarConfig(
              enabled: false,
            ),
            searchViewConfig: const SearchViewConfig(),
          ),
        ),
      ),
    );
  }
}
