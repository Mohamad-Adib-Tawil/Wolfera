import 'package:wolfera/services/supabase_service.dart';
import 'package:wolfera/core/initialization.dart';
import 'package:wolfera/core/models/localization_config.dart';
import 'package:wolfera/features/app/presentation/pages/app.dart';

void main() async {
  // Initialize Supabase first
  await SupabaseService.initialize();
  
  await initialization(
    () => const App(),
    localizationConfig: LocalizationConfig.defaultConfig,
  );
}
