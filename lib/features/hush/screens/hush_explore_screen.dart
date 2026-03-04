import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/hush_colors.dart';
import '../data/hush_data.dart';
import '../models/hush_story.dart';
import '../providers/hush_player_provider.dart';
import '../widgets/hush_story_detail_sheet.dart';

void _openStoryDetail(BuildContext context, WidgetRef ref, HushStory story) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => HushStoryDetailSheet(
      story: story,
      onPlay: () {
        ref.read(hushPlayerProvider.notifier).playStory(story, 0);
        Navigator.pop(ctx);
      },
      onPlayEpisode: (epIndex) {
        ref.read(hushPlayerProvider.notifier).playStory(story, epIndex);
        Navigator.pop(ctx);
      },
    ),
  );
}

class HushExploreScreen extends ConsumerWidget {
  const HushExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: HushColors.bg,
          title: const Text(
            'Explore',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: HushColors.t1,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: HushColors.bgCard,
                border: Border.all(color: HushColors.brd),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, size: 20, color: HushColors.t3),
                  const SizedBox(width: 10),
                  Text(
                    'Browse vibes, voices, tags',
                    style: TextStyle(fontSize: 15, color: HushColors.t3),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Browse Vibes',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: HushColors.t1,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final v = hushExploreVibes[i];
                return Material(
                  color: HushColors.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: HushColors.brd),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(v['emoji']!, style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 4),
                          Text(
                            v['label']!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: HushColors.t1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            v['count']!,
                            style: TextStyle(fontSize: 10, color: HushColors.t2),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: hushExploreVibes.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Voices',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: HushColors.t1,
                  ),
                ),
                Text('See all', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: HushColors.blush)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              itemCount: hushVoices.length,
              itemBuilder: (context, i) {
                final v = hushVoices[i];
                return Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: v.ringColor,
                        child: Text(
                          v.initial,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        v.name.split(' ').first,
                        style: TextStyle(fontSize: 11, color: HushColors.t2),
                      ),
                      Text(
                        v.type,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: HushColors.blush,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Trending Tags',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: HushColors.t1,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: trendingTags.take(9).map((tag) {
                return ActionChip(
                  label: Text(tag, style: TextStyle(fontSize: 12, color: HushColors.t2)),
                  backgroundColor: HushColors.bgCard,
                  side: BorderSide(color: HushColors.brd),
                  onPressed: () {},
                );
              }).toList(),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Top This Week',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: HushColors.t1,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _RankRow(
              rank: 1,
              story: getHushStoryById('neighbor')!,
              meta: '8 Eps • Forbidden',
              onTap: () => _openStoryDetail(context, ref, getHushStoryById('neighbor')!),
            ),
            _RankRow(
              rank: 2,
              story: getHushStoryById('barista')!,
              meta: '6 Eps • Sweet',
              onTap: () => _openStoryDetail(context, ref, getHushStoryById('barista')!),
            ),
            _RankRow(
              rank: 3,
              story: getHushStoryById('photographer')!,
              meta: '10 Eps • Art',
              onTap: () => _openStoryDetail(context, ref, getHushStoryById('photographer')!),
            ),
          ]),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  final int rank;
  final HushStory story;
  final String meta;
  final VoidCallback onTap;

  const _RankRow({required this.rank, required this.story, required this.meta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Text(
                '#$rank',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: HushColors.blush,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: story.background,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: HushColors.t1,
                    ),
                  ),
                  Text(
                    meta,
                    style: TextStyle(fontSize: 12, color: HushColors.t2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
