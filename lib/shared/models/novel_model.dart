enum NovelStatus { ongoing, completed, hiatus }

enum NovelGenre {
  darkRomance,
  billionaire,
  enemiesToLovers,
  royalRomance,
  secondChance,
  forbiddenLove,
  paranormalRomance,
  contemporaryRomance,
  historicalRomance,
}

extension NovelGenreLabel on NovelGenre {
  String get label {
    switch (this) {
      case NovelGenre.darkRomance: return 'Dark Romance';
      case NovelGenre.billionaire: return 'Billionaire';
      case NovelGenre.enemiesToLovers: return 'Enemies to Lovers';
      case NovelGenre.royalRomance: return 'Royal Romance';
      case NovelGenre.secondChance: return 'Second Chance';
      case NovelGenre.forbiddenLove: return 'Forbidden Love';
      case NovelGenre.paranormalRomance: return 'Paranormal';
      case NovelGenre.contemporaryRomance: return 'Contemporary';
      case NovelGenre.historicalRomance: return 'Historical';
    }
  }
}

class Novel {
  final String id;
  final String title;
  final String author;
  final String coverUrl;
  final String synopsis;
  final List<NovelGenre> genres;
  final double rating;
  final int reviewCount;
  final int totalChapters;
  final NovelStatus status;
  final List<Chapter> chapters;
  final bool isFeatured;
  final bool isHot;
  final bool isNew;
  final int viewCount;
  final String? audioSampleUrl;

  const Novel({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.synopsis,
    required this.genres,
    required this.rating,
    required this.reviewCount,
    required this.totalChapters,
    required this.status,
    this.chapters = const [],
    this.isFeatured = false,
    this.isHot = false,
    this.isNew = false,
    this.viewCount = 0,
    this.audioSampleUrl,
  });

  String get authorName => author;
  bool get hasAudio => audioSampleUrl != null || chapters.any((c) => c.audioUrl != null);

  String get genreLabel => genres.isNotEmpty ? genres.first.label : '';

  String get statusLabel {
    switch (status) {
      case NovelStatus.ongoing: return 'Ongoing';
      case NovelStatus.completed: return 'Completed';
      case NovelStatus.hiatus: return 'On Hiatus';
    }
  }

  String get viewCountLabel {
    if (viewCount >= 1000000) return '${(viewCount / 1000000).toStringAsFixed(1)}M';
    if (viewCount >= 1000) return '${(viewCount / 1000).toStringAsFixed(1)}K';
    return viewCount.toString();
  }
}

class Chapter {
  final String id;
  final String novelId;
  final int number;
  final String title;
  final String content;
  final String? audioUrl;
  final int coinCost;
  final bool isFree;
  final int wordCount;
  final Duration? audioDuration;

  const Chapter({
    required this.id,
    required this.novelId,
    required this.number,
    required this.title,
    required this.content,
    this.audioUrl,
    this.coinCost = 2,
    this.isFree = false,
    this.wordCount = 0,
    this.audioDuration,
  });

  String get durationLabel {
    if (audioDuration == null) return '';
    final m = audioDuration!.inMinutes;
    final s = audioDuration!.inSeconds % 60;
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  int get readingMinutes => (wordCount / 200).ceil();
}
