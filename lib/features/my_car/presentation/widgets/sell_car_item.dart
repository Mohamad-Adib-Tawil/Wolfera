import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/animated_dialog.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/white_divider.dart';
import 'package:wolfera/features/my_car/presentation/widgets/custom_reactive_text_field.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

class SellCarItem extends StatelessWidget {
  final String title;
  final bool isDescription;
  final bool isDialog;
  final String formControlName;
  final Widget? dialogWidget;
  final Widget? prefix;
  final FormGroup? form;
  final TextInputType? textInputType;

  const SellCarItem(
      {super.key,
      required this.title,
      this.isDialog = false,
      required this.formControlName,
      this.dialogWidget,
      this.textInputType,
      this.prefix,
      this.isDescription = false,
      this.form});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isDialog && dialogWidget != null) {
          form?.unfocus(touched: false);

          AnimatedDialog.show(
            context,
            insetPadding:
                HWEdgeInsets.only(top: 60, left: 40, right: 40, bottom: 30),
            child: dialogWidget!,
            barrierDismissible: true,
            barrierLabel: "Dialog",
          );
        }
      },
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: ReactiveFormField<String, String>(
        formControlName: formControlName,
        builder: (field) {
          final control = field.control;
          return Container(
            margin: HWEdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: HWEdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        title,
                        style: context.textTheme.titleMedium?.b
                            .withColor(AppColors.grey),
                      ),
                      5.verticalSpace,
                      if (!isDialog) ...[
                        SizedBox(
                          height: isDescription ? 150.h : null,
                          child: CustomReactiveTextField(
                            formControlName: formControlName,
                            textStyle: context.textTheme.bodyLarge?.m
                                .withColor(AppColors.white),
                            textInputType: textInputType,
                            prefix: prefix,
                            maxLines: isDescription ? 8 : null,
                            textInputAction: isDescription
                                ? TextInputAction.newline
                                : TextInputAction.done,
                          ),
                        ),
                      ],
                      if (isDialog)
                        AppText(
                          control.touched && control.invalid
                              ? LocaleKeys.required
                              : control.value ?? "",
                          style: control.touched && control.invalid
                              ? context.textTheme.bodySmall?.m
                                  .withColor(AppColors.red.withOpacity(0.8))
                              : context.textTheme.bodyLarge?.m
                                  .withColor(AppColors.white),
                        ),
                    ],
                  ),
                ),
                4.verticalSpace,
                CustomDivider(
                  thickness: 0.5.r,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
