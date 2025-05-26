import 'package:flutter/foundation.dart';
import 'player.dart';
import 'word_pair.dart';

class GameState extends ChangeNotifier {
  List<Player> players = [];
  int currentPlayerIndex = 0;
  bool isGameStarted = false;
  bool isGameOver = false;
  String? winner;
  WordPair? currentWordPair;
  Set<int> votedPlayers = {};

  final List<WordPair> wordPairs = [
    WordPair(citizenWord: 'Cat', undercoverWord: 'Tiger'),
    WordPair(citizenWord: 'Coffee', undercoverWord: 'Tea'),
    WordPair(citizenWord: 'Ship', undercoverWord: 'Boat'),
    WordPair(citizenWord: 'Pizza', undercoverWord: 'Burger'),
    WordPair(citizenWord: 'Dog', undercoverWord: 'Wolf'),
    WordPair(citizenWord: 'Car', undercoverWord: 'Truck'),
    WordPair(citizenWord: 'Book', undercoverWord: 'Magazine'),
    WordPair(citizenWord: 'Movie', undercoverWord: 'TV Show'),
  ];

  void addPlayer(String name) {
    if (players.length < 12) {
      players.add(Player(name: name));
      notifyListeners();
    }
  }

  void removePlayer(int index) {
    if (players.length > 3) {
      players.removeAt(index);
      notifyListeners();
    }
  }

  void startGame() {
    if (players.length >= 3 && players.length <= 12) {
      currentWordPair = wordPairs[DateTime.now().millisecondsSinceEpoch % wordPairs.length];
      
      final random = DateTime.now().millisecondsSinceEpoch;
      final undercoverIndex = random % players.length;
      
      for (int i = 0; i < players.length; i++) {
        players[i].role = i == undercoverIndex ? 'Undercover' : 'Citizen';
        players[i].word = i == undercoverIndex 
            ? currentWordPair!.undercoverWord 
            : currentWordPair!.citizenWord;
      }
      
      isGameStarted = true;
      votedPlayers.clear();
      notifyListeners();
    }
  }

  bool hasPlayerVoted(int playerIndex) {
    return votedPlayers.contains(playerIndex);
  }

  void vote(int voterIndex, int targetIndex) {
    if (!hasPlayerVoted(voterIndex)) {
      players[targetIndex].votes++;
      votedPlayers.add(voterIndex);
      notifyListeners();
    }
  }

  bool canEliminatePlayer() {
    return votedPlayers.length == players.length;
  }

  void eliminatePlayer() {
    if (!canEliminatePlayer()) return;

    int maxVotes = 0;
    List<int> playersToEliminate = [];
    
    for (int i = 0; i < players.length; i++) {
      if (players[i].votes > maxVotes) {
        maxVotes = players[i].votes;
        playersToEliminate = [i];
      } else if (players[i].votes == maxVotes) {
        playersToEliminate.add(i);
      }
    }
    
    if (playersToEliminate.length > 1) {
      for (var player in players) {
        player.votes = 0;
      }
      votedPlayers.clear();
      notifyListeners();
      return;
    }
    
    int playerToEliminate = playersToEliminate[0];
    if (players[playerToEliminate].role == 'Undercover') {
      winner = 'Citizens';
      isGameOver = true;
    } else {
      players.removeAt(playerToEliminate);
      if (players.length <= 2) {
        winner = 'Undercover';
        isGameOver = true;
      }
    }
    
    for (var player in players) {
      player.votes = 0;
    }
    votedPlayers.clear();
    
    notifyListeners();
  }

  void resetGame() {
    players.clear();
    currentPlayerIndex = 0;
    isGameStarted = false;
    isGameOver = false;
    winner = null;
    currentWordPair = null;
    votedPlayers.clear();
    notifyListeners();
  }
}