import 'dart:io';
import 'dart:math';

void main() {
  var filePath = '/Users/bennalls/Developer/Advent of Code/2023/Day 5/input.txt';
  List<String> lines = readLines(filePath);
  // print(lines);
  var mapping = parseInput(lines);
  List<String> mapOrder = [
    'seed-to-soil',
    'soil-to-fertilizer',
    'fertilizer-to-water',
    'water-to-light',
    'light-to-temperature',
    'temperature-to-humidity',
    'humidity-to-location'
  ];

  print(mapping);
  List<int> seeds = RegExp(r'\d+').allMatches(lines[0]).map((match) => int.parse(match.group(0)!)).toList();
  print('Seeds: $seeds');
  // Part 1

  List<List<int>> seedStageLocations = List.generate(mapOrder.length, (_) => []);

  mapOrder.asMap().forEach((key, value) {
    for (int seed in (key == 0 ? seeds : seedStageLocations[key - 1])) {
      int sourceStartVal = seed;
      int destinationVal = seed;
      for (var m in mapping[value]!) {
        destinationVal = updateDestination(m, sourceStartVal);
        if (destinationVal != sourceStartVal) break;
      }
      seedStageLocations[key].add(destinationVal);
    }
  });

  print('Soil locations $seedStageLocations');
  print('Minimum Seed Location is ${seedStageLocations[seedStageLocations.length - 1].reduce(min)}');
  // Part 2
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

Map<String, List<List<int>>> parseInput(List<String> lines) {
  Map<String, List<List<int>>> resultMap = {};
  String currentKey = '';

  for (var line in lines) {
    // Skip empty lines
    if (line.isEmpty) {
      continue;
    }
    // Check if the line is a heading
    if (line.endsWith(' map:')) {
      currentKey = line.substring(0, line.length - 5);
      resultMap[currentKey] = [];
    } else if (currentKey.isNotEmpty) {
      resultMap[currentKey]?.add(line.split(' ').map(int.parse).toList());
    }
  }

  return resultMap;
}

int updateDestination(List<int> mapVals, int source) {
  // Check if in source range and return new mapped value if in range
  if ((mapVals[1] <= source) && ((mapVals[1] + mapVals[2] - 1) >= source)) {
    return source + mapVals[0] - mapVals[1];
  }
  return source;
}
