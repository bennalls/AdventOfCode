import 'dart:io';
import 'dart:math';

void main() {
  var filePath = '/Users/bennalls/Developer/Advent of Code/2023/Day 4/input.txt';
  List<String> lines = readLines(filePath);
  print(lines);
  var games = lines.map(parseBingoCard).toList();

  // Part 1
  int score = 0;
  for (var game in games) {
    score += game.winningNums.length == 0 ? 0 : pow(2, game.winningNums.length - 1).toInt();
    print('game: ${game.cardNum}');
    print('winningLen ${game.winningNums.length}');
    print(game);
    print(score);
  }
  print('Part 1: Score is $score');

  // Part 2
  List<BingoCard> discardedGames = [];
  List<BingoCard> unplayedGames = List<BingoCard>.from(games);

  do {
    var game = unplayedGames.removeLast();
    discardedGames.add(game);
    var i = 0;
    for (var win in game.winningNums) {
      unplayedGames.add(games[game.cardNum + i]);
      i++;
    }
  } while (unplayedGames.length > 0);

  print('Part 2: ${discardedGames.length}');
}

// Read input file into list of string lines
List<String> readLines(String filePath) {
  var file = File(filePath);

  // Check if file exists
  if (file.existsSync()) {
    return file.readAsLinesSync();
  } else {
    print('File not found: $filePath');
    return [];
  }
}

class BingoCard {
  int cardNum;
  List<int> numsDrawn;
  List<int> numsSelected;
  List<int> winningNums = [];

  BingoCard({required this.cardNum, required this.numsDrawn, required this.numsSelected}) {
    _calculateWinningNumbers();
  }

  void _calculateWinningNumbers() {
    // Convert both lists to sets
    final setDrawn = numsDrawn.toSet();
    final setSelected = numsSelected.toSet();

    // Find the intersection of both sets (winning numbers)
    winningNums = setDrawn.intersection(setSelected).toList();
  }

  @override
  String toString() {
    return 'BingoCard(CardNum: $cardNum, NumsDrawn: $numsDrawn, NumsSelected: $numsSelected, winningNums: $winningNums)';
  }
}

BingoCard parseBingoCard(String cardString) {
  // Splitting the string into two parts: before and after the '|'
  var parts = cardString.split('|');
  var firstPart = parts[0].trim();
  var secondPart = parts[1].trim();

  // Extracting the card number and the numbers drawn
  var cardNumString = firstPart.split(':')[0].trim();
  var numsDrawnString = firstPart.split(':')[1].trim();

  // Converting card number and numbers drawn to integers
  int cardNum = int.parse(cardNumString.split(RegExp(r'\s+'))[1]);
  List<int> numsDrawn = numsDrawnString.split(RegExp(r'\s+')).map(int.parse).toList();

  // Converting numbers selected to integers
  List<int> numsSelected = secondPart.split(RegExp(r'\s+')).map(int.parse).toList();

  return BingoCard(cardNum: cardNum, numsDrawn: numsDrawn, numsSelected: numsSelected);
}
