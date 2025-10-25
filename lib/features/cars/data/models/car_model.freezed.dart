// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarModel _$CarModelFromJson(Map<String, dynamic> json) {
  return _CarModel.fromJson(json);
}

/// @nodoc
mixin _$CarModel {
  String? get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError; // Basic Info
  String get brand => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError; // Specifications
  int? get mileage => throw _privateConstructorUsedError;
  String? get transmission =>
      throw _privateConstructorUsedError; // manual, automatic, cvt, dct
  String? get fuelType =>
      throw _privateConstructorUsedError; // petrol, diesel, electric, hybrid
  String? get bodyType => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  double? get engineCapacity => throw _privateConstructorUsedError;
  int? get cylinders => throw _privateConstructorUsedError;
  int? get seats => throw _privateConstructorUsedError;
  int? get doors => throw _privateConstructorUsedError;
  String? get driveType =>
      throw _privateConstructorUsedError; // fwd, rwd, awd, 4wd
// Condition
  String get condition =>
      throw _privateConstructorUsedError; // new, used, certified
  bool get accidentsHistory => throw _privateConstructorUsedError;
  bool get serviceHistory => throw _privateConstructorUsedError;
  bool get warranty => throw _privateConstructorUsedError;
  String? get warrantyDetails =>
      throw _privateConstructorUsedError; // Description
  String get title => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Features (JSON arrays in database)
  List<String> get safetyFeatures => throw _privateConstructorUsedError;
  List<String> get interiorFeatures => throw _privateConstructorUsedError;
  List<String> get exteriorFeatures =>
      throw _privateConstructorUsedError; // Images
  String? get mainImageUrl => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError; // Location
  String? get location => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError; // Status
  String get status =>
      throw _privateConstructorUsedError; // active, sold, pending, inactive
  int get viewsCount => throw _privateConstructorUsedError;
  int get favoritesCount => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError; // Timestamps
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get soldAt => throw _privateConstructorUsedError;

  /// Serializes this CarModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarModelCopyWith<CarModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarModelCopyWith<$Res> {
  factory $CarModelCopyWith(CarModel value, $Res Function(CarModel) then) =
      _$CarModelCopyWithImpl<$Res, CarModel>;
  @useResult
  $Res call(
      {String? id,
      String userId,
      String brand,
      String model,
      int year,
      double price,
      String currency,
      int? mileage,
      String? transmission,
      String? fuelType,
      String? bodyType,
      String? color,
      double? engineCapacity,
      int? cylinders,
      int? seats,
      int? doors,
      String? driveType,
      String condition,
      bool accidentsHistory,
      bool serviceHistory,
      bool warranty,
      String? warrantyDetails,
      String title,
      String? description,
      List<String> safetyFeatures,
      List<String> interiorFeatures,
      List<String> exteriorFeatures,
      String? mainImageUrl,
      List<String> imageUrls,
      String? location,
      String? city,
      String? country,
      double? latitude,
      double? longitude,
      String status,
      int viewsCount,
      int favoritesCount,
      bool isFeatured,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? soldAt});
}

