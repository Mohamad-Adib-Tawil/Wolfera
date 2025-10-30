import 'package:flutter/material.dart';
import 'package:wolfera/common/constants/constants.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_appbar.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';
import 'package:wolfera/generated/locale_keys.g.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
    final body = Padding(
      padding: HWEdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView(
        children: [
          Html(data: privacyPolicyHTML),
        ],
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _shouldAnimateEntrance
            ? const DelayedFadeSlide(
                delay: Duration(milliseconds: 100),
                duration: Duration(milliseconds: 1000),
                beginOffset: Offset(0, -0.24),
                child: CustomAppbar(
                  text: LocaleKeys.settingsApp_privacyPolicy,
                  automaticallyImplyLeading: true,
                ),
              )
            : const CustomAppbar(
                text: LocaleKeys.settingsApp_privacyPolicy,
                automaticallyImplyLeading: true,
              ),
      ),
      backgroundColor: AppColors.blackLight,
      body: _shouldAnimateEntrance
          ? DelayedFadeSlide(
              delay: const Duration(milliseconds: 260),
              duration: const Duration(milliseconds: 1000),
              beginOffset: const Offset(-0.24, 0),
              child: body,
            )
          : body,
    );
  }
}
