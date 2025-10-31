import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/core/config/theme/colors_app.dart';
import 'package:wolfera/core/config/theme/typography.dart';
import 'package:wolfera/core/utils/extensions/build_context.dart';
import 'package:wolfera/core/utils/extensions/list.dart';
import 'package:wolfera/core/utils/responsive_padding.dart';
import 'package:wolfera/features/app/presentation/widgets/app_text.dart';
import 'package:wolfera/features/chat/presentation/widgets/chat_empty_state_widget.dart';
import 'package:wolfera/features/chat/presentation/widgets/chat_item.dart';

class MessagesBasePage extends StatefulWidget {
  const MessagesBasePage({super.key});

  @override
  State<MessagesBasePage> createState() => _MessagesBasePageState();
}

class _MessagesBasePageState extends State<MessagesBasePage> {
  // One-time entrance animation flag
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;
  List<String> messages = [
    'Hello, how are you?',
    "Hello, how are you",
    'Hello, how are you?',
    "Hello, how are you",
  ];

  @override
  void initState() {
    super.initState();
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.blackLight,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: _shouldAnimateEntrance
                ? const _DelayedFadeSlide(
                    delay: Duration(milliseconds: 80),
                    duration: Duration(milliseconds: 1000),
                    beginOffset: Offset(0, -0.24),
                    child: _AnimatedAppBar(),
                  )
                : appBar(context),
          ),
          body: Padding(
            padding: HWEdgeInsets.only(left: 20, right: 20, top: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (messages.isNullOrEmpty) ...[
                    169.verticalSpace,
                    _shouldAnimateEntrance
                        ? const _DelayedFadeSlide(
                            delay: Duration(milliseconds: 220),
                            duration: Duration(milliseconds: 1000),
                            beginOffset: Offset(-0.24, 0),
                            child: ChatsEmptyStateWidget(),
                          )
                        : const ChatsEmptyStateWidget()
                  ],
                  if (!messages.isNullOrEmpty)
                    (_shouldAnimateEntrance
                        ? _DelayedFadeSlide(
                            delay: const Duration(milliseconds: 300),
                            duration: const Duration(milliseconds: 1000),
                            beginOffset: const Offset(-0.24, 0),
                            child: ListView.builder(
                              itemCount: 8,
                              shrinkWrap: true,
                              padding: HWEdgeInsets.only(bottom: 25),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Padding(
                                padding: HWEdgeInsets.only(
                                    top: index == 0 ? 0 : 25),
                                child: ChatItem(
                                  index: index,
                                  onTap: () => GRouter.router.pushNamed(
                                      GRouter.config.chatsRoutes.chatPage),
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: 8,
                            shrinkWrap: true,
                            padding: HWEdgeInsets.only(bottom: 25),
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                              padding:
                                  HWEdgeInsets.only(top: index == 0 ? 0 : 25),
                              child: ChatItem(
                                index: index,
                                onTap: () => GRouter.router.pushNamed(
                                    GRouter.config.chatsRoutes.chatPage),
                              ),
                            ),
                          ))
                ],
              ),
            ),
          )),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: AppText(
        "Messages",
        style: context.textTheme.bodyMedium.s20.m,
      ),
    );
  }
}

// Animated wrapper for app bar content
class _AnimatedAppBar extends StatelessWidget {
  const _AnimatedAppBar();

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: AppText(
          "Messages",
          style: context.textTheme.bodyMedium.s20.m,
        ),
      );
}

class _DelayedFadeSlide extends StatefulWidget {
  const _DelayedFadeSlide({
    required this.child,
    required this.delay,
    this.duration = const Duration(milliseconds: 820),
    this.beginOffset = const Offset(0, 0.08),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;

  @override
  State<_DelayedFadeSlide> createState() => _DelayedFadeSlideState();
}

class _DelayedFadeSlideState extends State<_DelayedFadeSlide> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        offset: _visible ? Offset.zero : widget.beginOffset,
        child: widget.child,
      ),
    );
  }
}
