import 'package:flutter/material.dart';

class RefreshListWidget extends StatelessWidget {
  const RefreshListWidget({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  final Widget child;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        onRefresh();
        return Future.delayed(const Duration(milliseconds: 700));
      },
      child: child,
    );
  }
}
