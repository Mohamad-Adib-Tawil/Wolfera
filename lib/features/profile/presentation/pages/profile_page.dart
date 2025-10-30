import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import '../widgets/settings_section_profile.dart';
import '../widgets/top_section_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;

  @override
  void initState() {
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: HWEdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const TopSectionProfilePage(),
              10.verticalSpace,
              const SettingsSectionProfile()
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.blackLight,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _shouldAnimateEntrance
            ? const DelayedFadeSlide(
                delay: Duration(milliseconds: 100),
                duration: Duration(milliseconds: 1000),
                beginOffset: Offset(0, -0.24),
                child: CustomAppbar(
                  text: LocaleKeys.profile,
                  automaticallyImplyLeading: true,
                ),
              )
            : const CustomAppbar(
                text: LocaleKeys.profile,
                automaticallyImplyLeading: true,
              ),
      ),
      body: _shouldAnimateEntrance
          ? DelayedFadeSlide(
              delay: const Duration(milliseconds: 260),
              duration: const Duration(milliseconds: 1000),
              beginOffset: const Offset(-0.24, 0),
              child: content,
            )
          : content,
    );
  }
}
