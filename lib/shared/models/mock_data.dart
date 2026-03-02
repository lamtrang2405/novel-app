import 'novel_model.dart';
import 'user_model.dart';

class MockData {
  MockData._();

  static List<Chapter> _buildChapters(String novelId, int count) {
    return List.generate(count, (i) {
      final num = i + 1;
      final isFree = num <= 5;
      return Chapter(
        id: '${novelId}_ch_$num',
        novelId: novelId,
        number: num,
        title: _chapterTitles[i % _chapterTitles.length],
        content: _sampleChapterContent(num),
        isFree: isFree,
        coinCost: isFree ? 0 : 2,
        wordCount: 1200 + (num * 50) % 800,
        audioDuration: Duration(minutes: 8 + (num % 6), seconds: (num * 13) % 60),
      );
    });
  }

  static const List<String> _chapterTitles = [
    'The Stranger at the Door',
    'A Deal with the Devil',
    'Secrets in the Dark',
    'When Hearts Collide',
    'The Masquerade Ball',
    'Forbidden Temptation',
    'A Kiss in the Rain',
    'His Possessive Touch',
    'Shattered Walls',
    'The Morning After',
    'Dangerous Desires',
    'When She Finally Saw Him',
    'The Price of Love',
    'Midnight Confessions',
    'An Unexpected Proposal',
    'The Truth Revealed',
    'Love or Pride',
    'Chasing the Storm',
    'One Last Chance',
    'Forever Yours',
  ];

  static String _sampleChapterContent(int chapter) {
    return '''The silence between them was a living, breathing thing — thick with everything left unsaid.

Elena stood at the floor-to-ceiling windows of the penthouse, watching the city below pulse and shimmer like a restless heart. She had told herself she wouldn't come here again. She had made that promise a hundred times in the past month, whispered it into her pillow each night like a prayer.

And yet here she was.

"You came back." His voice came from behind her — low, unhurried, carrying that quiet authority she had never been able to ignore. She didn't turn around.

"Don't flatter yourself," she said, even as her pulse betrayed her with its rapid rhythm. "I left my scarf."

A pause. She could hear the soft pad of his footsteps on the marble floor, measured and deliberate, moving closer until she could feel the warmth radiating off him at her back.

"Your scarf," he repeated, and she could hear the ghost of a smile in it.

"Yes." She finally turned, steeling herself against the sight of him — tall, dark-eyed, impossibly composed. Damian Ashford. Her biggest mistake. Possibly the love of her life. "If you could just—"

He held it out. The blue cashmere scarf, draped over one long finger with the lazy grace of a man who always had the upper hand.

Elena reached for it. His hand closed around her wrist.

Not rough. Never rough. That wasn't his way. He held her with careful intention, like something precious he hadn't yet decided whether to keep.

"Stay," he said simply.

And therein lay the problem with Damian Ashford: he never begged. He never manipulated. He simply asked, with that dark quiet certainty, and somehow that was infinitely more dangerous than anything else could have been.

"I shouldn't," she whispered.

"I know," he agreed. "Stay anyway."

The city lights blurred and swam below. Her resolve — carefully rebuilt over thirty-two days — crumbled like sugar in rain.

She stayed.

*

Chapter $chapter brought new complications, new confessions, and one devastating realization she hadn't been prepared for...

The road to love is never straight, and for Elena and Damian, every step forward seemed to come with two steps back into the beautiful, agonizing gravity of what they were to each other.

Could she trust him? Could she trust herself?

The answer, she feared, would change everything.''';
  }

