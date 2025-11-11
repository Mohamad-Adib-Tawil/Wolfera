import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/money_formatter.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/home/presentation/widgets/car_mini_details_card_widget.dart';
import 'package:wolfera/features/app/presentation/widgets/shimmer_loading.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/core/utils/car_value_translator.dart';

class SearchResultsVerticalList extends StatefulWidget {
  const SearchResultsVerticalList({super.key});

  @override
  State<SearchResultsVerticalList> createState() => _SearchResultsVerticalListState();
}

class _SkeletonCarMiniCard extends StatelessWidget {
  const _SkeletonCarMiniCard({this.fullWidth = false});

  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215.h,
      width: fullWidth ? double.infinity : 320.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.greyStroke, width: 1.5.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة السيارة (Placeholder)
          Container(
            height: 140.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.greyStroke.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar(width: fullWidth ? 180.w : 140.w, height: 12.h),
                8.verticalSpace,
                Row(
                  children: [
                    _bar(width: 80.w, height: 10.h),
                    10.horizontalSpace,
                    _bar(width: 60.w, height: 10.h),
                    const Spacer(),
                    _bar(width: 70.w, height: 12.h),
                  ],
                ),
                8.verticalSpace,
                _bar(width: 120.w, height: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.greyStroke.withOpacity(0.35),
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }
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
        Widget content;
        if (state.isSearching) {
          // سكلتون احترافي أثناء التحميل
          content = Shimmer(
            linearGradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.08),
                AppColors.primary.withOpacity(0.16),
                AppColors.primary.withOpacity(0.08),
              ],
              stops: const [0.1, 0.3, 0.4],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            child: Column(
              children: List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  child: const ShimmerLoading(
                    isLoading: true,
                    child: _SkeletonCarMiniCard(fullWidth: true),
                  ),
                );
              }),
            ),
          );
        } else if (state.searchError != null && state.searchError!.isNotEmpty) {
          content = Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Center(
              child: AppText(
                state.searchError!,
                translation: false,
              ),
            ),
          );
        } else {
          final list = state.searchResults;
          if (list.isEmpty) {
            content = Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: const Center(
                child: AppText('no_cars_found'),
              ),
            );
          } else {
            content = ListView.separated(
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
                // Build translated location: prefer city + translated country, else translated parts
                final city = car['city']?.toString();
                final countryRaw = car['country']?.toString();
                final locationRaw = car['location']?.toString();
                String? location;
                if (city != null && city.isNotEmpty && countryRaw != null && countryRaw.isNotEmpty) {
                  final c = CarValueTranslator.translateCountry(countryRaw);
                  final tCity = CarValueTranslator.translateCity(city, country: countryRaw);
                  location = '${tCity.isNotEmpty ? tCity : city}, ${c != '-' ? c : countryRaw}';
                } else if (countryRaw != null && countryRaw.isNotEmpty) {
                  final c = CarValueTranslator.translateCountry(countryRaw);
                  location = c != '-' ? c : countryRaw;
                } else if (city != null && city.isNotEmpty) {
                  final tCity = CarValueTranslator.translateCity(city, country: countryRaw);
                  location = tCity.isNotEmpty ? tCity : city;
                } else if (locationRaw != null && locationRaw.isNotEmpty) {
                  final c = CarValueTranslator.translateCountry(locationRaw);
                  location = c != '-' ? c : locationRaw;
                }
                final priceVal = car['price']?.toString();
                final currency = car['currency']?.toString() ?? r'$';
                final lt = car['listing_type']?.toString().toLowerCase();
                String? price;
                if (lt == 'rent' || lt == 'both') {
                  final candidates = [
                    ['rental_price_per_day', 'day'],
                    ['rental_price_per_week', 'week'],
                    ['rental_price_per_month', 'month'],
                    ['rental_price_per_3months', '3 months'],
                    ['rental_price_per_6months', '6 months'],
                    ['rental_price_per_year', 'year'],
                  ];
                  for (final c in candidates) {
                    final raw = car[c[0]];
                    if (raw != null) {
                      final num? v = raw is num ? raw : num.tryParse(raw.toString());
                      if (v != null) {
                        final compact = MoneyFormatter.compact(v, symbol: currency);
                        price = compact != null ? '$compact / ${c[1]}' : null;
                        break;
                      }
                    }
                  }
                  if (price == null && lt == 'both') {
                    price = MoneyFormatter.compactFromString(priceVal, symbol: currency);
                  }
                } else {
                  price = MoneyFormatter.compactFromString(priceVal, symbol: currency);
                }

                final itemKey = 'item-${car['id']?.toString() ?? '$index'}|${state.sortBy}|${state.sortAsc}';
                final baseMs = 500;
                final extra = (index % 8) * 40; // gentle stagger
                return TweenAnimationBuilder<double>(
                  key: ValueKey(itemKey),
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: baseMs + extra),
                  curve: Curves.easeOutCubic,
                  builder: (context, t, child) {
                    final dx = (1 - t) * 20; // slide from left ~20px
                    return Opacity(
                      opacity: t,
                      child: Transform.translate(
                        offset: Offset(-dx, 0),
                        child: child,
                      ),
                    );
                  },
                  child: CarMiniDetailsCardWidget(
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
                  ),
                );
              },
            );
          }
        }

        final key = ValueKey('results|${_buildResultKey(state)}');
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          transitionBuilder: (child, animation) {
            final offsetAnim = Tween<Offset>(begin: const Offset(-0.12, 0), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOutCubic))
                .animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offsetAnim, child: child),
            );
          },
          child: KeyedSubtree(key: key, child: content),
        );
      },
    );
  }

  String _buildResultKey(SearchState st) {
    final ids = st.searchResults
        .map((e) => e['id']?.toString() ?? '${e['brand']}-${e['model']}-${e['year']}')
        .take(6)
        .join('|');
    return '${st.sortBy}|${st.sortAsc}|${st.searchQuery}|${st.selectedCountryCode}|${st.selectedRegionOrCity}|$ids';
  }
}
