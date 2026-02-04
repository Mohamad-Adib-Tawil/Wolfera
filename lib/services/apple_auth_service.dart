import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthResult {
  final String idToken;
  final String rawNonce;
  final String? email;
  final String? displayName;

  AppleAuthResult({
    required this.idToken,
    required this.rawNonce,
    this.email,
    this.displayName,
  });
}

class AppleAuthService {
  AppleAuthService._();

  // Generates a cryptographically secure random nonce
  static String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Prompts the user with the native Sign in with Apple sheet and returns
  /// the [idToken] and [rawNonce] required to authenticate with Supabase.
  static Future<AppleAuthResult> getIdTokenAndUserInfo() async {
    try {
      final rawNonce = _generateNonce();
      final hashedNonce = _sha256ofString(rawNonce);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        throw 'apple_no_identity_token';
      }

      String? displayName;
      if (credential.givenName != null || credential.familyName != null) {
        final first = credential.givenName?.trim();
        final last = credential.familyName?.trim();
        displayName = [first, last].where((p) => (p ?? '').isNotEmpty).join(' ').trim();
        if (displayName.isEmpty) displayName = null;
      }

      return AppleAuthResult(
        idToken: idToken,
        rawNonce: rawNonce,
        email: credential.email,
        displayName: displayName,
      );
    } on SignInWithAppleAuthorizationException catch (e, st) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('apple_signin_error: ${e.code} ${e.message}\n$st');
      }
      if (e.code == AuthorizationErrorCode.canceled) {
        throw 'apple_signin_canceled';
      }
      throw 'apple_signin_failed';
    } catch (e, st) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('apple_signin_unexpected: $e\n$st');
      }
      final msg = e.toString();
      if (msg.contains('SocketException') || msg.contains('network')) {
        throw 'apple_signin_network_error';
      }
      throw 'apple_signin_failed';
    }
  }
}
