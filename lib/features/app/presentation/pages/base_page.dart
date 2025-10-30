import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/animated_dialog.dart';
import 'package:wolfera/features/app/presentation/widgets/app_elvated_button.dart';
import 'package:wolfera/features/app/presentation/widgets/app_svg_picture.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text_button.dart';
import 'package:wolfera/features/app/presentation/widgets/custom_navigation_bar.dart';
import 'package:wolfera/generated/locale_keys.g.dart';

import '../../../../generated/assets.dart';
import '../../../../services/firebase_service.dart';
import '../../../../services/notification_service.dart';
import '../widgets/app_scaffold.dart';

class BasePage extends StatefulWidget {
  const BasePage({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  static GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  static void openEndDrawer() => _scaffoldKey.currentState!.openEndDrawer();

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // Run bottom bar entrance animation only once per app session
  static bool _didAnimateBottomOnce = false;
  late final bool _shouldAnimateBottom;
  @override
  void initState() {
    // FirebaseService.onMessage(listen: (value) {
    //   if (Platform.isAndroid) {
    //     NotificationService.showLocalNotification(
    //       id: int.tryParse(value.data["action_id"]) ?? 0,
    //       title: value.notification!.title!,
    //       body: value.notification!.body!,
    //       payload: jsonEncode(value.data),
    //     );
    //   }
    // });
    // FirebaseService.setupInteractedMessage();
    _shouldAnimateBottom = !_didAnimateBottomOnce;
    _didAnimateBottomOnce = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (widget.child.currentIndex != 0) {
          widget.child.goBranch(0);
        } else {
          AnimatedDialog.show(context,
              barrierDismissible: true,
              barrierLabel: "ExitDialog",
              child: Padding(
                padding: HWEdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Center(
                        child: AppSvgPicture(Assets.svgLogout, height: 50.r)),
                    25.verticalSpace,
                    AppText(
                      LocaleKeys.doYouWantLeave,
                      style: context.textTheme.titleMedium,
                    ),
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AppTextButton(
                          text: LocaleKeys.noIdoNotWant,
                          onPressed: () {
                            GRouter.router.pop();
                          },
                        ),
                        AppTextButton(
                          text: LocaleKeys.yesAmSure,
                          appButtonStyle: AppButtonStyle.secondary,
                          onPressed: () {
                            GRouter.router.pop();
                            SystemNavigator.pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        }
      },
      canPop: false,
      child: AppScaffold(
        backgroundColor: AppColors.blackLight,
        scaffoldKey: BasePage._scaffoldKey,
        body: Stack(children: [
          Padding(
            padding: HWEdgeInsets.only(bottom: 75),
            child: widget.child,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _AnimatedBottomOnce(
              animate: _shouldAnimateBottom,
              child: CustomNavigationBar(
                child: widget.child,
              ),
            ),
          ),
        ]),
        resizeToAvoidBottomInset: false,
        // bottomNavigationBar: ,
      ),
    );
  }
}

class _AnimatedBottomOnce extends StatefulWidget {
  const _AnimatedBottomOnce({
    required this.child,
    required this.animate,
  });

  final Widget child;
  final bool animate;

  @override
  State<_AnimatedBottomOnce> createState() => _AnimatedBottomOnceState();
}

class _AnimatedBottomOnceState extends State<_AnimatedBottomOnce> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      // slight delay to feel natural after first frame
      Future.delayed(const Duration(milliseconds: 30), () {
        if (mounted) setState(() => _visible = true);
      });
    } else {
      _visible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    const kDuration = Duration(milliseconds: 1000);
    return AnimatedOpacity(
      duration: kDuration,
      curve: Curves.easeOutCubic,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: kDuration,
        curve: Curves.easeOutCubic,
        offset: _visible ? Offset.zero : const Offset(0, 0.26),
        child: widget.child,
      ),
    );
  }
}
