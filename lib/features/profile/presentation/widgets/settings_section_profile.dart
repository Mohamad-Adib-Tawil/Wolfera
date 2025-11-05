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
import 'package:wolfera/features/profile/presentation/widgets/add_admin_dialog.dart';

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
          title: 'Edit Profile',
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
            return ProfileItemSettingsWidget(
              title: 'Add Admin',
              svgIcon: Assets.svgPerson,
              onTap: () => showDialog(
                context: context,
                builder: (_) => const AddAdminDialog(),
              ),
            );
          },
        ),
        ProfileItemSettingsWidget(
          title: 'Address',
          svgIcon: Assets.svgMapPin,
          onTap: () => GRouter.router.pushNamed(
            GRouter.config.profileRoutes.addressPage,
            extra: GetIt.I<PrefsRepository>().selectedCity ?? "WorldWide",
          ),
        ),
        ProfileItemSettingsWidget(
          title: 'My Cars',
          svgIcon: Assets.svgCarDealer,
          onTap: () => GRouter.router.goNamed(GRouter.config.mainRoutes.myCars),
        ),
        ProfileItemSettingsWidget(
          title: 'Notifications',
          svgIcon: Assets.svgBell,
          onTap: () => GRouter.router
              .pushNamed(GRouter.config.notificationsRoutes.notifications),
        ),
        ProfileItemSettingsWidget(
          title: 'Language',
          svgIcon: Assets.svgGlobe,
          onTap: () => AnimatedDialog.show(context,
              child: const LanguageDialog(),
              barrierDismissible: true,
              barrierLabel: "LanguageDialog"),
        ),
        ProfileItemSettingsWidget(
          title: 'Privacy Policy',
          svgIcon: Assets.svgLock,
          onTap: () => GRouter.router
              .pushNamed(GRouter.config.settingsRoutes.privacyPolicy),
        ),
        ProfileItemSettingsWidget(
          title: 'About Us',
          svgIcon: Assets.svgInfoRect,
          onTap: () =>
              GRouter.router.pushNamed(GRouter.config.settingsRoutes.aboutUs),
        ),
        ProfileItemSettingsWidget(
          title: 'Logout',
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
