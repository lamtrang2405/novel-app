import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/hush_colors.dart';
import '../data/hush_data.dart';
import '../models/hush_story.dart';
import '../providers/hush_player_provider.dart';
import '../widgets/hush_story_detail_sheet.dart';

class HushLibraryScreen extends ConsumerStatefulWidget {
  const HushLibraryScreen({super.key});

  @override
  ConsumerState<HushLibraryScreen> createState() => _HushLibraryScreenState();
}

class _HushLibraryScreenState extends ConsumerState<HushLibraryScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: HushColors.bg,
          title: const Text(
            'Library',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: HushColors.t1,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: HushColors.bgCard,
                border: Border.all(color: HushColors.brd),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: ['Saved', 'Downloaded', 'History'].asMap().entries.map((e) {
                  final active = _tabIndex == e.key;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tabIndex = e.key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: active ? HushColors.blush : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          e.value,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                            color: active ? Colors.white : HushColors.t2,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _tabIndex == 0
              ? _buildSavedList(context)
              : _tabIndex == 1
                  ? _buildDownloadedList(context)
                  : _buildHistoryList(context),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildSavedList(BuildContext context) {
    final saved = [
      getHushStoryById('neighbor')!,
      getHushStoryById('photographer')!,
      getHushStoryById('professor')!,
      getHushStoryById('barista')!,
    ];
    const progress = [0.35, 0.0, 0.0, 1.0];
    const meta = ['8 Eps • Ep 3', '10 Eps • Art', '9 Eps • Professor', '6 Eps • Complete'];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      itemCount: saved.length,
      separatorBuilder: (_, _) => Divider(height: 1, color: HushColors.brd),
      itemBuilder: (context, i) {
        final s = saved[i];
        return _LibraryRow(
          story: s,
          meta: meta[i],
          progress: progress[i],
          showDownloadBadge: false,
          onTap: () => _openDetail(context, s),
        );
      },
    );
  }

  Widget _buildDownloadedList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The Neighbor Upstairs Eps 1-3 • 38 MB',
            style: TextStyle(fontSize: 13, color: HushColors.t2),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The Barista — Finished today',
            style: TextStyle(fontSize: 13, color: HushColors.t2),
          ),
          const SizedBox(height: 8),
          Text(
            'The Neighbor Upstairs Ep 3 • Yesterday',
            style: TextStyle(fontSize: 13, color: HushColors.t2),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, HushStory story) {
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
}

class _LibraryRow extends StatelessWidget {
  final HushStory story;
  final String meta;
  final double progress;
  final bool showDownloadBadge;
  final VoidCallback onTap;

  const _LibraryRow({
    required this.story,
    required this.meta,
    required this.progress,
    this.showDownloadBadge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: story.background,
                  ),
                ),
                if (showDownloadBadge)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: HushColors.blush,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, size: 10, color: Colors.white),
                    ),
                  ),
              ],
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    meta,
                    style: TextStyle(fontSize: 12, color: HushColors.t2),
                  ),
                  if (progress > 0 && progress < 1) ...[
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: HushColors.brd,
                        valueColor: const AlwaysStoppedAnimation<Color>(HushColors.blush),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.more_horiz, size: 20, color: HushColors.t3),
          ],
        ),
      ),
    );
  }
}