/// @nodoc
class _$CarModelCopyWithImpl<$Res, $Val extends CarModel>
    implements $CarModelCopyWith<$Res> {
  _$CarModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? brand = null,
    Object? model = null,
    Object? year = null,
    Object? price = null,
    Object? currency = null,
    Object? mileage = freezed,
    Object? transmission = freezed,
    Object? fuelType = freezed,
    Object? bodyType = freezed,
    Object? color = freezed,
    Object? engineCapacity = freezed,
    Object? cylinders = freezed,
    Object? seats = freezed,
    Object? doors = freezed,
    Object? driveType = freezed,
    Object? condition = null,
    Object? accidentsHistory = null,
    Object? serviceHistory = null,
    Object? warranty = null,
    Object? warrantyDetails = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? safetyFeatures = null,
    Object? interiorFeatures = null,
    Object? exteriorFeatures = null,
    Object? mainImageUrl = freezed,
    Object? imageUrls = null,
    Object? location = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? status = null,
    Object? viewsCount = null,
    Object? favoritesCount = null,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? soldAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      mileage: freezed == mileage
          ? _value.mileage
          : mileage // ignore: cast_nullable_to_non_nullable
              as int?,
      transmission: freezed == transmission
          ? _value.transmission
          : transmission // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      bodyType: freezed == bodyType
          ? _value.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      engineCapacity: freezed == engineCapacity
          ? _value.engineCapacity
          : engineCapacity // ignore: cast_nullable_to_non_nullable
              as double?,
      cylinders: freezed == cylinders
          ? _value.cylinders
          : cylinders // ignore: cast_nullable_to_non_nullable
              as int?,
      seats: freezed == seats
          ? _value.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as int?,
      doors: freezed == doors
          ? _value.doors
          : doors // ignore: cast_nullable_to_non_nullable
              as int?,
      driveType: freezed == driveType
          ? _value.driveType
          : driveType // ignore: cast_nullable_to_non_nullable
              as String?,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      accidentsHistory: null == accidentsHistory
          ? _value.accidentsHistory
          : accidentsHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      serviceHistory: null == serviceHistory
          ? _value.serviceHistory
          : serviceHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      warranty: null == warranty
          ? _value.warranty
          : warranty // ignore: cast_nullable_to_non_nullable
              as bool,
      warrantyDetails: freezed == warrantyDetails
          ? _value.warrantyDetails
          : warrantyDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      safetyFeatures: null == safetyFeatures
          ? _value.safetyFeatures
          : safetyFeatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      interiorFeatures: null == interiorFeatures
          ? _value.interiorFeatures
          : interiorFeatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      exteriorFeatures: null == exteriorFeatures
          ? _value.exteriorFeatures
          : exteriorFeatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mainImageUrl: freezed == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoritesCount: null == favoritesCount
          ? _value.favoritesCount
          : favoritesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      soldAt: freezed == soldAt
          ? _value.soldAt
          : soldAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarModelImplCopyWith<$Res>
    implements $CarModelCopyWith<$Res> {
  factory _$$CarModelImplCopyWith(
          _$CarModelImpl value, $Res Function(_$CarModelImpl) then) =
      __$$CarModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String userId,
      String brand,
      String model,
      int year,
      double price,
      String currency,
      int? mileage,
      String? transmission,
      String? fuelType,
      String? bodyType,
      String? color,
      double? engineCapacity,
      int? cylinders,
      int? seats,
      int? doors,
      String? driveType,
      String condition,
      bool accidentsHistory,
      bool serviceHistory,
      bool warranty,
      String? warrantyDetails,
      String title,
      String? description,
      List<String> safetyFeatures,
      List<String> interiorFeatures,
      List<String> exteriorFeatures,
      String? mainImageUrl,
      List<String> imageUrls,
      String? location,
      String? city,
      String? country,
      double? latitude,
      double? longitude,
      String status,
      int viewsCount,
      int favoritesCount,
      bool isFeatured,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? soldAt});
}

