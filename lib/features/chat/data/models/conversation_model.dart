import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'message_model.dart';
import '../../../profile/data/models/user_model.dart';
import '../../../cars/data/models/car_model.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    String? id,
    required String carId,
    required String buyerId,
    required String sellerId,
    String? lastMessage,
    DateTime? lastMessageAt,
    @Default(0) int buyerUnreadCount,
    @Default(0) int sellerUnreadCount,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    
    // Relations (populated via joins)
    @JsonKey(includeFromJson: false, includeToJson: false)
    CarModel? car,
    @JsonKey(includeFromJson: false, includeToJson: false)
    UserModel? buyer,
    @JsonKey(includeFromJson: false, includeToJson: false)
    UserModel? seller,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<MessageModel>? messages,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
  
  const ConversationModel._();
  
  // Helper methods
  int getUnreadCount(String userId) {
    if (userId == buyerId) return buyerUnreadCount;
    if (userId == sellerId) return sellerUnreadCount;
    return 0;
  }
  
  bool hasUnread(String userId) => getUnreadCount(userId) > 0;
  
  String getOtherUserId(String currentUserId) {
    return currentUserId == buyerId ? sellerId : buyerId;
  }
  
  UserModel? getOtherUser(String currentUserId) {
    return currentUserId == buyerId ? seller : buyer;
  }
  
  String getTitle(String currentUserId) {
    final otherUser = getOtherUser(currentUserId);
    return otherUser?.fullName ?? 'User';
  }
  
  String getSubtitle() {
    if (lastMessage == null || lastMessage!.isEmpty) {
      return 'Start a conversation';
    }
    return lastMessage!;
  }
  
  String getFormattedTime() {
    if (lastMessageAt == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(lastMessageAt!);
    
    if (difference.inDays > 7) {
      return DateFormat('dd/MM').format(lastMessageAt!);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
  
  // Create new conversation for Supabase
  Map<String, dynamic> toCreateJson() {
    return {
      'car_id': carId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'is_active': true,
    };
  }
}
