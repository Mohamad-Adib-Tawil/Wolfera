import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolfera/common/enums/budget_filter.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/widget/budget_item.dart';

class BudgetListView extends StatelessWidget {
  const BudgetListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: BudgetFiltertype.values.length,
          itemBuilder: (context, index) {
            final item = BudgetFiltertype.values[index];
            final isSelected = item.name == state.selectedPrice;
            return BudgetItem(
                item: item,
                isSelected: isSelected,
                onTap: () =>
                    context.read<SearchCubit>().selectPrice(item.name));
          },
        );
      },
    );
  }
}
