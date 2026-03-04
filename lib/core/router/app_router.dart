import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/hush/screens/hush_shell.dart';
import '../../features/hush/screens/hush_home_screen.dart';
import '../../features/hush/screens/hush_explore_screen.dart';
import '../../features/hush/screens/hush_library_screen.dart';
import '../../features/hush/screens/hush_profile_screen.dart';
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
  redirect: (context, state) {
    // On web, always start at splash so users see full app flow (not reader directly)
    if (kIsWeb && state.matchedLocation.contains('/chapter/')) {
      return '/';
    }
    return null;
  },
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
      builder: (context, state, child) => HushShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HushHomeScreen(),
        ),
        GoRoute(
          path: '/discover',
          builder: (context, state) => const HushExploreScreen(),
        ),
        GoRoute(
          path: '/library',
          builder: (context, state) => const HushLibraryScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const HushProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/novel/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return NovelDetailScreen(novelId: id);
      },
    ),
    GoRoute(
      path: '/novel/:id/chapter/:chapterIndex',
      builder: (context, state) {
        final novelId = state.pathParameters['id']!;
        final chapterIndex =
            int.tryParse(state.pathParameters['chapterIndex']!) ?? 0;
        return ChapterReaderScreen(
            novelId: novelId, chapterIndex: chapterIndex);
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
