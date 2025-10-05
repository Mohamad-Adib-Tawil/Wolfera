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
  List<String> messages = [
    'Hello, how are you?',
    "Hello, how are you",
    'Hello, how are you?',
    "Hello, how are you",
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.blackLight,
          appBar: appBar(context),
          body: Padding(
            padding: HWEdgeInsets.only(left: 20, right: 20, top: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (messages.isNullOrEmpty) ...[
                    169.verticalSpace,
                    const ChatsEmptyStateWidget()
                  ],
                  !messages.isNullOrEmpty
                      ? ListView.builder(
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
                        )
                      : const SizedBox()
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
