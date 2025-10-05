import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Exception? exception;

  const ErrorScreen({Key? key, this.exception}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
