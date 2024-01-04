import 'dart:io';

void main() {
  var filePath = '/Users/bennalls/Developer/Advent of Code/2023/Day 2/input.txt';
  List<String> lines = readLines(filePath);
  List games = [];
  for (String line in lines) {
    games.add(createGameFromString(line));
  }
  // Check each game is valid
  var validGames = [];
  for (var game in games) {
    var valid = true;
    for (var k in game.keys) {
      for (var round in game[k]) {
        if (checkGameValid(round) == false) {
          valid = false;
        }
        ;
      }
    }
    if (valid == true) {
      validGames.add(game);
    }
  }

  // Part 1
  int sum = 0;
  for (var game in validGames) {
    for (int k in game.keys) {
      sum += k;
    }
  }
  print('Part 1: sum of valid games $sum');

  // Part 2

  var part2Sum = 0;
  games.forEach((game) {
    var minCubes = {'blue': 0, 'red': 0, 'green': 0};
    game.values.forEach((rounds) {
      rounds.forEach((round) {
        round.keys.forEach((key) {
          updateMapWithHigherValue(minCubes, key, round[key]);
        });
      });
    });
    part2Sum += multiplyMapValues(minCubes);
  });

  print('Part 2: sum of min Cube multiple $part2Sum');
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

// Create Game object from string input
// Input "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
// Output is map object with game number as key, with value being a list of map objects.
// {1: [{'blue': 3, 'red':4}, {'red': 1, 'green':2, 'blue':6}, {'green':2}]}
Map<int, List<Map<String, int>>> createGameFromString(String input) {
  // Split the input string into a list of parts, part 1 being the game number, following parts being the games
  List<String> parts = input.split(RegExp('[;:]'));
  int gameNum = int.parse(parts[0].split(' ')[1]);
  parts.removeAt(0); // Remove game element from list
  Map<int, List<Map<String, int>>> game = {gameNum: []};

  for (String gameParts in parts) {
    Map<String, int> colorMap = {};
    List<String> colors = gameParts.split(',');
    for (String c in colors) {
      List<String> colorParts = c.split(' ');
      colorMap[colorParts[2]] = int.parse(colorParts[1]); // postion 0 is null
    }
    game[gameNum]?.add(colorMap);
  }

  return game;
}

// Check if Game is Valid
bool checkGameValid(Map<String, int> game) {
  bool result = true;
  Map<String, int> maxColors = {'blue': 14, 'red': 12, 'green': 13};
  for (String k in game.keys) {
    if ((game[k] ?? 0) > (maxColors[k] ?? 0)) {
      result = false;
      break;
    }
  }

  return result;
}

int multiplyMapValues(Map<dynamic, int> map) {
  return map.values.fold(1, (product, value) => product * value);
}

void updateMapWithHigherValue(Map map, var key, var newValue) {
  if (!map.containsKey(key) || map[key] < newValue) {
    map[key] = newValue;
  }
}
