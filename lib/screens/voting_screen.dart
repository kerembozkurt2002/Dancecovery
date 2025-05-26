import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'player_setup_screen.dart';
import 'game_round_screen.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int? selectedPlayerIndex;
  int currentVoterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        if (gameState.isGameOver) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Game Over!',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${gameState.winner} Win!',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        gameState.resetGame();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlayerSetupScreen(),
                          ),
                        );
                      },
                      child: const Text('Play Again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (currentVoterIndex >= gameState.players.length) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Voting Results'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'All votes are in!',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView.builder(
                      itemCount: gameState.players.length,
                      itemBuilder: (context, index) {
                        final player = gameState.players[index];
                        return Card(
                          child: ListTile(
                            title: Text(player.name),
                            trailing: Text('Votes: ${player.votes}'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      gameState.eliminatePlayer();
                      if (!gameState.isGameOver) {
                        setState(() {
                          currentVoterIndex = 0;
                          selectedPlayerIndex = null;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameRoundScreen(),
                          ),
                        );
                      }
                    },
                    child: const Text('Reveal Results'),
                  ),
                ],
              ),
            ),
          );
        }

        final currentPlayer = gameState.players[currentVoterIndex];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Voting'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${currentPlayer.name}\'s Turn to Vote',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    itemCount: gameState.players.length,
                    itemBuilder: (context, index) {
                      final player = gameState.players[index];
                      return Card(
                        child: ListTile(
                          title: Text(player.name),
                          trailing: Text('Votes: ${player.votes}'),
                          selected: selectedPlayerIndex == index,
                          onTap: () {
                            setState(() {
                              selectedPlayerIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: selectedPlayerIndex != null
                      ? () {
                          gameState.vote(currentVoterIndex, selectedPlayerIndex!);
                          setState(() {
                            currentVoterIndex++;
                            selectedPlayerIndex = null;
                          });
                        }
                      : null,
                  child: const Text('Submit Vote'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 