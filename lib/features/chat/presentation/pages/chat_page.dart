import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:wolfera/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:wolfera/core/config/routing/router.dart';
import 'package:wolfera/features/app/presentation/widgets/animations/delayed_fade_slide.dart';
import 'package:wolfera/features/chat/presentation/manager/chat_cubit.dart';
import 'package:wolfera/features/app/presentation/widgets/app_loader_widget/app_loader.dart';
import 'package:wolfera/services/chat_route_tracker.dart';
import '../widgets/chat_text_field.dart';
import '../widgets/messages_list_view_widget.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic>? chatData;
  
  const ChatPage({
    super.key,
    this.chatData,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static bool _didAnimateOnce = false;
  late final bool _shouldAnimateEntrance;
  late final ChatCubit _chatCubit;
  StreamSubscription<ChatState>? _sub;

  @override
  void initState() {
    super.initState();
    _shouldAnimateEntrance = !_didAnimateOnce;
    _didAnimateOnce = true;
    
    _chatCubit = GetIt.I<ChatCubit>();
    
    // تهيئة المحادثة مع البيانات المستلمة
    final data = widget.chatData ?? {};
    _chatCubit.initializeConversation(
      sellerId: data['seller_id']?.toString(),
      carId: (data['car_id'] ?? data['carId'])?.toString(),
      sellerName: data['seller_name']?.toString(),
      carTitle: data['car_title']?.toString(),
      conversationId: data['conversation_id']?.toString(),
    );

    // حدّد tracker بحسب المعطى الأولي إن وجد
    final initialConv = data['conversation_id']?.toString();
    if (initialConv != null && initialConv.isNotEmpty) {
      ChatRouteTracker.enter(initialConv);
    }

    // راقب تغيّر معرف المحادثة من الحالة
    _sub = _chatCubit.stream.listen((s) {
      final cid = s.conversationId;
      if (cid != null && cid.isNotEmpty) {
        ChatRouteTracker.enter(cid);
      }
    });
  }
  
  @override
  void dispose() {
    _sub?.cancel();
    ChatRouteTracker.exit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatCubit,
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final extras = widget.chatData ?? const {};
          final headerName = state.otherUserName ?? extras['seller_name']?.toString();
          final headerAvatar = state.otherUserAvatar ?? extras['seller_avatar']?.toString();
          final headerCarTitle = state.carTitle ?? extras['car_title']?.toString();

          if (state.error != null) {
            return Scaffold(
              appBar: ChatAppbar(
                otherUserName: headerName,
                carTitle: headerCarTitle,
                otherUserAvatar: headerAvatar,
              ),
              body: Center(
                child: Text(state.error!),
              ),
            );
          }
          
          const messagesList = MessagesListViewWidget();
          const input = ChatTextField();
          
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: _shouldAnimateEntrance
                  ? DelayedFadeSlide(
                      delay: const Duration(milliseconds: 80),
                      duration: const Duration(milliseconds: 1000),
                      beginOffset: const Offset(0, -0.24),
                      child: ChatAppbar(
                        otherUserName: headerName,
                        carTitle: headerCarTitle,
                        otherUserAvatar: headerAvatar,
                        onTapHeader: () {
                          final otherId = state.otherUserId;
                          if (otherId == null || otherId.isEmpty) return;
                          GRouter.router.pushNamed(
                            GRouter.config.chatsRoutes.sellerProfile,
                            extra: {
                              'seller_id': otherId,
                              'seller_name': headerName,
                              'seller_avatar': headerAvatar,
                            },
                          );
                        },
                      ),
                    )
                  : ChatAppbar(
                      otherUserName: headerName,
                      carTitle: headerCarTitle,
                      otherUserAvatar: headerAvatar,
                      onTapHeader: () {
                        final otherId = state.otherUserId;
                        if (otherId == null || otherId.isEmpty) return;
                        GRouter.router.pushNamed(
                          GRouter.config.chatsRoutes.sellerProfile,
                          extra: {
                            'seller_id': otherId,
                            'seller_name': headerName,
                            'seller_avatar': headerAvatar,
                          },
                        );
                      },
                    ),
            ),
            body: state.isLoading
                ? const Center(child: AppLoader())
                : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                5.verticalSpace,
                Expanded(
                  child: _shouldAnimateEntrance
                      ? DelayedFadeSlide(
                          delay: const Duration(milliseconds: 220),
                          duration: const Duration(milliseconds: 1000),
                          beginOffset: const Offset(-0.24, 0),
                          child: messagesList,
                        )
                      : messagesList,
                ),
                _shouldAnimateEntrance
                    ? DelayedFadeSlide(
                        delay: const Duration(milliseconds: 340),
                        duration: const Duration(milliseconds: 1000),
                        beginOffset: const Offset(0, 0.24),
                        child: input,
                      )
                    : input,
                5.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }
}
