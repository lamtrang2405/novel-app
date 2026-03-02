class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int coins;
  final DateTime? subscriptionExpiry;
  final List<String> bookmarkedNovels;
  final List<ReadingProgress> readingHistory;
  final int totalChaptersRead;
  final int totalReadingMinutes;
  // Set of "novelId:chapterIndex" keys for coin-unlocked chapters
  final Set<String> unlockedChapters;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.coins = 0,
    this.subscriptionExpiry,
    this.bookmarkedNovels = const [],
    this.readingHistory = const [],
    this.totalChaptersRead = 0,
    this.totalReadingMinutes = 0,
    this.unlockedChapters = const {},
  });

  bool get hasActiveSubscription {
    if (subscriptionExpiry == null) return false;
    return subscriptionExpiry!.isAfter(DateTime.now());
  }

  bool hasUnlockedChapter(String novelId, int chapterIndex) {
    return unlockedChapters.contains('$novelId:$chapterIndex');
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    int? coins,
    DateTime? subscriptionExpiry,
    List<String>? bookmarkedNovels,
    List<ReadingProgress>? readingHistory,
    int? totalChaptersRead,
    int? totalReadingMinutes,
    Set<String>? unlockedChapters,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coins: coins ?? this.coins,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      bookmarkedNovels: bookmarkedNovels ?? this.bookmarkedNovels,
      readingHistory: readingHistory ?? this.readingHistory,
      totalChaptersRead: totalChaptersRead ?? this.totalChaptersRead,
      totalReadingMinutes: totalReadingMinutes ?? this.totalReadingMinutes,
      unlockedChapters: unlockedChapters ?? this.unlockedChapters,
    );
  }

  static const UserModel guest = UserModel(
    id: 'guest',
    name: 'Guest Reader',
    email: '',
    coins: 20,
  );

  static const UserModel demo = UserModel(
    id: 'demo_user',
    name: 'Sophia Rose',
    email: 'sophia@example.com',
    coins: 150,
    totalChaptersRead: 234,
    totalReadingMinutes: 4320,
    bookmarkedNovels: ['novel_1', 'novel_3', 'novel_5'],
  );
}

class ReadingProgress {
  final String novelId;
  final String novelTitle;
  final String coverUrl;
  final int currentChapter;
  final int totalChapters;
  final DateTime lastReadAt;
  final double scrollPosition;

  const ReadingProgress({
    required this.novelId,
    required this.novelTitle,
    required this.coverUrl,
    required this.currentChapter,
    required this.totalChapters,
    required this.lastReadAt,
    this.scrollPosition = 0.0,
  });

  double get progressPercent =>
      totalChapters > 0 ? currentChapter / totalChapters : 0.0;
}
