import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/features/app/presentation/widgets/animated_dialog.dart';
import 'package:wolfera/features/app/presentation/widgets/app_bottom_sheet.dart';
import 'package:wolfera/features/app/presentation/widgets/language_dialog.dart';
import 'package:wolfera/features/profile/presentation/pages/profile_page.dart';
import 'package:wolfera/features/profile/presentation/widgets/logout_bottom_sheet.dart';
import 'package:wolfera/generated/assets.dart';
import 'package:wolfera/services/supabase_service.dart';
import 'package:wolfera/services/app_settings_service.dart';
import 'package:wolfera/features/profile/presentation/widgets/add_admin_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:easy_localization/easy_localization.dart';

import 'profile_item_settings_widget.dart';

class SettingsSectionProfile extends StatelessWidget {
  const SettingsSectionProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProfileItemSettingsWidget(
          title: 'editProfile',
          svgIcon: Assets.svgPerson,
          onTap: () => GRouter.router
              .pushNamed(GRouter.config.profileRoutes.profileEdit),
        ),
        // Super Admin: Add Admin button
        FutureBuilder<bool>(
          future: SupabaseService.isCurrentUserSuperAdmin(),
          builder: (context, snapshot) {
            final isSuper = snapshot.data == true;
            if (!isSuper) return const SizedBox.shrink();
            return Column(
              children: [
                ProfileItemSettingsWidget(
                  title: 'add_admin_title',
                  svgIcon: Assets.svgPerson,
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => const AddAdminDialog(),
                  ),
                ),
                // خيار إخفاء/إظهار سوريا
                _SyriaVisibilityToggle(),
              ],
            );
          },
        ),
        ProfileItemSettingsWidget(
          title: 'address',
          svgIcon: Assets.svgMapPin,
          onTap: () => GRouter.router.pushNamed(
            GRouter.config.profileRoutes.addressPage,
            extra: GetIt.I<PrefsRepository>().selectedCity ?? "WorldWide",
          ),
        ),
        ProfileItemSettingsWidget(
          title: 'my_cars'.tr(),
          svgIcon: Assets.svgCarDealer,
          onTap: () => GRouter.router.goNamed(GRouter.config.mainRoutes.myCars),
        ),
        ProfileItemSettingsWidget(
          title: 'notifications'.tr(),
          svgIcon: Assets.svgBell,
          onTap: () => GRouter.router
              .pushNamed(GRouter.config.notificationsRoutes.notifications),
        ),
        ProfileItemSettingsWidget(
          title: 'language',
          svgIcon: Assets.svgGlobe,
          onTap: () => AnimatedDialog.show(context,
              child: const LanguageDialog(),
              barrierDismissible: true,
              barrierLabel: "LanguageDialog"),
        ),
        ProfileItemSettingsWidget(
          title: 'settingsApp.privacyPolicy',
          svgIcon: Assets.svgLock,
          onTap: () => GRouter.router
              .pushNamed(GRouter.config.settingsRoutes.privacyPolicy),
        ),
        ProfileItemSettingsWidget(
          title: 'settingsApp.aboutTheApplication',
          svgIcon: Assets.svgInfoRect,
          onTap: () =>
              GRouter.router.pushNamed(GRouter.config.settingsRoutes.aboutUs),
        ),
        ProfileItemSettingsWidget(
          title: 'logout',
          svgIcon: Assets.svgLogout,
          isLastItem: false,
          color: AppColors.primary,
          onTap: () {
            LogoutBottomSheet.showBasicModalBottomSheet(context);
          },
        ),
      ],
    );
  }
}

/// ويدجت لتبديل إخفاء/إظهار سوريا (للسوبر أدمن فقط)
class _SyriaVisibilityToggle extends StatefulWidget {
  const _SyriaVisibilityToggle();

  @override
  State<_SyriaVisibilityToggle> createState() => _SyriaVisibilityToggleState();
}

class _SyriaVisibilityToggleState extends State<_SyriaVisibilityToggle> {
  bool _isHidden = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isHidden = AppSettingsService.instance.isSyriaHidden;
  }

  Future<void> _toggleVisibility() async {
    setState(() => _isLoading = true);
    
    try {
      EasyLoading.show(status: 'Updating...');
      final newValue = !_isHidden;
      await AppSettingsService.instance.setSyriaVisibility(newValue);
      
      setState(() => _isHidden = newValue);
      
      EasyLoading.dismiss();
      EasyLoading.showSuccess(
        'syria_visibility_updated'.tr(),
        duration: const Duration(seconds: 2),
      );
      
      // إعادة تحميل التطبيق لتطبيق التغييرات
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('restart_required'.tr()),
            content: Text('restart_app_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('ok'.tr()),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileItemSettingsWidget(
      title: _isHidden ? 'show_syria' : 'hide_syria',
      svgIcon: Assets.svgGlobe,
      onTap: _isLoading ? null : _toggleVisibility,
    );
  }
}
