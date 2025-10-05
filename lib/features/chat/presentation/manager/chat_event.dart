part of 'chat_bloc.dart';

abstract class ChatEvent {}

class GetChatEvent extends ChatEvent {
  final int userId;

  GetChatEvent({required this.userId});
}
