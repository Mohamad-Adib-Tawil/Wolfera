import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_cubit.dart';
import 'package:wolfera/generated/assets.dart';

class FavorateIconWidget extends StatefulWidget {
  const FavorateIconWidget({super.key, this.carData});

  // بيانات السيارة (اختياري). في حال عدم توفرها، سيتم تعطيل التبديل فعليًا
  final Map<String, dynamic>? carData;

  @override
  State<FavorateIconWidget> createState() => _FavorateIconWidgetState();
}

class _FavorateIconWidgetState extends State<FavorateIconWidget>
    with SingleTickerProviderStateMixin {
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

  // عند الضغط: نقوم بعمل Toggle عبر Cubit ثم نشغل الأنيميشن
  void _onTapToggleFavorite() {
    final car = widget.carData;
    if (car == null) return;
    context.read<FavoriteCubit>().toggleFavorite(car);
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carId = widget.carData?['id']?.toString();
    final isFav = context.select<FavoriteCubit, bool>(
      (cubit) => cubit.isFavoriteById(carId),
    );
    return Padding(
      padding: HWEdgeInsets.all(10),
      child: GestureDetector(
        onTap: _onTapToggleFavorite,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Opacity(
                  opacity: isFav ? 1.0 : _fadeAnimation.value,
                  child: CircleAvatar(
                    backgroundColor:
                        AppColors.blackLight.withValues(alpha: 0.7),
                    child: AppSvgPicture(
                      Assets.svgHeart,
                      height: 20.h,
                      width: 20.w,
                      color: isFav ? AppColors.red : AppColors.white,
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
