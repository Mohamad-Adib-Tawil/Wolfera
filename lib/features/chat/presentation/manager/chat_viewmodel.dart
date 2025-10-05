import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class ChatItemViewModel extends Equatable {
  // final ChatItem item;

  const ChatItemViewModel(
      // {required this.item}
      );

  @override
  List<Object?> get props => [
        // item
      ];

  ChatItemViewModel copyWith(
      // {ChatItem? item}
      ) {
    return const ChatItemViewModel(
        // item: item ?? this.item
        );
  }
}
