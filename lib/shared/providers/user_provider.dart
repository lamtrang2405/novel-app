import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/mock_data.dart';

class UserNotifier extends StateNotifier<UserModel> {
  UserNotifier() : super(UserModel.demo.copyWith(
    readingHistory: MockData.sampleReadingHistory,
  ));

  void addCoins(int amount) {
    state = state.copyWith(coins: state.coins + amount);
  }

  void spendCoins(int amount) {
    if (state.coins >= amount) {
      state = state.copyWith(coins: state.coins - amount);
    }
  }

  /// Spend coins and permanently mark the chapter as unlocked.
  /// Returns true if unlock succeeded.
  bool unlockChapter(String novelId, int chapterIndex, int coinCost) {
    final key = '$novelId:$chapterIndex';
    // Already unlocked — no charge
    if (state.unlockedChapters.contains(key)) return true;
    if (state.coins < coinCost) return false;
    final updated = Set<String>.from(state.unlockedChapters)..add(key);
    state = state.copyWith(
      coins: state.coins - coinCost,
      unlockedChapters: updated,
    );
    return true;
  }

  bool canUnlockChapter(int coinCost) {
    return state.hasActiveSubscription || state.coins >= coinCost;
  }

  void activateSubscription({required Duration duration}) {
    final expiry = DateTime.now().add(duration);
    state = state.copyWith(subscriptionExpiry: expiry);
  }

  void toggleBookmark(String novelId) {
    final bookmarks = List<String>.from(state.bookmarkedNovels);
    if (bookmarks.contains(novelId)) {
      bookmarks.remove(novelId);
    } else {
      bookmarks.add(novelId);
    }
    state = state.copyWith(bookmarkedNovels: bookmarks);
  }

  bool isBookmarked(String novelId) => state.bookmarkedNovels.contains(novelId);

  void updateReadingProgress(ReadingProgress progress) {
    final history = List<ReadingProgress>.from(state.readingHistory);
    final index = history.indexWhere((p) => p.novelId == progress.novelId);
    if (index >= 0) {
      history[index] = progress;
    } else {
      history.insert(0, progress);
    }
    state = state.copyWith(readingHistory: history);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel>(
  (ref) => UserNotifier(),
);

final isBookmarkedProvider = Provider.family<bool, String>((ref, novelId) {
  return ref.watch(userProvider).bookmarkedNovels.contains(novelId);
});
