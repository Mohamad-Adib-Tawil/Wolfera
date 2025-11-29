import 'package:wolfera/common/enums/car_makers.dart';

/// Canonical dataset of car models grouped by maker.
/// Extend freely as needed. Keep names as commonly used marketing names.
class CarModelsData {
  static const Map<CarMaker, List<String>> modelsByMaker = {
    CarMaker.kia: [
      'Rio', 'Cerato', 'Picanto', 'Sportage', 'Sorento', 'Optima', 'K5', 'Stinger', 'Seltos', 'Stonic', 'Carnival'
    ],
    CarMaker.toyota: [
      'Corolla', 'Camry', 'Yaris', 'Supra', 'RAV4', 'Land Cruiser', 'Prado', 'Hilux', 'Avalon', 'Fortuner'
    ],
    CarMaker.hyundai: [
      'Accent', 'Elantra', 'Sonata', 'i10', 'i20', 'i30', 'Tucson', 'Santa Fe', 'Creta', 'Kona', 'Palisade'
    ],
    CarMaker.nissan: [
      'Sunny', 'Sentra', 'Altima', 'Maxima', 'Patrol', 'X-Trail', 'Juke', 'Kicks'
    ],
    CarMaker.honda: [
      'Civic', 'Accord', 'City', 'CR-V', 'HR-V', 'Pilot'
    ],
    CarMaker.ford: [
      'Fiesta', 'Focus', 'Fusion', 'Mondeo', 'Mustang', 'Explorer', 'Edge', 'Escape'
    ],
    CarMaker.bmw: [
      '1 Series', '2 Series', '3 Series', '4 Series', '5 Series', '7 Series', 'X1', 'X3', 'X5', 'X7', 'M3', 'M4'
    ],
    CarMaker.mercedes: [
      'A-Class', 'C-Class', 'E-Class', 'S-Class', 'GLA', 'GLC', 'GLE', 'GLS', 'CLA'
    ],
    CarMaker.audi: [
      'A3', 'A4', 'A5', 'A6', 'A8', 'Q2', 'Q3', 'Q5', 'Q7', 'TT'
    ],
    CarMaker.volkswagen: [
      'Polo', 'Golf', 'Jetta', 'Passat', 'Tiguan', 'Touareg'
    ],
    CarMaker.lexus: [
      'IS', 'ES', 'GS', 'LS', 'RX', 'NX', 'LX'
    ],
    CarMaker.tesla: [
      'Model 3', 'Model S', 'Model X', 'Model Y'
    ],
    CarMaker.porsche: [
      '911', 'Cayman', 'Boxster', 'Panamera', 'Macan', 'Cayenne'
    ],
    CarMaker.mitsubishi: [
      'Lancer', 'Attrage', 'Outlander', 'ASX', 'Pajero', 'Eclipse Cross'
    ],
    CarMaker.mazda: [
      'Mazda2', 'Mazda3', 'Mazda6', 'CX-3', 'CX-5', 'CX-9'
    ],
    CarMaker.chevrolet: [
      'Spark', 'Aveo', 'Cruze', 'Malibu', 'Impala', 'Camaro', 'Tahoe', 'Traverse'
    ],
    CarMaker.skoda: [
      'Fabia', 'Octavia', 'Superb', 'Kodiaq', 'Karoq', 'Scala'
    ],
    CarMaker.peugeot: [
      '2008', '3008', '5008', '208', '301', '308'
    ],
    CarMaker.opel: [
      'Corsa', 'Astra', 'Insignia', 'Mokka', 'Grandland'
    ],
    CarMaker.alfaromeo: [
      'Giulia', 'Giulietta', 'Stelvio'
    ],
  };

  /// Returns models for a single maker.
  static List<String> forMaker(CarMaker maker) =>
      List.unmodifiable(modelsByMaker[maker] ?? const <String>[]);

  /// Returns a de-duplicated union of models for a list of makers.
  static List<String> forMakers(Iterable<CarMaker> makers) {
    final set = <String>{};
    for (final m in makers) {
      final list = modelsByMaker[m];
      if (list != null) set.addAll(list);
    }
    final res = set.toList();
    res.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return res;
  }
}
