import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_cubit.dart';

class CarDetalisAppbar extends StatefulWidget implements PreferredSizeWidget {
  final Map<String, dynamic>? carData;
  
  const CarDetalisAppbar({
    super.key,
    this.carData,
  });
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  
  @override
  State<CarDetalisAppbar> createState() => _CarDetalisAppbarState();
  
  @override
  PreferredSizeWidget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class _CarDetalisAppbarState extends State<CarDetalisAppbar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    if (widget.carData == null) {
      showMessage('Cannot add to favorites: Car data not available', isSuccess: false);
      return;
    }
    
    final carId = widget.carData!['id']?.toString();
    if (carId == null) {
      showMessage('Cannot add to favorites: Car ID not available', isSuccess: false);
      return;
    }
    
    _animationController.forward(from: 0.0);
    
    try {
      // استخدام FavoriteCubit الموحد
      final favoriteCubit = context.read<FavoriteCubit>();
      await favoriteCubit.toggleFavorite(widget.carData!);
      
      final isFavorite = favoriteCubit.isFavoriteById(carId);
      showMessage(
        isFavorite ? 'Added to favorites' : 'Removed from favorites',
        isSuccess: true,
      );
    } catch (e) {
      showMessage('Error updating favorites', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final carId = widget.carData?['id']?.toString();
    
    return CustomAppbar(
      automaticallyImplyLeading: true,
      action: Padding(
        padding: HWEdgeInsetsDirectional.only(end: 20, top: 5),
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            final isFavorite = carId != null 
                ? context.read<FavoriteCubit>().isFavoriteById(carId)
                : false;
            
            return GestureDetector(
              onTap: () => _toggleFavorite(context),
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Icon(
                      isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      size: 30.r,
                      color: isFavorite ? AppColors.red : AppColors.white,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
