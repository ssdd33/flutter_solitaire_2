import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/model/board/foundation.dart';
import 'package:flutter_solitaire_2/model/board/stock.dart';
import 'package:flutter_solitaire_2/model/board/tableau.dart';

class CardGame extends Game {
  Stock get _stock => sectionMap[SectionType.stock.name]! as Stock;

  Foundation get _foundation =>
      sectionMap[SectionType.foundation.name]! as Foundation;

  Tableau get _tableau => sectionMap[SectionType.tableau.name]! as Tableau;

  CardGame() {
    initBoard();
  }

  @override
  void initBoard() {
    sectionMap[SectionType.stock.name] = Stock(this);
    sectionMap[SectionType.foundation.name] = Foundation(this);
    sectionMap[SectionType.tableau.name] = Tableau(this);
  }

  @override
  void initGame() {}

  @override
  bool moveInterSection(String sectionId, List<GCard> cards) {
    switch (sectionId) {
      case String id when id == SectionType.foundation.name:
        return _moveToFoundation(cards);

      case String id when id == SectionType.tableau.name:
        return _moveToTableau(cards);

      default:
        return false;
    }
  }

  bool _moveToFoundation(List<GCard> cards) {
    GCard selectedCard = cards[0];
    FoundationPile pile = _foundation.pileMap[selectedCard.shape.name]!;

    if (pile.topValue == selectedCard.value - 1) {
      pile.addCard(cards);
      return true;
    }

    return false;
  }

  bool _moveToTableau(List<GCard> cards) {
    return false;
  }

  @override
  void checkComplete() {
    isGameComplete = _foundation.isGameComplete();
  }
}

enum SectionType { stock, foundation, tableau }

// class Game {
//   late Stock stock;
//   late List<Foundation> foundations;
//   late List<Tableau> tableaus;
//   List<Game> history = [];
//   late bool isGameComplete;

//   void initGame() {
//     /*
//   -shuffle card
//   -set foundation
//   -set tableau 1-7
//   -set stock with rest cards
//   -set isGameComplete false
//   -set history .... writeHistory
//   */
//   }

//   void writeHistory(Game game) {
//     history.add(game);
//   }

//   void undo() {
//     if (history.length != 0) {
//       Game prevState = history.removeLast();

//       stock = prevState.stock;
//       foundations = prevState.foundations;
//       tableaus = prevState.tableaus;
//     }
//   }

//   void checkComplete() {
//     if (foundations.where((foundation) => foundation.top.value == 13).length ==
//         foundations.length) {
//       isGameComplete = true;
//     }
//   }

// /*
// - choice card
//  : user interface case
// 1. std input (String)
// 2. click event (GCard)

// - draw from section
// - check available to (priority: foundation > tableau)
// - add to section 
// */
// }




