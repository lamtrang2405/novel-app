import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/novel_model.dart';
import '../models/mock_data.dart';

/// Demo novels (loaded in main via MockData.ensureDemoDataLoaded()). Defensive copy; never empty.
final novelsProvider = Provider<List<Novel>>((ref) {
  final list = List<Novel>.from(MockData.novels);
  return list;
});

final featuredNovelsProvider = Provider<List<Novel>>(
  (ref) => ref.watch(novelsProvider).where((n) => n.isFeatured).toList(),
);

final hotNovelsProvider = Provider<List<Novel>>(
  (ref) => ref.watch(novelsProvider).where((n) => n.isHot).toList(),
);

final newNovelsProvider = Provider<List<Novel>>(
  (ref) => ref.watch(novelsProvider).where((n) => n.isNew).toList(),
);

final novelByIdProvider = Provider.family<Novel?, String>((ref, id) {
  final novels = ref.watch(novelsProvider);
  try {
    return novels.firstWhere((n) => n.id == id);
  } catch (_) {
    return null;
  }
});

final novelsByGenreProvider = Provider.family<List<Novel>, NovelGenre>(
  (ref, genre) => ref
      .watch(novelsProvider)
      .where((n) => n.genres.contains(genre))
      .toList(),
);

// Search
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<Novel>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  if (query.isEmpty) return [];
  final novels = ref.watch(novelsProvider);
  return novels
      .where((n) =>
          n.title.toLowerCase().contains(query) ||
          n.author.toLowerCase().contains(query) ||
          n.genres.any((g) => g.label.toLowerCase().contains(query)))
      .toList();
});

// Selected genre filter
final selectedGenreProvider = StateProvider<NovelGenre?>((ref) => null);

final filteredNovelsProvider = Provider<List<Novel>>((ref) {
  final genre = ref.watch(selectedGenreProvider);
  final novels = ref.watch(novelsProvider);
  if (genre == null) return novels;
  return novels.where((n) => n.genres.contains(genre)).toList();
});
