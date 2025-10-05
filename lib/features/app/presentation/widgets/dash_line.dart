import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_padding.dart';

class DashLine extends StatelessWidget {
  const DashLine({
    super.key,
    this.height = 0,
    this.dashHeight = 1,
    this.color = Colors.grey,
    this.width,
    this.indent,
    this.endIndent,
  });

  final double height;
  final double dashHeight;
  final Color color;
  final double? width;
  final double? indent;
  final double? endIndent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = width ?? 10.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();

        return Padding(
          padding: HWEdgeInsetsDirectional.only(
            start: indent ?? 0,
            end: endIndent ?? 0,
            bottom: height != 0 ? height / 2 : height,
            top: height != 0 ? height / 2 : height,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
