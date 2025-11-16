import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/my_car/presentation/widgets/sell_car_item.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:wolfera/core/constants/currencies.dart';
import 'package:wolfera/features/app/presentation/widgets/app_dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';

class RentalPriceSection extends StatelessWidget {
  final FormGroup rentalPricesForm;
  final String currencyCode;
  final ValueChanged<CurrencyOption> onCurrencyChanged;

  const RentalPriceSection({
    super.key,
    required this.rentalPricesForm,
    required this.currencyCode,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: rentalPricesForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'rental_prices',
            style: context.textTheme.titleMedium?.b.withColor(AppColors.white),
          ),
          10.verticalSpace,
          AppText(
            'set_rental_prices_desc',
            style: context.textTheme.bodySmall?.withColor(AppColors.grey),
          ),
          20.verticalSpace,
          _buildPriceField(
            context: context,
            title: 'rental_periods.per_day',
            formControlName: 'rental_price_per_day',
            hint: 'e.g. 50',
          ),
          _buildPriceField(
            context: context,
            title: 'rental_periods.per_week',
            formControlName: 'rental_price_per_week',
            hint: 'e.g. 300',
          ),
          _buildPriceField(
            context: context,
            title: 'rental_periods.per_month',
            formControlName: 'rental_price_per_month',
            hint: 'e.g. 1000',
          ),
          _buildPriceField(
            context: context,
            title: 'rental_periods.per_3months',
            formControlName: 'rental_price_per_3months',
            hint: 'e.g. 2700',
          ),
          _buildPriceField(
            context: context,
            title: 'rental_periods.per_6months',
            formControlName: 'rental_price_per_6months',
            hint: 'e.g. 5000',
          ),
          _buildPriceField(
            context: context,
            title: 'rental_periods.per_year',
            formControlName: 'rental_price_per_year',
            hint: 'e.g. 9000',
          ),
        ],
      ),
    );
  }

  Widget _buildPriceField({
    required BuildContext context,
    required String title,
    required String formControlName,
    required String hint,
  }) {
    return Padding(
      padding: HWEdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              title,
              style: context.textTheme.bodyMedium?.m.withColor(AppColors.white),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            flex: 3,
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.greyStroke),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: AppDropdownSearch<CurrencyOption>(
                      items: CurrenciesData.list,
                      selectedItem: CurrenciesData.findByCode(currencyCode) ?? CurrenciesData.defaultCurrency(),
                      itemAsString: (c) => c.symbol,
                      hintText: 'currency'.tr(),
                      dropdownBuilder: (context, c) => Text(
                        (c?.symbol ?? r'$'),
                        style: context.textTheme.bodySmall?.m.withColor(AppColors.white),
                      ),
                      popupProps: PopupProps.menu(
                        showSearchBox: false,
                        itemBuilder: (ctx, c, isSel) => Padding(
                          padding: HWEdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Text(c.symbol, style: context.textTheme.titleSmall?.b),
                              10.horizontalSpace,
                              Expanded(child: Text('${c.code} - ${c.name}')),
                            ],
                          ),
                        ),
                      ),
                      dropdownButtonProps: DropdownButtonProps(
                        icon: Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.white),
                      ),
                      onChanged: (c) {
                        if (c == null) return;
                        onCurrencyChanged(c);
                      },
                      borderColor: Colors.transparent,
                      filled: false,
                      contentPadding: HWEdgeInsetsDirectional.only(start: 6, end: 4),
                      baseStyle: context.textTheme.bodySmall?.m.withColor(AppColors.white),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30.h,
                    color: AppColors.greyStroke,
                  ),
                  Expanded(
                    child: ReactiveTextField(
                      formControlName: formControlName,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: false,
                      ),
                      style: context.textTheme.bodyMedium?.withColor(AppColors.white),
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: context.textTheme.bodySmall?.withColor(AppColors.grey.withOpacity(0.5)),
                        border: InputBorder.none,
                        contentPadding: HWEdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
