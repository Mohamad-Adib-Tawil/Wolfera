enum BudgetFiltertype {
  // Use localization keys; AppText will translate them.
  lessThan10K('less_than', 'budget_10k'),
  startingFrom10K('starting_from', 'budget_10k'),
  startingFrom10Kto15K('starting_from', 'budget_10k_to_15k'),
  startingFrom15Kto20K('starting_from', 'budget_15k_to_20k'),
  startingFrom20Kto30K('starting_from', 'budget_20k_to_30k'),
  moreThan30K('more_than', 'budget_30k'),
  ;

  final String title;
  final String range;

  const BudgetFiltertype(this.title, this.range);
}