/// @nodoc
class __$$CarModelImplCopyWithImpl<$Res>
    extends _$CarModelCopyWithImpl<$Res, _$CarModelImpl>
    implements _$$CarModelImplCopyWith<$Res> {
  __$$CarModelImplCopyWithImpl(
      _$CarModelImpl _value, $Res Function(_$CarModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? brand = null,
    Object? model = null,
    Object? year = null,
    Object? price = null,
    Object? currency = null,
    Object? mileage = freezed,
    Object? transmission = freezed,
    Object? fuelType = freezed,
    Object? bodyType = freezed,
    Object? color = freezed,
    Object? engineCapacity = freezed,
    Object? cylinders = freezed,
    Object? seats = freezed,
    Object? doors = freezed,
    Object? driveType = freezed,
    Object? condition = null,
    Object? accidentsHistory = null,
    Object? serviceHistory = null,
    Object? warranty = null,
    Object? warrantyDetails = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? safetyFeatures = null,
    Object? interiorFeatures = null,
    Object? exteriorFeatures = null,
    Object? mainImageUrl = freezed,
    Object? imageUrls = null,
    Object? location = freezed,
    Object? city = freezed,
    Object? country = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? status = null,
    Object? viewsCount = null,
    Object? favoritesCount = null,
    Object? isFeatured = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? soldAt = freezed,
  }) {
    return _then(_$CarModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      mileage: freezed == mileage
          ? _value.mileage
          : mileage // ignore: cast_nullable_to_non_nullable
              as int?,
      transmission: freezed == transmission
          ? _value.transmission
          : transmission // ignore: cast_nullable_to_non_nullable
              as String?,
      fuelType: freezed == fuelType
          ? _value.fuelType
          : fuelType // ignore: cast_nullable_to_non_nullable
              as String?,
      bodyType: freezed == bodyType
          ? _value.bodyType
          : bodyType // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      engineCapacity: freezed == engineCapacity
          ? _value.engineCapacity
          : engineCapacity // ignore: cast_nullable_to_non_nullable
              as double?,
      cylinders: freezed == cylinders
          ? _value.cylinders
          : cylinders // ignore: cast_nullable_to_non_nullable
              as int?,
      seats: freezed == seats
          ? _value.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as int?,
      doors: freezed == doors
          ? _value.doors
          : doors // ignore: cast_nullable_to_non_nullable
              as int?,
      driveType: freezed == driveType
          ? _value.driveType
          : driveType // ignore: cast_nullable_to_non_nullable
              as String?,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      accidentsHistory: null == accidentsHistory
          ? _value.accidentsHistory
          : accidentsHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      serviceHistory: null == serviceHistory
          ? _value.serviceHistory
          : serviceHistory // ignore: cast_nullable_to_non_nullable
              as bool,
      warranty: null == warranty
          ? _value.warranty
          : warranty // ignore: cast_nullable_to_non_nullable
              as bool,
      warrantyDetails: freezed == warrantyDetails
          ? _value.warrantyDetails
          : warrantyDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      safetyFeatures: null == safetyFeatures
          ? _value._safetyFeatures
          : safetyFeatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      interiorFeatures: null == interiorFeatures
          ? _value._interiorFeatures
          : interiorFeatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      exteriorFeatures: null == exteriorFeatures
          ? _value._exteriorFeatures
          : exteriorFeatures // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mainImageUrl: freezed == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      favoritesCount: null == favoritesCount
          ? _value.favoritesCount
          : favoritesCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      soldAt: freezed == soldAt
          ? _value.soldAt
          : soldAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarModelImpl extends _CarModel {
  const _$CarModelImpl(
      {this.id,
      required this.userId,
      required this.brand,
      required this.model,
      required this.year,
      required this.price,
      this.currency = 'USD',
      this.mileage,
      this.transmission,
      this.fuelType,
      this.bodyType,
      this.color,
      this.engineCapacity,
      this.cylinders,
      this.seats,
      this.doors,
      this.driveType,
      this.condition = 'used',
      this.accidentsHistory = false,
      this.serviceHistory = false,
      this.warranty = false,
      this.warrantyDetails,
      required this.title,
      this.description,
      final List<String> safetyFeatures = const [],
      final List<String> interiorFeatures = const [],
      final List<String> exteriorFeatures = const [],
      this.mainImageUrl,
      final List<String> imageUrls = const [],
      this.location,
      this.city,
      this.country,
      this.latitude,
      this.longitude,
      this.status = 'active',
      this.viewsCount = 0,
      this.favoritesCount = 0,
      this.isFeatured = false,
      this.createdAt,
      this.updatedAt,
      this.soldAt})
      : _safetyFeatures = safetyFeatures,
        _interiorFeatures = interiorFeatures,
        _exteriorFeatures = exteriorFeatures,
        _imageUrls = imageUrls,
        super._();

  factory _$CarModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String userId;
// Basic Info
  @override
  final String brand;
  @override
  final String model;
  @override
  final int year;
  @override
  final double price;
  @override
  @JsonKey()
  final String currency;
// Specifications
  @override
  final int? mileage;
  @override
  final String? transmission;
// manual, automatic, cvt, dct
  @override
  final String? fuelType;
// petrol, diesel, electric, hybrid
  @override
  final String? bodyType;
  @override
  final String? color;
  @override
  final double? engineCapacity;
  @override
  final int? cylinders;
  @override
  final int? seats;
  @override
  final int? doors;
  @override
  final String? driveType;
// fwd, rwd, awd, 4wd
// Condition
  @override
  @JsonKey()
  final String condition;
// new, used, certified
  @override
  @JsonKey()
  final bool accidentsHistory;
  @override
  @JsonKey()
  final bool serviceHistory;
  @override
  @JsonKey()
  final bool warranty;
  @override
  final String? warrantyDetails;
// Description
  @override
  final String title;
  @override
  final String? description;
// Features (JSON arrays in database)
  final List<String> _safetyFeatures;
// Features (JSON arrays in database)
  @override
  @JsonKey()
  List<String> get safetyFeatures {
    if (_safetyFeatures is EqualUnmodifiableListView) return _safetyFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_safetyFeatures);
  }

  final List<String> _interiorFeatures;
  @override
  @JsonKey()
  List<String> get interiorFeatures {
    if (_interiorFeatures is EqualUnmodifiableListView)
      return _interiorFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interiorFeatures);
  }

  final List<String> _exteriorFeatures;
  @override
  @JsonKey()
  List<String> get exteriorFeatures {
    if (_exteriorFeatures is EqualUnmodifiableListView)
      return _exteriorFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exteriorFeatures);
  }

// Images
  @override
  final String? mainImageUrl;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

// Location
  @override
  final String? location;
  @override
  final String? city;
  @override
  final String? country;
  @override
  final double? latitude;
  @override
  final double? longitude;
// Status
  @override
  @JsonKey()
  final String status;
// active, sold, pending, inactive
  @override
  @JsonKey()
  final int viewsCount;
  @override
  @JsonKey()
  final int favoritesCount;
  @override
  @JsonKey()
  final bool isFeatured;
// Timestamps
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? soldAt;

  @override
  String toString() {
    return 'CarModel(id: $id, userId: $userId, brand: $brand, model: $model, year: $year, price: $price, currency: $currency, mileage: $mileage, transmission: $transmission, fuelType: $fuelType, bodyType: $bodyType, color: $color, engineCapacity: $engineCapacity, cylinders: $cylinders, seats: $seats, doors: $doors, driveType: $driveType, condition: $condition, accidentsHistory: $accidentsHistory, serviceHistory: $serviceHistory, warranty: $warranty, warrantyDetails: $warrantyDetails, title: $title, description: $description, safetyFeatures: $safetyFeatures, interiorFeatures: $interiorFeatures, exteriorFeatures: $exteriorFeatures, mainImageUrl: $mainImageUrl, imageUrls: $imageUrls, location: $location, city: $city, country: $country, latitude: $latitude, longitude: $longitude, status: $status, viewsCount: $viewsCount, favoritesCount: $favoritesCount, isFeatured: $isFeatured, createdAt: $createdAt, updatedAt: $updatedAt, soldAt: $soldAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.mileage, mileage) || other.mileage == mileage) &&
            (identical(other.transmission, transmission) ||
                other.transmission == transmission) &&
            (identical(other.fuelType, fuelType) ||
                other.fuelType == fuelType) &&
            (identical(other.bodyType, bodyType) ||
                other.bodyType == bodyType) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.engineCapacity, engineCapacity) ||
                other.engineCapacity == engineCapacity) &&
            (identical(other.cylinders, cylinders) ||
                other.cylinders == cylinders) &&
            (identical(other.seats, seats) || other.seats == seats) &&
            (identical(other.doors, doors) || other.doors == doors) &&
            (identical(other.driveType, driveType) ||
                other.driveType == driveType) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.accidentsHistory, accidentsHistory) ||
                other.accidentsHistory == accidentsHistory) &&
            (identical(other.serviceHistory, serviceHistory) ||
                other.serviceHistory == serviceHistory) &&
            (identical(other.warranty, warranty) ||
                other.warranty == warranty) &&
            (identical(other.warrantyDetails, warrantyDetails) ||
                other.warrantyDetails == warrantyDetails) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._safetyFeatures, _safetyFeatures) &&
            const DeepCollectionEquality()
                .equals(other._interiorFeatures, _interiorFeatures) &&
            const DeepCollectionEquality()
                .equals(other._exteriorFeatures, _exteriorFeatures) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.favoritesCount, favoritesCount) ||
                other.favoritesCount == favoritesCount) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.soldAt, soldAt) || other.soldAt == soldAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        brand,
        model,
        year,
        price,
        currency,
        mileage,
        transmission,
        fuelType,
        bodyType,
        color,
        engineCapacity,
        cylinders,
        seats,
        doors,
        driveType,
        condition,
        accidentsHistory,
        serviceHistory,
        warranty,
        warrantyDetails,
        title,
        description,
        const DeepCollectionEquality().hash(_safetyFeatures),
        const DeepCollectionEquality().hash(_interiorFeatures),
        const DeepCollectionEquality().hash(_exteriorFeatures),
        mainImageUrl,
        const DeepCollectionEquality().hash(_imageUrls),
        location,
        city,
        country,
        latitude,
        longitude,
        status,
        viewsCount,
        favoritesCount,
        isFeatured,
        createdAt,
        updatedAt,
        soldAt
      ]);

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarModelImplCopyWith<_$CarModelImpl> get copyWith =>
      __$$CarModelImplCopyWithImpl<_$CarModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarModelImplToJson(
      this,
    );
  }
}

