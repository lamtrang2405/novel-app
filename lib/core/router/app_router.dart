import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/home/main_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/discover/discover_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/novel_detail/novel_detail_screen.dart';
import '../../features/chapter_reader/chapter_reader_screen.dart';
import '../../features/audio_player/audio_player_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/subscription/subscription_screen.dart';
import '../../features/auth/auth_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/discover',
          builder: (context, state) => const DiscoverScreen(),
        ),
        GoRoute(
          path: '/library',
          builder: (context, state) => const LibraryScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/novel/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return NovelDetailScreen(novelId: id);
      },
    ),
    GoRoute(
      path: '/novel/:id/chapter/:chapterIndex',
      builder: (context, state) {
        final novelId = state.pathParameters['id'] ?? '';
        final chapterIndexStr = state.pathParameters['chapterIndex'] ?? '0';
        final chapterIndex = int.tryParse(chapterIndexStr) ?? 0;
        return ChapterReaderScreen(
          novelId: novelId,
          chapterIndex: chapterIndex.clamp(0, 999),
        );
      },
    ),
    GoRoute(
      path: '/audio-player',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AudioPlayerScreen(),
    ),
    GoRoute(
      path: '/wallet',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const WalletScreen(),
    ),
    GoRoute(
      path: '/subscription',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SubscriptionScreen(),
    ),
  ],
);
