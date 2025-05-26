import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/player_setup_screen.dart';
import 'models/game_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        title: 'Undercover Game',
        theme: AppTheme.lightTheme,
        home: const PlayerSetupScreen(),
      ),
    );
  }
} 