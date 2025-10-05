import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wolfera/common/models/page_state/page_state.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@lazySingleton
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // final GetChatsUsecase _getChatsUsecase;

  ChatBloc(
      // this._getChatsUsecase,

      )
      : super(const ChatState()) {
    on<GetChatEvent>(_onGetChatEvent);
  }

  final PageController pagedChatController = PageController();

  FutureOr<void> _onGetChatEvent(
      GetChatEvent event, Emitter<ChatState> emit) async {
    // emit(state.copyWith(cartState: const PageState.loading()));

    // final result =
    //     await _getChatUsecase(GetChatParams(userId: event.userId));

    // result.fold(
    //   (exception, message) => emit(
    //       state.copyWith(cartState: PageState.error(exception: exception))),
    //   (value) {
    //     emit(state.copyWith(
    //         cartCount: (value.data ?? []).length,
    //         cartState: PageState.loaded(
    //             data: (value.data ?? [])
    //                 .map((e) => ChatItemViewModel(item: e))
    //                 .toList())));
    //   },
    // );
  }
}
