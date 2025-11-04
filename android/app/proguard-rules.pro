# Keep Google Play Services Credentials API classes used by smart_auth
-keep class com.google.android.gms.auth.api.credentials.** { *; }
-keep class com.google.android.gms.common.api.** { *; }
-keep class com.google.android.gms.tasks.** { *; }
-dontwarn com.google.android.gms.**

# Keep the smart_auth plugin classes
-keep class fman.ge.smart_auth.** { *; }

# Keep annotations and kotlin metadata
-keep class kotlin.Metadata { *; }
-keepattributes *Annotation*

# Keep any classes that might be accessed via reflection from method channel
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
