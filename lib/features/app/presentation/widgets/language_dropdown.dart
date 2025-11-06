import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:country_flags/country_flags.dart';
import 'package:wolfera/services/supabase_service.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: context.locale,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.white,
            size: 20.sp,
          ),
          dropdownColor: AppColors.blackLight,
          style: context.textTheme.bodyMedium.m.withColor(AppColors.white),
          items: [
            DropdownMenuItem<Locale>(
              value: const Locale('ar'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountryFlag.fromCountryCode(
                    'SY',
                    theme: const ImageTheme(
                      width: 20,
                      height: 14,
                      shape: RoundedRectangle(4),
                    ),
                  ),
                  8.horizontalSpace,
                  AppText(
                    'عربي'.tr(),
                    style: context.textTheme.bodyMedium.m
                        .withColor(AppColors.white),
                  ),
                ],
              ),
            ),
            DropdownMenuItem<Locale>(
              value: const Locale('en'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountryFlag.fromCountryCode(
                    'US',
                    theme: const ImageTheme(
                      width: 20,
                      height: 14,
                      shape: RoundedRectangle(4),
                    ),
                  ),
                  8.horizontalSpace,
                  AppText(
                    'English'.tr(),
                    style: context.textTheme.bodyMedium.m
                        .withColor(AppColors.white),
                  ),
                ],
              ),
            ),
          ],
          onChanged: (Locale? newLocale) async {
            if (newLocale == null) return;
            await context.setLocale(newLocale);
            final code = newLocale.languageCode;
            await SupabaseService.updateUserLanguage(code);
          },
        ),
      ),
    );
  }
}