  static final List<Novel> novels = [
    Novel(
      id: 'novel_1',
      title: 'The Billionaire\'s Secret Bride',
      author: 'Victoria Lane',
      coverUrl: 'https://picsum.photos/seed/novel1/400/600',
      synopsis:
          'Elena never expected to wake up married to the most powerful man in New York. Damian Ashford plays by his own rules — and now she\'s caught in his game of desire, secrets, and impossible choices. Can love survive when everything between them began as a lie?',
      genres: [NovelGenre.billionaire, NovelGenre.enemiesToLovers],
      rating: 4.8,
      reviewCount: 12453,
      totalChapters: 120,
      status: NovelStatus.completed,
      chapters: _buildChapters('novel_1', 20),
      isFeatured: true,
      isHot: true,
      viewCount: 2340000,
    ),
    Novel(
      id: 'novel_2',
      title: 'Claimed by the Dark Prince',
      author: 'Scarlett Moore',
      coverUrl: 'https://picsum.photos/seed/novel2/400/600',
      synopsis:
          'He was supposed to be the villain of her story. But when Prince Lucian of the Shadow Court claims Aria as his own, she discovers that darkness has never looked so beautiful — or so dangerous.',
      genres: [NovelGenre.darkRomance, NovelGenre.paranormalRomance],
      rating: 4.9,
      reviewCount: 9821,
      totalChapters: 85,
      status: NovelStatus.ongoing,
      chapters: _buildChapters('novel_2', 20),
      isFeatured: true,
      isHot: true,
      viewCount: 1870000,
    ),
    Novel(
      id: 'novel_3',
      title: 'The CEO\'s Convenient Wife',
      author: 'Jade Sterling',
      coverUrl: 'https://picsum.photos/seed/novel3/400/600',
      synopsis:
          'A contract marriage, a cold CEO, and one undeniable chemistry that refuses to stay professional. Sophie agreed to be Marcus\'s wife on paper — she never agreed to fall for him.',
      genres: [NovelGenre.billionaire, NovelGenre.contemporaryRomance],
      rating: 4.6,
      reviewCount: 8234,
      totalChapters: 95,
      status: NovelStatus.ongoing,
      chapters: _buildChapters('novel_3', 20),
      isNew: true,
      viewCount: 1230000,
    ),
    Novel(
      id: 'novel_4',
      title: 'Sins of the Royal Court',
      author: 'Rosalind Vaux',
      coverUrl: 'https://picsum.photos/seed/novel4/400/600',
      synopsis:
          'Lady Catherine was never meant to catch the king\'s eye. But when royal desire collides with political intrigue, their forbidden love could topple an entire kingdom.',
      genres: [NovelGenre.royalRomance, NovelGenre.forbiddenLove],
      rating: 4.7,
      reviewCount: 6512,
      totalChapters: 110,
      status: NovelStatus.completed,
      chapters: _buildChapters('novel_4', 20),
      isFeatured: true,
      viewCount: 980000,
    ),
    Novel(
      id: 'novel_5',
      title: 'After the Storm',
      author: 'Lily Chen',
      coverUrl: 'https://picsum.photos/seed/novel5/400/600',
      synopsis:
          'Five years after their devastating breakup, Nora never expected to see Jake again — let alone as her new boss. Second chances don\'t come twice. Or do they?',
      genres: [NovelGenre.secondChance, NovelGenre.contemporaryRomance],
      rating: 4.5,
      reviewCount: 5891,
      totalChapters: 70,
      status: NovelStatus.completed,
      chapters: _buildChapters('novel_5', 20),
      isNew: true,
      viewCount: 760000,
    ),
    Novel(
      id: 'novel_6',
      title: 'Midnight with the Mafia King',
      author: 'Aria Dante',
      coverUrl: 'https://picsum.photos/seed/novel6/400/600',
      synopsis:
          'She witnessed something she shouldn\'t have. Now the most dangerous man in the city says she belongs to him — for protection. But protection never felt this intoxicating.',
      genres: [NovelGenre.darkRomance, NovelGenre.forbiddenLove],
      rating: 4.8,
      reviewCount: 11200,
      totalChapters: 130,
      status: NovelStatus.ongoing,
      chapters: _buildChapters('novel_6', 20),
      isHot: true,
      viewCount: 3100000,
    ),
    Novel(
      id: 'novel_7',
      title: 'The Highlander\'s Vow',
      author: 'Fiona MacRae',
      coverUrl: 'https://picsum.photos/seed/novel7/400/600',
      synopsis:
          'Transported to 18th-century Scotland, modern woman Jess finds herself bound to a fierce Highland warrior by an ancient vow neither of them asked for — and a love neither can deny.',
      genres: [NovelGenre.historicalRomance, NovelGenre.paranormalRomance],
      rating: 4.6,
      reviewCount: 4320,
      totalChapters: 88,
      status: NovelStatus.completed,
      chapters: _buildChapters('novel_7', 20),
      viewCount: 620000,
    ),
    Novel(
      id: 'novel_8',
      title: 'Love in the Enemy\'s Arms',
      author: 'Cassandra Wells',
      coverUrl: 'https://picsum.photos/seed/novel8/400/600',
      synopsis:
          'Their families have been rivals for generations. But when a blizzard strands Emma and Ethan in the same mountain cabin for a week, old feuds become the least of their problems.',
      genres: [NovelGenre.enemiesToLovers, NovelGenre.contemporaryRomance],
      rating: 4.4,
      reviewCount: 3987,
      totalChapters: 62,
      status: NovelStatus.completed,
      chapters: _buildChapters('novel_8', 20),
      isNew: true,
      viewCount: 540000,
    ),
  ];

  static List<ReadingProgress> get sampleReadingHistory => [
        ReadingProgress(
          novelId: 'novel_1',
          novelTitle: 'The Billionaire\'s Secret Bride',
          coverUrl: 'https://picsum.photos/seed/novel1/400/600',
          currentChapter: 12,
          totalChapters: 120,
          lastReadAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ReadingProgress(
          novelId: 'novel_6',
          novelTitle: 'Midnight with the Mafia King',
          coverUrl: 'https://picsum.photos/seed/novel6/400/600',
          currentChapter: 7,
          totalChapters: 130,
          lastReadAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ReadingProgress(
          novelId: 'novel_3',
          novelTitle: 'The CEO\'s Convenient Wife',
          coverUrl: 'https://picsum.photos/seed/novel3/400/600',
          currentChapter: 3,
          totalChapters: 95,
          lastReadAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
}
