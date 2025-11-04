import 'package:wolfera/services/supabase_service.dart';
import 'package:wolfera/services/push_messaging_service.dart';

class AppService {
  static AppService? _instance;
  static bool _initialized = false;

  AppService._internal();

  static AppService get instance {
    _instance ??= AppService._internal();
    return _instance!;
  }

  static Future<void> initializeApp() async {
    if (_initialized) return;
    await SupabaseService.initialize();
    await PushMessagingService.initialize();
    _initialized = true;
  }

  // Notification methods can be implemented with local notifications
  static Future<void> requestPermission() async {
    // Implementation for local notifications permission
  }

  static Future<void> subscribeToTopic(String topic) async {
    // Implementation for topic subscription if needed
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    // Implementation for topic unsubscription if needed
  }
}
