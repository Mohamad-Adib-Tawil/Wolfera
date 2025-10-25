import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wolfera/core/api/result.dart';
import 'exceptions.dart';

Future<T> throwAppException<T>(FutureOr<T> Function() call) async {
  try {
    return await call();
  } on AuthException catch (e) {
    // Debug: print full auth error details
    debugPrint('🔐 AuthException caught: ${e.message}');
    if (e.message.contains('403')) {
      throw AppNetworkException(
          message: tr(AppNetworkExceptionReason.responseError.message),
          reason: AppNetworkExceptionReason.responseError,
          exception: e);
    } else if (e.message.contains('User not found')) {
      throw AppException(
          message: 'No user found for that email.', exception: e);
    } else if (e.message.contains('Invalid login credentials')) {
      throw AppException(
          message: 'Incorrect password provided for this user.', exception: e);
    } else if (e.message.contains('Password should be')) {
      throw AppException(
          message: 'The password provided is too weak.', exception: e);
    } else if (e.message.contains('already registered')) {
      throw AppException(
          message: 'An account already exists for this email.', exception: e);
    } else if (e.message.contains('Invalid email')) {
      throw AppException(
          message: 'The email address is not valid.', exception: e);
    } else {
      throw AppException(
          exception: e, message: e.message);
    }
  } on PostgrestException catch (e) {
    // Debug: print full postgrest error details
    debugPrint('🗄️ PostgrestException caught: code=${e.code}, message=${e.message}, details=${e.details}');
    throw AppNetworkResponseException(
        exception: e, data: e.message);
  } on SocketException catch (e) {
    showMessage(e.message);
    throw AppNetworkException(
        message: e.message,
        reason: AppNetworkExceptionReason.noInternet,
        exception: e);
  } on Exception catch (e) {
    showMessage(e.toString());
    throw AppException.unknown(exception: e, message: e.toString());
  } catch (e, s) {
    showMessage(e.toString());
    log(e.toString(), stackTrace: s);
    throw AppException.unknown(exception: e, message: e.toString());
  }
}

void showMessage(String message, {bool isSuccess = false}) {
  Fluttertoast.showToast(
      msg: tr(message),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: isSuccess ? Colors.greenAccent : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<Result<T>> toApiResult<T>(FutureOr<T> Function() call) async {
  try {
    return Success(await call());
  } on AppNetworkResponseException catch (e) {
    return Failure(e, message: e.message);
  } on AppNetworkException catch (e) {
    final appNetworkException = e.copyWith(message: e.message);
    return Failure(appNetworkException, message: e.message);
  } on AppException catch (e) {
    return Failure(e, message: e.message);
  } catch (e, s) {
    log(e.toString(), stackTrace: s);
    final exception = AppException.unknown(exception: e, message: e.toString());
    return Failure(exception, message: exception.message);
  }
}
