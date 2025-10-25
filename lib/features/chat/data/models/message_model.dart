import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import '../../../profile/data/models/user_model.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    String? id,
    required String conversationId,
    required String senderId,
    required String messageText,
    @Default('text') String messageType, // text, image, offer
    @Default([]) List<String> attachments,
    @Default(false) bool isRead,
    DateTime? readAt,
    DateTime? createdAt,
    
    // Additional fields for UI
    @JsonKey(includeFromJson: false, includeToJson: false)
    UserModel? sender,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
  
  const MessageModel._();
  
  // Helper methods
  bool get isTextMessage => messageType == 'text';
  bool get isImageMessage => messageType == 'image';
  bool get isOfferMessage => messageType == 'offer';
  bool get hasAttachments => attachments.isNotEmpty;
  
  // Check if message is from current user
  bool isFromMe(String currentUserId) => senderId == currentUserId;
  
  // Format time for display
  String get formattedTime {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    
    if (difference.inDays > 7) {
      return DateFormat('dd/MM/yyyy').format(createdAt!);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
