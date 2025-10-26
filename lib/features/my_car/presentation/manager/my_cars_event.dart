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
