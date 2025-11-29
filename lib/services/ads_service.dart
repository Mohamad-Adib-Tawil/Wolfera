import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:wolfera/core/utils/firebase_storage_helper.dart';
import 'package:wolfera/services/supabase_service.dart';

class AdsService {
  static SupabaseClient get _client => SupabaseService.client;

  static const String _table = 'ads'; // Expected table schema on Supabase
  // columns: id (uuid), image_url (text), storage_path (text), start_at (timestamp), end_at (timestamp), created_at (timestamp)

  // Public: fetch currently active ads to display on Home
  static Future<List<Map<String, dynamic>>> fetchActiveAds() async {
    final nowIso = DateTime.now().toIso8601String();
    final res = await _client
        .from(_table)
        .select('id, image_url, storage_path, start_at, end_at')
        .lte('start_at', nowIso)
        .gte('end_at', nowIso)
        .order('created_at', ascending: false);
    return (res as List).cast<Map<String, dynamic>>();
  }

  // Admin: fetch all ads regardless of time
  static Future<List<Map<String, dynamic>>> fetchAllAds() async {
    final isSuper = await SupabaseService.isCurrentUserSuperAdmin();
    if (!isSuper) throw Exception('admin_only_action');
    final res = await _client
        .from(_table)
        .select('id, image_url, storage_path, start_at, end_at, created_at')
        .order('created_at', ascending: false);
    return (res as List).cast<Map<String, dynamic>>();
  }

  // Admin: create new ad with image upload and duration
  static Future<Map<String, dynamic>> createAd({
    required File file,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    final isSuper = await SupabaseService.isCurrentUserSuperAdmin();
    if (!isSuper) throw Exception('admin_only_action');

    final uuid = const Uuid().v4();
    final ext = file.path.split('.').last;
    final storagePath = 'ads/$uuid.$ext';

    final publicUrl = await SupabaseStorageHelper.uploadFile(file, storagePath);

    final row = await _client
        .from(_table)
        .insert({
          'image_url': publicUrl,
          'storage_path': storagePath,
          'start_at': startAt.toIso8601String(),
          'end_at': endAt.toIso8601String(),
        })
        .select()
        .single();

    return (row as Map<String, dynamic>);
  }

  // Admin: update duration for an ad
  static Future<void> updateAdDuration({
    required String adId,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    final isSuper = await SupabaseService.isCurrentUserSuperAdmin();
    if (!isSuper) throw Exception('admin_only_action');

    await _client.from(_table).update({
      'start_at': startAt.toIso8601String(),
      'end_at': endAt.toIso8601String(),
    }).eq('id', adId);
  }

  // Admin: delete ad and remove storage file
  static Future<void> deleteAd(String adId) async {
    final isSuper = await SupabaseService.isCurrentUserSuperAdmin();
    if (!isSuper) throw Exception('admin_only_action');

    final row = await _client
        .from(_table)
        .select('storage_path')
        .eq('id', adId)
        .maybeSingle();

    final storagePath = row != null ? (row['storage_path']?.toString() ?? '') : '';
    if (storagePath.isNotEmpty) {
      await SupabaseStorageHelper.deleteFile(storagePath);
    }

    await _client.from(_table).delete().eq('id', adId);
  }
}
