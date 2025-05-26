import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'game_round_screen.dart';

class RoleRevealScreen extends StatefulWidget {
  const RoleRevealScreen({super.key});

  @override
  State<RoleRevealScreen> createState() => _RoleRevealScreenState();
}

class _RoleRevealScreenState extends State<RoleRevealScreen> with SingleTickerProviderStateMixin {
  int currentPlayerIndex = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<GameState>(
      builder: (context, gameState, child) {
        if (currentPlayerIndex >= gameState.players.length) {
          return const GameRoundScreen();
        }

        final player = gameState.players[currentPlayerIndex];
        final isUndercover = player.role == 'Undercover';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Role Reveal'),
            backgroundColor: colorScheme.primaryContainer,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: isUndercover
                                      ? colorScheme.errorContainer
                                      : colorScheme.primaryContainer,
                                  child: Icon(
                                    isUndercover ? Icons.visibility_off : Icons.visibility,
                                    size: 40,
                                    color: isUndercover
                                        ? colorScheme.onErrorContainer
                                        : colorScheme.onPrimaryContainer,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  player.name,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  'Your Role:',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isUndercover
                                        ? colorScheme.errorContainer
                                        : colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    player.role!,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: isUndercover
                                              ? colorScheme.onErrorContainer
                                              : colorScheme.onPrimaryContainer,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  'Your Word:',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    player.word!,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: colorScheme.onSecondaryContainer,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          currentPlayerIndex++;
                          _controller.reset();
                          _controller.forward();
                        });
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next Player'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 