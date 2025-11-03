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
        Widget content;
        if (state.isSearching) {
          content = SizedBox(
            height: 140.h,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
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
                child: AppText(
                  'No cars found',
                  translation: false,
                ),
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
                final location = (car['city'] ?? car['location'])?.toString();
                final priceVal = car['price']?.toString();
                final currency = car['currency']?.toString() ?? r'$';
                final price = MoneyFormatter.compactFromString(priceVal, symbol: currency);

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
