enum FuelType {
  diesel('Diesel'),
  gasoline('Gasoline'),
  petrol('Petrol'),
  hydrogen('Hydrogen');

  final String name;

  const FuelType(
    this.name,
  );
}
