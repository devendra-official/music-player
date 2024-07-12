# music

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Cloudinary API `/music/lib/core/secrets/api_key.dart` 

```dart
class CloudinaryKey {
  static const String _apiKey = "API KEY";
  static const String _apiSecret = "API SECRET";
  static const String _cloudName = "CLOUD NAME";

  static String get apiKey => _apiKey;
  static String get apiSecret => _apiSecret;
  static String get cloudName => _cloudName;
}
```
