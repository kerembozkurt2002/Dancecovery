import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'role_reveal_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Setup'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Container(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Players',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${gameState.players.length}/12',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: gameState.players.isEmpty
                          ? Center(
                              child: Text(
                                'Add players to start the game',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurface.withOpacity(0.6),
                                    ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: gameState.players.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: colorScheme.primaryContainer,
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      gameState.players[index].name,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: gameState.players.length > 3
                                          ? () => gameState.removePlayer(index)
                                          : null,
                                      color: gameState.players.length > 3
                                          ? colorScheme.error
                                          : colorScheme.error.withOpacity(0.3),
                                      tooltip: gameState.players.length <= 3
                                          ? 'Cannot remove player: minimum 3 players required'
                                          : 'Remove player',
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Player Name',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              textCapitalization: TextCapitalization.words,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (_nameController.text.isNotEmpty) {
                                        gameState.addPlayer(_nameController.text);
                                        _nameController.clear();
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Player'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: gameState.players.length >= 3
                                        ? () {
                                            gameState.startGame();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const RoleRevealScreen(),
                                              ),
                                            );
                                          }
                                        : null,
                                    icon: const Icon(Icons.play_arrow),
                                    label: const Text('Start Game'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
} 