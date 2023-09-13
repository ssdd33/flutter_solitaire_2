import 'package:flutter_solitaire_2/model/section.dart';

class Game {
  late Stock stock;
  late List<Foundation> foundations;
  late List<Tableau> tableaus;
  List<Game> history = [];
  late bool isGameComplete;

  Game() {
    initGame();
  }

  void initGame() {
    /*
  -shuffle card
  -set foundation
  -set tableau 1-7
  -set stock with rest cards
  -set isGameComplete false
  -set history .... writeHistory
  */
  }

  void writeHistory(Game game) {
    history.add(game);
  }

  void undo() {
    if (history.length != 0) {
      Game prevState = history.removeLast();
      stock = prevState.stock;
      foundations = prevState.foundations;
      tableaus = prevState.tableaus;
    }
  }

  void checkComplete() {
    if (foundations.where((foundation) => foundation.top.value == 13).length ==
        foundations.length) {
      isGameComplete = true;
    }
  }

/*
- choice card
 : user interface case
1. std input (String)
2. click event (GCard)

- draw from section
- check available to (priority: foundation > tableau)
- add to section 
*/
}
