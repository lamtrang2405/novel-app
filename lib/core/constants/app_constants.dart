class AppConstants {
  AppConstants._();

  static const String appName = 'DramaVerse';
  static const String appTagline = 'Your Drama. Your Story.';

  // Coin packages
  static const List<Map<String, dynamic>> coinPackages = [
    {'coins': 60, 'price': '\$0.99', 'bonus': 0, 'tag': ''},
    {'coins': 160, 'price': '\$1.99', 'bonus': 10, 'tag': 'Popular'},
    {'coins': 380, 'price': '\$4.99', 'bonus': 30, 'tag': 'Best Value'},
    {'coins': 800, 'price': '\$9.99', 'bonus': 80, 'tag': ''},
  ];

  // Subscription plans
  static const List<Map<String, dynamic>> subscriptionPlans = [
    {
      'id': 'weekly',
      'name': 'Weekly Pass',
      'price': '\$2.99',
      'period': 'week',
      'description': 'Unlimited chapters for 7 days',
    },
    {
      'id': 'monthly',
      'name': 'Monthly VIP',
      'price': '\$9.99',
      'period': 'month',
      'description': 'Best value — unlimited access + 50 bonus coins/month',
      'tag': 'Most Popular',
    },
  ];

  // Reading settings defaults
  static const double defaultFontSize = 16.0;
  static const double minFontSize = 12.0;
  static const double maxFontSize = 24.0;
  static const String defaultReadingMode = 'light';

  // Audio speeds
  static const List<double> playbackSpeeds = [0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  // Free chapter count per novel (chapters 1..freeChaptersPerNovel free; from freeChaptersPerNovel+1 locked, subscription only)
  static const int freeChaptersPerNovel = 6;
}

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String search = '/search';
  static const String novelDetail = '/novel/:id';
  static const String chapterReader = '/novel/:id/chapter/:chapterId';
  static const String audioPlayer = '/audio-player';
  static const String library = '/library';
  static const String profile = '/profile';
  static const String wallet = '/wallet';
  static const String subscription = '/subscription';
  static const String settings = '/settings';
}
