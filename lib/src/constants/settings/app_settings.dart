enum AppMode {
  debug,
  profile,
  release,
}

class AppSettings {
  static final AppMode appMode = AppMode.values.firstWhere(
    (element) => element.name == const String.fromEnvironment("app_mode"),
  );

  static const String apiKey = String.fromEnvironment("api_key");
  static const String appName = String.fromEnvironment("app_name");
}
