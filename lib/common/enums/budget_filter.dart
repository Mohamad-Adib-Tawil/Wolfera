enum BudgetFiltertype {
  lessThan10K('Less than', r"10,000 $"),
  startingFrom10K('Starting from', r"10,000 $"),
  startingFrom10Kto15K('Starting from', r"10K $ to 15K $"),
  startingFrom15Kto20K('Starting from', r"15K $ to 20K $"),
  startingFrom20Kto30K('Starting from', r"20K $ to 30K $"),
  moreThan30K('More than', r"30,000 $"),
  ;

  final String title;
  final String range;

  const BudgetFiltertype(this.title, this.range);
}
