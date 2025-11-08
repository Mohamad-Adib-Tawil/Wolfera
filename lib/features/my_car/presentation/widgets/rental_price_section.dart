import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/my_car/presentation/widgets/sell_car_item.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RentalPriceSection extends StatelessWidget {
  final FormGroup rentalPricesForm;
  final String currencySymbol;

  const RentalPriceSection({
    super.key,
    required this.rentalPricesForm,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: rentalPricesForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Rental Prices',
            style: context.textTheme.titleMedium?.b.withColor(AppColors.white),
            translation: false,
          ),
          10.verticalSpace,
          AppText(
            'Set your rental prices for different periods',
            style: context.textTheme.bodySmall?.withColor(AppColors.grey),
            translation: false,
          ),
          20.verticalSpace,
          _buildPriceField(
            context: context,
            title: 'Per Day',
            formControlName: 'rental_price_per_day',
            hint: 'e.g. 50',
          ),
          _buildPriceField(
            context: context,
            title: 'Per Week',
            formControlName: 'rental_price_per_week',
            hint: 'e.g. 300',
          ),
          _buildPriceField(
            context: context,
            title: 'Per Month',
            formControlName: 'rental_price_per_month',
            hint: 'e.g. 1000',
          ),
          _buildPriceField(
            context: context,
            title: 'Per 3 Months',
            formControlName: 'rental_price_per_3months',
            hint: 'e.g. 2700',
          ),
          _buildPriceField(
            context: context,
            title: 'Per 6 Months',
            formControlName: 'rental_price_per_6months',
            hint: 'e.g. 5000',
          ),
          _buildPriceField(
            context: context,
            title: 'Per Year',
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
              translation: false,
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
                  Container(
                    padding: HWEdgeInsets.symmetric(horizontal: 12),
                    child: AppText(
                      currencySymbol,
                      style: context.textTheme.bodyMedium?.b.withColor(AppColors.grey),
                      translation: false,
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
