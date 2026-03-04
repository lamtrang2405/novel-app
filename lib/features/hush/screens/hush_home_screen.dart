import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/hush_colors.dart';
import '../data/hush_data.dart';
import '../models/hush_story.dart';
import '../providers/hush_player_provider.dart';
import '../widgets/hush_story_detail_sheet.dart';

class HushHomeScreen extends ConsumerStatefulWidget {
  const HushHomeScreen({super.key});

  @override
  ConsumerState<HushHomeScreen> createState() => _HushHomeScreenState();
}

class _HushHomeScreenState extends ConsumerState<HushHomeScreen> {
  int _vibeIndex = 0;

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final resumeItems = ref.watch(hushResumeItemsProvider);
    final editorPick = getHushStoryById('neighbor')!;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildHeader(context),
        SliverToBoxAdapter(child: _buildGreeting()),
        SliverToBoxAdapter(child: _buildVibePills()),
        SliverToBoxAdapter(child: _buildEditorialHero(context, editorPick)),
        SliverToBoxAdapter(
          child: _sectionHeader('Pick up where you left', 'See all'),
        ),
        SliverToBoxAdapter(
          child: _buildResumeRow(context, resumeItems),
        ),
        SliverToBoxAdapter(
          child: _sectionHeader('Trending', 'See all'),
        ),
        SliverToBoxAdapter(
          child: _buildTrendingRow(context),
        ),
        SliverToBoxAdapter(
          child: _sectionHeader('For You', 'See all'),
        ),
        SliverToBoxAdapter(
          child: _buildForYouGrid(context),
        ),
        SliverToBoxAdapter(
          child: _sectionHeader('Popular Voices', 'See all'),
        ),
        SliverToBoxAdapter(
          child: _buildVoiceList(context),
        ),
        SliverToBoxAdapter(
          child: _sectionHeader('Wind Down', 'See all'),
        ),
        SliverToBoxAdapter(
          child: _buildWindDownRow(context),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: HushColors.bg,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: HushColors.grad,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text(
              'h',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ShaderMask(
            shaderCallback: (b) => HushColors.grad.createShader(b),
            child: const Text(
              'hush',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic,
                letterSpacing: -0.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: HushColors.t2, size: 22),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: HushColors.grad.colors.first,
            child: const Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _greeting(),
            style: TextStyle(fontSize: 12, color: HushColors.t2),
          ),
          const Text(
            'Sofia',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: HushColors.t1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVibePills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(
        children: List.generate(hushVibes.length, (i) {
          final active = _vibeIndex == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: active ? HushColors.blush : HushColors.bgCard,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                onTap: () => setState(() => _vibeIndex = i),
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: active ? HushColors.blush : HushColors.brd,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    hushVibes[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : HushColors.t2,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEditorialHero(BuildContext context, HushStory story) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: GestureDetector(
        onTap: () => _openStoryDetail(context, story),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: story.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: HushColors.emerald,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        story.liveCount,
                        style: TextStyle(fontSize: 11, color: HushColors.t2),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: HushColors.blush,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        "EDITOR'S PICK",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      story.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Thin walls. Thick tension. 8 episodes of forbidden proximity.',
                      style: TextStyle(fontSize: 12, color: HushColors.t2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: HushColors.blush,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Start Listening',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: HushColors.t1,
            ),
          ),
          Text(
            action,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: HushColors.blush,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeRow(BuildContext context, List<HushResumeItem> items) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          final ep = item.story.episodes[item.episodeIndex];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _openStoryDetail(context, item.story),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: HushColors.bgCard,
                  border: Border.all(color: HushColors.brd),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: item.story.background,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 35,
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: HushColors.grad,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const Expanded(flex: 65, child: SizedBox(height: 3)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.story.title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: HushColors.t1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Ep ${item.episodeIndex + 1} • ${ep.duration} left',
                            style: TextStyle(fontSize: 11, color: HushColors.t2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingRow(BuildContext context) {
    final trending = [
      getHushStoryById('neighbor')!,
      getHushStoryById('photographer')!,
      getHushStoryById('professor')!,
      getHushStoryById('dancer')!,
      getHushStoryById('barista')!,
    ];
    const badges = ['Hot', 'VIP', '', 'New', ''];
    const times = ['3h 28m', '4h 12m', '3h 50m', '2h 40m', '2h 15m'];
    const counts = ['6.2K', '4.8K', '3.5K', '2.1K', '5.4K'];

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: trending.length,
        itemBuilder: (context, i) {
          final s = trending[i];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => _openStoryDetail(context, s),
              child: SizedBox(
                width: 148,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 148,
                          height: 208,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: s.background,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        if (badges[i].isNotEmpty)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                badges[i],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: badges[i] == 'Hot' ? HushColors.blush : HushColors.violet,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Text(
                            times[i],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.65),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: HushColors.t1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      s.tags.take(2).join(' • '),
                      style: TextStyle(fontSize: 11, color: HushColors.t2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      counts[i],
                      style: TextStyle(fontSize: 10, color: HushColors.t2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForYouGrid(BuildContext context) {
    final forYou = [
      getHushStoryById('lifeguard')!,
      getHushStoryById('chef')!,
      getHushStoryById('penpal')!,
    ];
    const labels = ['Recommended', 'Sensual', 'Letters'];
    const subLabels = ['Lifeguard Summer', 'Private Chef', 'Dear Pen Pal'];
    const metas = ['6 Eps • Beach • Playful', 'Sensual • Cooking', 'Letters • Longing'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        children: List.generate(3, (i) {
          final s = forYou[i];
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
              child: GestureDetector(
                onTap: () => _openStoryDetail(context, s),
                child: Container(
                  height: 115,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: s.background,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        labels[i],
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: HushColors.blush,
                        ),
                      ),
                      Text(
                        subLabels[i],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        metas[i],
                        style: TextStyle(fontSize: 11, color: HushColors.t2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVoiceList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        children: hushVoices.take(3).map((v) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: HushColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: HushColors.brd),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 21,
                        backgroundColor: v.ringColor,
                        child: Text(
                          v.initial,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              v.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: HushColors.t1,
                              ),
                            ),
                            Text(
                              '${v.type} • ${v.desc}',
                              style: TextStyle(fontSize: 12, color: HushColors.t2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWindDownRow(BuildContext context) {
    final windDown = [
      (getHushStoryById('whisper-rain')!, '🌙', 'Whisper & Rain', 'ASMR • Sleep'),
      (getHushStoryById('goodnight')!, '💖', 'Goodnight, Love', 'Comfort • Gentle'),
      (getHushStoryById('cabin-night')!, '🏝️', 'Cabin Nights', 'Fireplace • Cozy'),
    ];

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: windDown.length,
        itemBuilder: (context, i) {
          final (story, emoji, name, tag) = windDown[i];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => _openStoryDetail(context, story),
              child: SizedBox(
                width: 148,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 148,
                      height: 148,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: story.background,
                      ),
                      alignment: Alignment.center,
                      child: Text(emoji, style: const TextStyle(fontSize: 48)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: HushColors.t1,
                      ),
                    ),
                    Text(
                      tag,
                      style: TextStyle(fontSize: 11, color: HushColors.t2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openStoryDetail(BuildContext context, HushStory story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HushStoryDetailSheet(
        story: story,
        onPlay: () {
          ref.read(hushPlayerProvider.notifier).playStory(story, 0);
          Navigator.of(ctx).pop();
        },
        onPlayEpisode: (epIndex) {
          ref.read(hushPlayerProvider.notifier).playStory(story, epIndex);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }
}
