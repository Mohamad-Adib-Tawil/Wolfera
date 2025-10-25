// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return _ConversationModel.fromJson(json);
}

/// @nodoc
mixin _$ConversationModel {
  String? get id => throw _privateConstructorUsedError;
  String get carId => throw _privateConstructorUsedError;
  String get buyerId => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  int get buyerUnreadCount => throw _privateConstructorUsedError;
  int get sellerUnreadCount => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Relations (populated via joins)
  @JsonKey(includeFromJson: false, includeToJson: false)
  CarModel? get car => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  UserModel? get buyer => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  UserModel? get seller => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<MessageModel>? get messages => throw _privateConstructorUsedError;

  /// Serializes this ConversationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationModelCopyWith<ConversationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationModelCopyWith<$Res> {
  factory $ConversationModelCopyWith(
          ConversationModel value, $Res Function(ConversationModel) then) =
      _$ConversationModelCopyWithImpl<$Res, ConversationModel>;
  @useResult
  $Res call(
      {String? id,
      String carId,
      String buyerId,
      String sellerId,
      String? lastMessage,
      DateTime? lastMessageAt,
      int buyerUnreadCount,
      int sellerUnreadCount,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) CarModel? car,
      @JsonKey(includeFromJson: false, includeToJson: false) UserModel? buyer,
      @JsonKey(includeFromJson: false, includeToJson: false) UserModel? seller,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<MessageModel>? messages});

  $CarModelCopyWith<$Res>? get car;
  $UserModelCopyWith<$Res>? get buyer;
  $UserModelCopyWith<$Res>? get seller;
}

