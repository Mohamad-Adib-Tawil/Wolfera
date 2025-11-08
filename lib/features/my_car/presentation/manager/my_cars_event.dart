part of 'my_cars_bloc.dart';

abstract class MyCarsEvent {}

class NextPageEvent extends MyCarsEvent {}

class PreviousPageEvent extends MyCarsEvent {}

class BackPageEvent extends MyCarsEvent {}

class AddOptionalImageEvent extends MyCarsEvent {}

class ResetSellMyCarEvent extends MyCarsEvent {}

class SellMyCarEvent extends MyCarsEvent {
  SellMyCarEvent();
}

// حدث جلب السيارات الخاصة بالمستخدم
class LoadMyCarsEvent extends MyCarsEvent {}

// حدث حذف سيارة
class DeleteMyCarEvent extends MyCarsEvent {
  final String carId;
  DeleteMyCarEvent(this.carId);
}

// حدث حذف جميع سيارات المستخدم
class DeleteAllMyCarsEvent extends MyCarsEvent {}

// تحديث حالة السيارة (active, sold, pending, inactive)
class UpdateMyCarStatusEvent extends MyCarsEvent {
  final String carId;
  final String status;
  UpdateMyCarStatusEvent({required this.carId, required this.status});
}

// تحديث سعر السيارة
class UpdateMyCarPriceEvent extends MyCarsEvent {
  final String carId;
  final num newPrice;
  UpdateMyCarPriceEvent({required this.carId, required this.newPrice});
}

// تحديث أسعار الإيجار
class UpdateMyCarRentalPricesEvent extends MyCarsEvent {
  final String carId;
  final String? perDay;
  final String? perWeek;
  final String? perMonth;
  final String? per3Months;
  final String? per6Months;
  final String? perYear;
  UpdateMyCarRentalPricesEvent({
    required this.carId,
    this.perDay,
    this.perWeek,
    this.perMonth,
    this.per3Months,
    this.per6Months,
    this.perYear,
  });
}
