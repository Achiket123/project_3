mixin Strings {
  static const String appName = 'My App';
  static const String homeScreenTitle = 'Home';
  static const String chartsScreenTitle = 'Charts';
  static const String settingsScreenTitle = 'Settings';
  static const String profileScreenTitle = 'Profile';

  static const String homeScreenDescription = 'Welcome to the home screen';
  static const String chartsScreenDescription = 'Welcome to the charts screen';
  static const String settingsScreenDescription =
      'Welcome to the settings screen';
  static const String profileScreenDescription =
      'Welcome to the profile screen';
}

class API {
  static const String baseUrl = 'http://api.api-ninjas.com/v1';
  static const String earningscalltranscripts = '$baseUrl/earningstranscript';
  static const String earningscalendar = '$baseUrl/earningscalendar';
}
