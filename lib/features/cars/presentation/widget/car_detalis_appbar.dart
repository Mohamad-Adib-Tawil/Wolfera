import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/api/api_utils.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_cubit.dart';
import 'package:wolfera/features/faviorate/presentation/manager/favorite_state.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:wolfera/features/search_and_filteration/presentation/manager/search_cubit/search_cubit.dart';
import 'package:wolfera/services/supabase_service.dart';

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
  bool _isAdmin = false;
  bool _isFeatured = false;

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

    // Init featured flag from carData
    final f = widget.carData?['is_featured'];
    if (f is bool) {
      _isFeatured = f;
    } else if (f is int) {
      _isFeatured = f == 1;
    }
    // Check if current user is admin
    _initAdmin();
  }

  Future<void> _adminRemoveCarAction() async {
    if (!_isAdmin) {
      showMessage('only_admin_can_remove'.tr(), isSuccess: false);
      return;
    }
    final carId = widget.carData?['id']?.toString();
    if (carId == null || carId.isEmpty) {
      showMessage('car_not_found'.tr(), isSuccess: false);
      return;
    }

    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1F24),
          title: Text('admin_remove_car'.tr(), style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('admin_remove_car_desc'.tr(), style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'reason'.tr(),
                  hintText: 'reason_hint'.tr(),
                  labelStyle: const TextStyle(color: Colors.white70),
                  hintStyle: const TextStyle(color: Colors.white54),
                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('cancel'.tr()),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                final v = controller.text.trim();
                if (v.isEmpty) return; // اجعل السبب مطلوباً
                Navigator.of(ctx).pop(true);
              },
              child: Text('remove'.tr()),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    final reason = controller.text.trim();
    try {
      await SupabaseService.adminRemoveCar(carId: carId, reason: reason);
      showMessage('removal_success'.tr(), isSuccess: true);
      // Refresh home featured and search results
      try { GetIt.I<HomeCubit>().getHomeData(); } catch (_) {}
      try { GetIt.I<SearchCubit>().searchCars(); } catch (_) {}
      if (mounted) Navigator.of(context).maybePop();
    } catch (e) {
      showMessage('removal_failed'.tr(), isSuccess: false);
    }
  }

  Future<void> _initAdmin() async {
    try {
      final isAdmin = await SupabaseService.isCurrentUserAdmin();
      if (mounted) {
        setState(() => _isAdmin = isAdmin);
      }
    } catch (_) {}
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

  Future<void> _toggleFeatured() async {
    if (!_isAdmin) {
      showMessage('Only admin can feature cars', isSuccess: false);
      return;
    }
    if (widget.carData == null) {
      showMessage('Cannot update featured: Car data not available', isSuccess: false);
      return;
    }
    final carId = widget.carData!['id']?.toString();
    if (carId == null) {
      showMessage('Cannot update featured: Car ID not available', isSuccess: false);
      return;
    }
    try {
      final newVal = !_isFeatured;
      await SupabaseService.setCarFeatured(carId, newVal);
      if (mounted) {
        setState(() => _isFeatured = newVal);
      }
      showMessage(newVal ? 'Marked as featured' : 'Removed from featured', isSuccess: true);
      // Refresh home featured list if available
      try {
        GetIt.I<HomeCubit>().getHomeData();
      } catch (_) {}
    } catch (e) {
      showMessage('Failed to update featured', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final carId = widget.carData?['id']?.toString();
    
    return CustomAppbar(
      automaticallyImplyLeading: true,
      action: Padding(
        padding: HWEdgeInsetsDirectional.only(end: 20, top: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isAdmin)
              GestureDetector(
                onTap: _adminRemoveCarAction,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Icon(
                    CupertinoIcons.trash,
                    size: 26.r,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            if (_isAdmin)
              GestureDetector(
                onTap: _toggleFeatured,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Icon(
                    _isFeatured ? CupertinoIcons.star_fill : CupertinoIcons.star,
                    size: 26.r,
                    color: _isFeatured ? AppColors.orange : AppColors.white,
                  ),
                ),
              ),
            BlocBuilder<FavoriteCubit, FavoriteState>(
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
          ],
        ),
      ),
    );
  }
}
