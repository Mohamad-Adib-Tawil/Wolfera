import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/generated/assets.dart';

class FavorateIconWidget extends StatefulWidget {
  const FavorateIconWidget({super.key});

  @override
  State<FavorateIconWidget> createState() => _FavorateIconWidgetState();
}

class _FavorateIconWidgetState extends State<FavorateIconWidget>
    with SingleTickerProviderStateMixin {
  bool _isRed = true;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _toggleColor() {
    setState(() {
      _isRed = !_isRed;
    });
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HWEdgeInsets.all(10),
      child: GestureDetector(
        onTap: _toggleColor,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Opacity(
                  opacity: _isRed ? 1.0 : _fadeAnimation.value,
                  child: CircleAvatar(
                    backgroundColor: AppColors.blackLight.withOpacity(0.7),
                    child: AppSvgPicture(
                      Assets.svgHeart,
                      height: 20.h,
                      width: 20.w,
                      color: _isRed ? AppColors.red : AppColors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
