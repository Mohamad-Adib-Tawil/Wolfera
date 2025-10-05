import 'package:wolfera/common/enums/car_makers.dart';

class CarMakerFilterService {
  List<CarMaker> filterCarMakers(String query, List<CarMaker> carMakers) {
    query = query.toLowerCase();

    return carMakers
        .where((maker) => maker.name.toLowerCase().contains(query))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