abstract class _CarModel extends CarModel {
  const factory _CarModel(
      {final String? id,
      required final String userId,
      required final String brand,
      required final String model,
      required final int year,
      required final double price,
      final String currency,
      final int? mileage,
      final String? transmission,
      final String? fuelType,
      final String? bodyType,
      final String? color,
      final double? engineCapacity,
      final int? cylinders,
      final int? seats,
      final int? doors,
      final String? driveType,
      final String condition,
      final bool accidentsHistory,
      final bool serviceHistory,
      final bool warranty,
      final String? warrantyDetails,
      required final String title,
      final String? description,
      final List<String> safetyFeatures,
      final List<String> interiorFeatures,
      final List<String> exteriorFeatures,
      final String? mainImageUrl,
      final List<String> imageUrls,
      final String? location,
      final String? city,
      final String? country,
      final double? latitude,
      final double? longitude,
      final String status,
      final int viewsCount,
      final int favoritesCount,
      final bool isFeatured,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? soldAt}) = _$CarModelImpl;
  const _CarModel._() : super._();

  factory _CarModel.fromJson(Map<String, dynamic> json) =
      _$CarModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get userId; // Basic Info
  @override
  String get brand;
  @override
  String get model;
  @override
  int get year;
  @override
  double get price;
  @override
  String get currency; // Specifications
  @override
  int? get mileage;
  @override
  String? get transmission; // manual, automatic, cvt, dct
  @override
  String? get fuelType; // petrol, diesel, electric, hybrid
  @override
  String? get bodyType;
  @override
  String? get color;
  @override
  double? get engineCapacity;
  @override
  int? get cylinders;
  @override
  int? get seats;
  @override
  int? get doors;
  @override
  String? get driveType; // fwd, rwd, awd, 4wd
// Condition
  @override
  String get condition; // new, used, certified
  @override
  bool get accidentsHistory;
  @override
  bool get serviceHistory;
  @override
  bool get warranty;
  @override
  String? get warrantyDetails; // Description
  @override
  String get title;
  @override
  String? get description; // Features (JSON arrays in database)
  @override
  List<String> get safetyFeatures;
  @override
  List<String> get interiorFeatures;
  @override
  List<String> get exteriorFeatures; // Images
  @override
  String? get mainImageUrl;
  @override
  List<String> get imageUrls; // Location
  @override
  String? get location;
  @override
  String? get city;
  @override
  String? get country;
  @override
  double? get latitude;
  @override
  double? get longitude; // Status
  @override
  String get status; // active, sold, pending, inactive
  @override
  int get viewsCount;
  @override
  int get favoritesCount;
  @override
  bool get isFeatured; // Timestamps
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get soldAt;

  /// Create a copy of CarModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarModelImplCopyWith<_$CarModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
