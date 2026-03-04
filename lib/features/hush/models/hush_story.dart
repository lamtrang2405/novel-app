import 'package:flutter/material.dart';

class HushEpisode {
  final String title;
  final String duration;
  final bool isCurrent;

  const HushEpisode({
    required this.title,
    required this.duration,
    this.isCurrent = false,
  });
}

class HushStory {
  final String id;
  final String title;
  final Gradient background;
  final Gradient playerBackground;
  final String artist;
  final List<String> tags;
  final String meta;
  final String liveCount;
  final String description;
  final List<HushEpisode> episodes;

  const HushStory({
    required this.id,
    required this.title,
    required this.background,
    required this.playerBackground,
    required this.artist,
    required this.tags,
    required this.meta,
    required this.liveCount,
    required this.description,
    required this.episodes,
  });
}

class HushVoice {
  final String initial;
  final String name;
  final String type;
  final String desc;
  final Color ringColor;

  const HushVoice({
    required this.initial,
    required this.name,
    required this.type,
    required this.desc,
    required this.ringColor,
  });
}
