import 'package:flutter/cupertino.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';

class PlusIconWidget extends StatelessWidget {
  const PlusIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            child: Icon(CupertinoIcons.plus,
                color: AppColors.greyStroke, size: 40 //28,
                ))
      ],
    );
  }
}
