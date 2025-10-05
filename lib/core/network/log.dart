import 'package:logger/logger.dart';

void prettyPrinterError(final String message) {
  Logger(printer: PrettyPrinter(methodCount: 0)).e(message);
}

void prettyPrinterWtf(final String message) {
  Logger(printer: PrettyPrinter(methodCount: 0)).wtf(message);
}

void prettyPrinterI(final String message) {
  Logger(printer: PrettyPrinter(methodCount: 0)).i(message);
}

void prettyPrinterV(final String message) {
  Logger(printer: PrettyPrinter(methodCount: 0)).v(message);
}
