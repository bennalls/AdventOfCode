import 'dart:io';
import 'dart:math';

void main() {
  var filePath = '/Users/bennalls/Developer/Advent of Code/2023/Day 6/input.txt';
  List<String> lines = readLines(filePath);

  // There are exactly two lines: first for time and second for distance
  List<String> times = lines[0].split(RegExp(r'\s+')).where((s) => s.isNotEmpty).skip(1).toList();
  List<String> distances = lines[1].split(RegExp(r'\s+')).where((s) => s.isNotEmpty).skip(1).toList();

  // Combine times and distances into a list of maps
  List<Map<String, int>> rounds = [];
  for (int i = 0; i < times.length; i++) {
    rounds.add({'time': int.parse(times[i]), 'distance': int.parse(distances[i])});
  }
  List<List<int>> allRoundSims = [];
  print(rounds);
  for (int round = 0; round < rounds.length; round++) {
    int gameTime = rounds[round]['time'] ?? 0;
    List<int> roundSims = [];
    // run simulations and add to roundSims
    for (int chargeTime = 0; chargeTime < gameTime; chargeTime++) {
      roundSims.add(runSimulation(chargeTime, gameTime));
    }
    allRoundSims.add(roundSims);
  }
  print(allRoundSims);

  // Part 1
  List<int> numWinsInGame = [];
  for (int i = 0; i < rounds.length; i++) {
    numWinsInGame.add(allRoundSims[i].fold(
      0,
      (previousValue, score) {
        if (score > rounds[i]['distance']!) {
          return previousValue + 1;
        } else {
          return previousValue;
        }
      },
    ));
  }
  print('Part 1: ${numWinsInGame.fold<int>(1, (previousVal, numWins) => previousVal * numWins)}');
}

// Part 2

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

int runSimulation(int chargeTime, int gameTime) {
  int velocity = chargeTime;
  int movingTime = gameTime - chargeTime;
  return velocity * movingTime;
}
