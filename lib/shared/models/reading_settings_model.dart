enum ReadingMode { light, dark, sepia }

class ReadingSettings {
  final double fontSize;
  final ReadingMode mode;
  final double lineHeight;

  const ReadingSettings({
    this.fontSize = 16.0,
    this.mode = ReadingMode.light,
    this.lineHeight = 1.8,
  });

  ReadingSettings copyWith({
    double? fontSize,
    ReadingMode? mode,
    double? lineHeight,
  }) {
    return ReadingSettings(
      fontSize: fontSize ?? this.fontSize,
      mode: mode ?? this.mode,
      lineHeight: lineHeight ?? this.lineHeight,
    );
  }
}
