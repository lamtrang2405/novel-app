import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'shared/models/mock_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Surface errors in debug instead of silent crash
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  runZonedGuarded(() async {
    await _runApp();
  }, (error, stack) {
    debugPrint('Zone error: $error');
    debugPrint(stack?.toString() ?? '');
  });
}

Future<void> _runApp() async {
  // Load demo novel data before app runs so home/novels never have no data
  MockData.ensureDemoDataLoaded();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                details.exceptionAsString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(
    const ProviderScope(
      child: NovelApp(),
    ),
  );
}