/// @nodoc
class _$ConversationModelCopyWithImpl<$Res, $Val extends ConversationModel>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? carId = null,
    Object? buyerId = null,
    Object? sellerId = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? buyerUnreadCount = null,
    Object? sellerUnreadCount = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? car = freezed,
    Object? buyer = freezed,
    Object? seller = freezed,
    Object? messages = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      carId: null == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String,
      buyerId: null == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      buyerUnreadCount: null == buyerUnreadCount
          ? _value.buyerUnreadCount
          : buyerUnreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      sellerUnreadCount: null == sellerUnreadCount
          ? _value.sellerUnreadCount
          : sellerUnreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      car: freezed == car
          ? _value.car
          : car // ignore: cast_nullable_to_non_nullable
              as CarModel?,
      buyer: freezed == buyer
          ? _value.buyer
          : buyer // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      seller: freezed == seller
          ? _value.seller
          : seller // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      messages: freezed == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageModel>?,
    ) as $Val);
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CarModelCopyWith<$Res>? get car {
    if (_value.car == null) {
      return null;
    }

    return $CarModelCopyWith<$Res>(_value.car!, (value) {
      return _then(_value.copyWith(car: value) as $Val);
    });
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get buyer {
    if (_value.buyer == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.buyer!, (value) {
      return _then(_value.copyWith(buyer: value) as $Val);
    });
  }

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get seller {
    if (_value.seller == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.seller!, (value) {
      return _then(_value.copyWith(seller: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationModelImplCopyWith<$Res>
    implements $ConversationModelCopyWith<$Res> {
  factory _$$ConversationModelImplCopyWith(_$ConversationModelImpl value,
          $Res Function(_$ConversationModelImpl) then) =
      __$$ConversationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String carId,
      String buyerId,
      String sellerId,
      String? lastMessage,
      DateTime? lastMessageAt,
      int buyerUnreadCount,
      int sellerUnreadCount,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) CarModel? car,
      @JsonKey(includeFromJson: false, includeToJson: false) UserModel? buyer,
      @JsonKey(includeFromJson: false, includeToJson: false) UserModel? seller,
      @JsonKey(includeFromJson: false, includeToJson: false)
      List<MessageModel>? messages});

  @override
  $CarModelCopyWith<$Res>? get car;
  @override
  $UserModelCopyWith<$Res>? get buyer;
  @override
  $UserModelCopyWith<$Res>? get seller;
}

/// @nodoc
class __$$ConversationModelImplCopyWithImpl<$Res>
    extends _$ConversationModelCopyWithImpl<$Res, _$ConversationModelImpl>
    implements _$$ConversationModelImplCopyWith<$Res> {
  __$$ConversationModelImplCopyWithImpl(_$ConversationModelImpl _value,
      $Res Function(_$ConversationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? carId = null,
    Object? buyerId = null,
    Object? sellerId = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? buyerUnreadCount = null,
    Object? sellerUnreadCount = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? car = freezed,
    Object? buyer = freezed,
    Object? seller = freezed,
    Object? messages = freezed,
  }) {
    return _then(_$ConversationModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      carId: null == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String,
      buyerId: null == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: freezed == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      buyerUnreadCount: null == buyerUnreadCount
          ? _value.buyerUnreadCount
          : buyerUnreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      sellerUnreadCount: null == sellerUnreadCount
          ? _value.sellerUnreadCount
          : sellerUnreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      car: freezed == car
          ? _value.car
          : car // ignore: cast_nullable_to_non_nullable
              as CarModel?,
      buyer: freezed == buyer
          ? _value.buyer
          : buyer // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      seller: freezed == seller
          ? _value.seller
          : seller // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      messages: freezed == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationModelImpl extends _ConversationModel {
  const _$ConversationModelImpl(
      {this.id,
      required this.carId,
      required this.buyerId,
      required this.sellerId,
      this.lastMessage,
      this.lastMessageAt,
      this.buyerUnreadCount = 0,
      this.sellerUnreadCount = 0,
      this.isActive = true,
      this.createdAt,
      this.updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false) this.car,
      @JsonKey(includeFromJson: false, includeToJson: false) this.buyer,
      @JsonKey(includeFromJson: false, includeToJson: false) this.seller,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<MessageModel>? messages})
      : _messages = messages,
        super._();

  factory _$ConversationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String carId;
  @override
  final String buyerId;
  @override
  final String sellerId;
  @override
  final String? lastMessage;
  @override
  final DateTime? lastMessageAt;
  @override
  @JsonKey()
  final int buyerUnreadCount;
  @override
  @JsonKey()
  final int sellerUnreadCount;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Relations (populated via joins)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final CarModel? car;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final UserModel? buyer;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final UserModel? seller;
  final List<MessageModel>? _messages;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<MessageModel>? get messages {
    final value = _messages;
    if (value == null) return null;
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ConversationModel(id: $id, carId: $carId, buyerId: $buyerId, sellerId: $sellerId, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, buyerUnreadCount: $buyerUnreadCount, sellerUnreadCount: $sellerUnreadCount, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, car: $car, buyer: $buyer, seller: $seller, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.carId, carId) || other.carId == carId) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.buyerUnreadCount, buyerUnreadCount) ||
                other.buyerUnreadCount == buyerUnreadCount) &&
            (identical(other.sellerUnreadCount, sellerUnreadCount) ||
                other.sellerUnreadCount == sellerUnreadCount) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.car, car) || other.car == car) &&
            (identical(other.buyer, buyer) || other.buyer == buyer) &&
            (identical(other.seller, seller) || other.seller == seller) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      carId,
      buyerId,
      sellerId,
      lastMessage,
      lastMessageAt,
      buyerUnreadCount,
      sellerUnreadCount,
      isActive,
      createdAt,
      updatedAt,
      car,
      buyer,
      seller,
      const DeepCollectionEquality().hash(_messages));

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      __$$ConversationModelImplCopyWithImpl<_$ConversationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationModelImplToJson(
      this,
    );
  }
}

abstract class _ConversationModel extends ConversationModel {
  const factory _ConversationModel(
      {final String? id,
      required final String carId,
      required final String buyerId,
      required final String sellerId,
      final String? lastMessage,
      final DateTime? lastMessageAt,
      final int buyerUnreadCount,
      final int sellerUnreadCount,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final CarModel? car,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final UserModel? buyer,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final UserModel? seller,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final List<MessageModel>? messages}) = _$ConversationModelImpl;
  const _ConversationModel._() : super._();

  factory _ConversationModel.fromJson(Map<String, dynamic> json) =
      _$ConversationModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get carId;
  @override
  String get buyerId;
  @override
  String get sellerId;
  @override
  String? get lastMessage;
  @override
  DateTime? get lastMessageAt;
  @override
  int get buyerUnreadCount;
  @override
  int get sellerUnreadCount;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Relations (populated via joins)
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  CarModel? get car;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  UserModel? get buyer;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  UserModel? get seller;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<MessageModel>? get messages;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
