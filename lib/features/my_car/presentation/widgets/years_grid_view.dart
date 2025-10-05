import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/features/my_car/presentation/widgets/year_item.dart';

class YearsGridView extends StatelessWidget {
  const YearsGridView({
    super.key,
    required this.nowYear,
    required this.startYear,
    this.currentYear,
    required this.onYearChanged,
  });

  final int nowYear;
  final int startYear;
  final int? currentYear;
  final ValueChanged<int> onYearChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 1.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 25 / 15.5,
            crossAxisCount: 3),
        itemCount: (nowYear - startYear) + 2,
        itemBuilder: (context, index) {
          final year = startYear + index;
          return YearItem(
              year: year,
              currentYear: currentYear,
              onYearChanged: onYearChanged);
        },
      ),
    );
  }
}
