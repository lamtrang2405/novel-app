import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reading_settings_model.dart';

class ReadingSettingsNotifier extends StateNotifier<ReadingSettings> {
  ReadingSettingsNotifier() : super(const ReadingSettings());

  void setFontSize(double size) {
    state = state.copyWith(fontSize: size.clamp(12.0, 24.0));
  }

  void increaseFontSize() => setFontSize(state.fontSize + 1);
  void decreaseFontSize() => setFontSize(state.fontSize - 1);

  void setMode(ReadingMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setLineHeight(double height) {
    state = state.copyWith(lineHeight: height.clamp(1.4, 2.2));
  }
}

final readingSettingsProvider =
    StateNotifierProvider<ReadingSettingsNotifier, ReadingSettings>(
  (ref) => ReadingSettingsNotifier(),
);
