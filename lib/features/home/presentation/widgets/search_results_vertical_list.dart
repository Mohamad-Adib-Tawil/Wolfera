import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/money_formatter.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/home/presentation/widgets/car_mini_details_card_widget.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';

class SearchResultsVerticalList extends StatefulWidget {
  const SearchResultsVerticalList({super.key});

  @override
  State<SearchResultsVerticalList> createState() => _SearchResultsVerticalListState();
}

class _SearchResultsVerticalListState extends State<SearchResultsVerticalList> {
  late final SearchCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.I<SearchCubit>();
    // Trigger initial search to populate the list (idempotent)
    _cubit.searchCars();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state.isSearching) {
          return SizedBox(
            height: 140.h,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state.searchError != null && state.searchError!.isNotEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Center(
              child: AppText(
                state.searchError!,
                translation: false,
              ),
            ),
          );
        }

        final list = state.searchResults;
        if (list.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Center(
              child: AppText(
                'No cars found',
                translation: false,
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          separatorBuilder: (_, __) => 12.verticalSpace,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          itemBuilder: (context, index) {
            final car = list[index];

            final imageUrls = (car['image_urls'] as List?)?.cast<dynamic>() ?? const [];
            final mainImage = car['main_image_url']?.toString();
            final imageUrl = imageUrls.isNotEmpty ? imageUrls.first?.toString() : mainImage;

            final titleParts = [
              car['year']?.toString(),
              car['brand']?.toString(),
              car['model']?.toString(),
            ];
            final title = titleParts.where((e) => e != null && e.isNotEmpty).join(' ');

            final spec1 = (car['body_type'] ?? car['engine_capacity'])?.toString();
            final spec2 = car['transmission']?.toString();
            final mileageVal = car['mileage']?.toString();
            final mileage = mileageVal != null && mileageVal.isNotEmpty ? '$mileageVal KM' : null;
            final fuel = car['fuel_type']?.toString();
            final location = (car['city'] ?? car['location'])?.toString();
            final priceVal = car['price']?.toString();
            final currency = car['currency']?.toString() ?? r'$';
            final price = MoneyFormatter.compactFromString(priceVal, symbol: currency);

            return CarMiniDetailsCardWidget(
              fullWidth: true,
              image: imageUrl,
              title: title.isNotEmpty ? title : null,
              spec1: spec1,
              spec2: spec2,
              mileage: mileage,
              fuel: fuel,
              location: location,
              price: price,
              carData: car,
            );
          },
        );
      },
    );
  }
}
