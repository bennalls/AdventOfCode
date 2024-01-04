import 'dart:io';

void main() {
  var filePath = '/Users/bennalls/Developer/Advent of Code/2023/Day 3/input.txt';
  List<String> lines = readLines(filePath);
  print(lines);

  // Create list of map objects detailing positions of all numbers in input
  var numPositions = [];
  for (int rowNum = 0; rowNum < lines.length; rowNum++) {
    extractNumbersAndPositions(lines[rowNum], rowNum).forEach((numPos) {
      numPositions.add(numPos);
    });
  }
  print(numPositions);

  var specialCharacterListsBoolean = convertStringsToBooleanLists(lines);

  numPositions.forEach((numPos) {
    numPos['SurroundingVals'] = retrieveSelectiveValues(specialCharacterListsBoolean, numPos);
  });

  numPositions.forEach((element) {
    print(element);
  });

  // Part 1
  num answerSum = 0;
  numPositions.forEach((numPos) {
    if (numPos['SurroundingVals'].contains(true)) {
      answerSum += numPos['Number'];
    }
  });
  print('Part 1: $answerSum');
  print(numPositions.length);

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

List<Map<String, dynamic>> extractNumbersAndPositions(String input, int rowNum) {
  List<Map<String, dynamic>> nums = [];
  RegExp regExp = RegExp(r'\d+'); // Regular expression for numbers
  Iterable<RegExpMatch> matches = regExp.allMatches(input);

  for (final match in matches) {
    int number = int.parse(match.group(0)!); // Extracted number
    int start = match.start; // Start position of the match
    int end = match.end - 1; // End position of the match

    nums.add({'Number': number, 'Start': start, 'End': end, 'Row': rowNum});
  }
  return nums;
}

// Error in this function
List<bool> retrieveSelectiveValues(List<List<bool>> boolLists, Map<String, dynamic> numPos) {
  int row = numPos['Row']!;
  int start = numPos['Start']! - 1;
  int end = numPos['End']! + 1;
  List<bool> result = [];

  // Adjust start and end to be within bounds
  start = start < 0 ? 0 : start;
  end = end >= boolLists[row].length ? boolLists[row].length - 1 : end;

  // Add value before start and after end from the specified row
  if (start > 0 && start < boolLists[row].length) {
    result.add(boolLists[row][start]);
  }
  if (end < boolLists[row].length) {
    result.add(boolLists[row][end]);
  }

  // Add values from the previous and next rows
  for (int i = row - 1; i <= row + 1; i += 2) {
    if (i >= 0 && i < boolLists.length) {
      result.addAll(boolLists[i].getRange(start, end + 1));
    }
  }

  return result;
}

List<List<bool>> convertStringsToBooleanLists(List<String> inputStrings) {
  List<List<bool>> booleanLists = [];

  for (String str in inputStrings) {
    List<bool> booleanList = [];
    for (int i = 0; i < str.length; i++) {
      // Check if the character is not a letter, number, or full stop
      booleanList.add(!RegExp(r'[A-Za-z0-9\.]').hasMatch(str[i]));
    }
    booleanLists.add(booleanList);
  }

  return booleanLists;
}
