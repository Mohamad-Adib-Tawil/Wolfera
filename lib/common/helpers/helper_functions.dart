import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wolfera/features/app/domin/repositories/prefs_repository.dart';
import 'package:wolfera/features/app/presentation/bloc/app_manager_cubit.dart';
import '../constants/constants.dart';
import 'package:faker/faker.dart' hide countries;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class HelperFunctions {
  HelperFunctions._singleton();

  static HelperFunctions? _instance;

  factory HelperFunctions() {
    return instance;
  }

  Future<void> logout() async {
    await refresh();
    // await FirebaseService.deleteFcmToken();
    GetIt.I<AppManagerCubit>().checkUser();
    await GetIt.I<PrefsRepository>().clearLocal();
    return;
  }

  Future<void> refresh() async {
    await GetIt.I.resetLazySingleton<Dio>();
    // await GetIt.I.resetLazySingleton<CarsCubit>();
    // await GetIt.I.resetLazySingleton<HomeCubit>();
    // await GetIt.I.resetLazySingleton<ProfileBloc>();
    // await GetIt.I.resetLazySingleton<NotificationsBloc>();
    // await GetIt.I.resetLazySingleton<SettingsCubit>();
  }

  static HelperFunctions get instance =>
      _instance ??= HelperFunctions._singleton();

  bool hasReachedMax<T>(List<T>? list) => (list ?? []).length < kPerPage;

  Future<File?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) {
      return null;
    }
    final file = await _compressAndGetFile(File(pickedFile.path));

    return file ?? File(pickedFile.path);
  }

  static Future<File?> _compressAndGetFile(File file) async {
    final dir = await getTemporaryDirectory();
    String fileExtension = path.extension(file.path);

    final targetPath =
        '${dir.absolute.path}/${const Uuid().v4()}$fileExtension';
    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 75,
      format: fileExtension == ".jpg" || fileExtension == ".jpeg"
          ? CompressFormat.jpeg
          : fileExtension == ".png"
              ? CompressFormat.png
              : fileExtension == ".heic"
                  ? CompressFormat.heic
                  : CompressFormat.webp,
    );

    return result != null ? File(result.path) : null;
  }

  String getFakeImageUrl({
    List<String>? keywords,
    final bool random = true,
    int width = 640,
    int height = 480,
  }) =>
      Faker().image.image(
            keywords: keywords ?? ["car"],
            random: random,
            width: width,
            height: height,
          );

  // Country getDefaultCountry({String? dialCode}) {
  //   final deviceCountryCode =
  //       WidgetsBinding.instance.platformDispatcher.locale.countryCode;

  //   return defaultCountry;
  //   // return countries.singleWhere(
  //   //   (element) => dialCode != null ? element.dialCode == dialCode : element.code == deviceCountryCode,
  //   //   orElse: () => defaultCountry,
  //   // );
  // }
}
