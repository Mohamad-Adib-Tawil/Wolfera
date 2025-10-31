import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';

class CarDetalisAppbar extends StatefulWidget implements PreferredSizeWidget {
  final String? carId;
  final bool? initialIsFavorite;
  
  const CarDetalisAppbar({
    super.key,
    this.carId,
    this.initialIsFavorite,
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
  late bool _isFavorite;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialIsFavorite ?? false;
    
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

  Future<void> _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    _animationController.forward(from: 0.0);
    
    // TODO: حفظ حالة المفضلة في قاعدة البيانات
    // if (widget.carId != null) {
    //   await FavoritesService.toggleFavorite(widget.carId!);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppbar(
      automaticallyImplyLeading: true,
      action: Padding(
        padding: HWEdgeInsetsDirectional.only(end: 20, top: 5),
        child: GestureDetector(
          onTap: _toggleFavorite,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Icon(
                  _isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  size: 30.r,
                  color: _isFavorite ? AppColors.red : AppColors.white,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
