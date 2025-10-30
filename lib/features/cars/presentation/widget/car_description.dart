import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';

class CarDescription extends StatefulWidget {
  final String description;
  const CarDescription({super.key, required this.description});

  @override
  State<CarDescription> createState() => _CarDescriptionState();
}

class _CarDescriptionState extends State<CarDescription> {
  final isCollapsed = ValueNotifier<bool>(true);

  @override
  void dispose() {
    super.dispose();
    isCollapsed.dispose();
  }

  bool canExpandText(String text, int trimLines) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: context.textTheme.titleMedium?.r),
      maxLines: trimLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 20);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final bool canExpand = canExpandText(widget.description, 5);

    return Padding(
      padding: HWEdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.verticalSpace,
          AppText(
            "Description",
            style: context.textTheme.bodySmall.s18.b.withColor(AppColors.grey),
          ),
          16.verticalSpace,
          ReadMoreText(
            widget.description,
            trimMode: TrimMode.Line,
            trimLines: 4,
            isCollapsed: isCollapsed,
            style: context.textTheme.titleMedium?.r,
            colorClickableText: Colors.white,
            trimCollapsedText: ' ',
            trimExpandedText: '',
          ),
          18.verticalSpace,
          if (canExpand)
            ValueListenableBuilder(
              valueListenable: isCollapsed,
              builder: (context, value, child) {
                return Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(180.w, 35.h)),
                      backgroundColor: WidgetStatePropertyAll(
                          AppColors.grey.withValues(alpha: 0.2)),
                    ),
                    onPressed: () => isCollapsed.value = !isCollapsed.value,
                    child: AppText(
                      value == true
                          ? 'See full description'
                          : 'See less description',
                      style: context.textTheme.titleSmall?.r,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
