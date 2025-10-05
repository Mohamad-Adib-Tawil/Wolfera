import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateFormat get monthFormatter => DateFormat.MMMd();
  String asDate() => '$year/$month/$day';

  String get inMonth => monthFormatter.format(this);

  static DateTime? fromInt(int? milliseconds) =>
      milliseconds != null ? DateTime.fromMillisecondsSinceEpoch(milliseconds * 1000) : null;

  static int? toInt(DateTime? time) => time != null ? (time.millisecondsSinceEpoch / 1000).ceil() : null;
  DateTime get toLocaleDate => toLocal();

}


DateTime dateFromJson(dynamic date) {
  return  DateTime.parse(date).toLocaleDate;
}

DateTime? dateFromJsonNullable(dynamic date) {
  return date == null ? null : DateTime.parse(date).toLocaleDate;
}