import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wolfera/core/config/routing/router.dart';

class CongratulationsSection extends StatelessWidget {
  const CongratulationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => GRouter.router.pop(),
          child: const Icon(CupertinoIcons.xmark),
        ),
      ),
    );
  }
}
