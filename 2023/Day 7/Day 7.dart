import 'dart:io';

void main() {
  var filePath = '/Users/bennalls/Developer/Advent of Code/2023/Day 7/input.txt';
  List<String> lines = readLines(filePath);
  print(lines);
  List<List<String>> hands = lines.map((line) => line.split(' ').toList()).toList();
  print(hands);
// Part 1

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

class CardHand {
  List<String> hand;
  Map<String, int> cardCounts;
  static const Map<String, int> cardRank = {
    'A': 13,
    'K': 12,
    'Q': 11,
    'J': 10,
    'T': 9,
    '9': 8,
    '8': 7,
    '7': 6,
    '6': 5,
    '5': 4,
    '4': 3,
    '3': 2,
    '2': 1,
  };

  CardHand(this.hand) : cardCounts = _calculateCardCounts(hand);

  static Map<String, int> _calculateCardCounts(List<String> hand) {
    var counts = <String, int>{};
    for (var card in hand) {
      counts[card] = (counts[card] ?? 0) + 1;
    }
    return counts;
  }

  static int compareHands(CardHand hand1, CardHand hand2) {
    var classification1 = hand1.classify();
    var classification2 = hand2.classify();

    if (classification1 != classification2) {
      return _compareByClassification(classification1, classification2);
    } else {
      for (int i = 0; i < hand1.hand.length; i++) {
        int rank1 = CardHand.cardRank[hand1.hand[i]]!;
        int rank2 = CardHand.cardRank[hand2.hand[i]]!;
        if (rank1 != rank2) {
          return rank1 - rank2;
        }
      }
    }
    return 0; // For the sake of completeness
  }

  String classify() {
    var countValues = cardCounts.values.toList();

    if (countValues.contains(5)) {
      return '5 of a kind';
    } else if (countValues.contains(4)) {
      return '4 of a kind';
    } else if (countValues.contains(3) && countValues.contains(2)) {
      return 'Full house';
    } else if (countValues.contains(3)) {
      return '3 of a kind';
    } else if (countValues.where((count) => count == 2).length == 2) {
      return '2 pair';
    } else if (countValues.contains(2)) {
      return '1 pair';
    } else {
      return 'None';
    }
  }

  static int _compareByClassification(String classification1, String classification2) {
    const order = ['5 of a kind', '4 of a kind', 'Full house', '3 of a kind', '2 pair', '1 pair', 'None'];
    int index1 = order.indexOf(classification1);
    int index2 = order.indexOf(classification2);

    return index1 - index2; // Return the difference in index
  }
}
