import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';

import 'package:flutter_solitaire_2/model/board/foundation.dart';
import 'package:flutter_solitaire_2/model/board/stock.dart';
import 'package:flutter_solitaire_2/model/board/tableau.dart';

class CardGame extends Game with ChangeNotifier {
  Stock get stock => sectionMap[SectionType.stock.name]! as Stock;
  Foundation get foundation =>
      sectionMap[SectionType.foundation.name]! as Foundation;
  Tableau get tableau => sectionMap[SectionType.tableau.name]! as Tableau;
  List<dynamic> history = [];

  /**
   * List< [GCard card, dynamic from, dynamic to] >
   */
  List<List<dynamic>> hintList = [];
  int curHintIdx = 0;

  CardGame() {
    _initBoard();
    _initCardSet();
  }
  @override
  void _initCardSet() {
    cardSet = [];
    List<SHAPE> validShapes =
        SHAPE.values.where((shape) => shape != SHAPE.ALL).toList();
    List<COLOR> validColor =
        COLOR.values.where((color) => color != COLOR.ALL).toList();

    for (int i = 0; i < validShapes.length; i++) {
      COLOR color = validColor[(i + 1) % 2];
      for (int v = 1; v < 14; v++) {
        cardSet.add(GCard(validShapes[i], color, v));
      }
    }
    //TODO ui update는 필요없으나 객체 업데이트가 공유되어야 한다.
    notifyListeners();
  }

  @override
  void _initBoard() {
    sectionMap = HashMap();
    sectionMap[SectionType.stock.name] = Stock(this);
    sectionMap[SectionType.foundation.name] = Foundation(this);
    sectionMap[SectionType.tableau.name] = Tableau(this);

    //TODO ui update는 필요없으나 객체 업데이트가 공유되어야 한다.
    notifyListeners();
  }

  @override
  void initGame() {
    cardSet.shuffle();

    foundation.init([]);
    stock.init(cardSet.sublist(0, 24));
    tableau.init(cardSet.sublist(24));
    history = [];
    gameStatus = GameStatus.playing;

    //XXX make first hint list
    hintList = [];
    curHintIdx = 0;
    for (TableauPile pile in tableau.piles) {
      GCard last = pile.cards.last;
      List<int> availableToList = checkAvailableMoveToTableau(last);
      SHAPE? availableToShape = checkAvailableMoveToFoundation(last);

      if (availableToList.isNotEmpty) {
        for (int toPileId in availableToList) {
          hintList.add([last, pile.id, toPileId]);
        }
      }

      if (availableToShape != null) {
        hintList.add([last, pile.id, availableToShape]);
      }
    }

    //UI_UPDATE
    notifyListeners();
  }

// UI controller에서 실행되어야함
  void addHistory(dynamic from, dynamic to) {
    history.add([from, to]);
    (history);
  }

  void restartGame() {
    for (var section in sectionMap.values) {
      section.restart();
    }
    history = [];
    gameStatus = GameStatus.playing;
    //UI_UPDATE
    notifyListeners();
  }

  void undo() {
    print('undo! ${history.length}');
    if (history.isNotEmpty) {
      List<dynamic> prevMove = history.removeLast();
      print('prevMove: $prevMove');
      print(prevMove.where((id) => id == SectionType.stock).length == 2);
      if (prevMove.where((id) => id == SectionType.stock).length == 2) {
        stock.undo(prevMove[0]);
        print('stock undo id:${prevMove[0]}');
      } else {
        for (var id in prevMove) {
          switch (id.runtimeType) {
            case int:
              {
                tableau.undo(id);
              }
              break;
            case SHAPE:
              {
                foundation.undo(id);
              }
              break;
            case SectionType:
              {
                stock.undo(id);
              }
              break;
          }
        }
      }
      gameStatus = GameStatus.playing;
      //UI_UPDATE
      notifyListeners();
    }
  }

  @override
  dynamic moveInterSection(String sectionId, List<GCard> cards) {
    //파라미터 formPileId 추가하면 draw -> move 순서로 바꿀수 있음 ->X : pileId는 section초기화에서 정해지는 값으로 이 pileId로 to를 구분할 수 없음
    switch (sectionId) {
      case String id when id == SectionType.foundation.name:
        return _moveToFoundation(cards);

      case String id when id == SectionType.tableau.name:
        return _moveToTableau(cards);

      default:
        return null;
    }
  }

  SHAPE? _moveToFoundation(List<GCard> cards) {
    GCard selectedCard = cards[0];
    FoundationPile pile = foundation.pileMap[selectedCard.shape]!;

    if (pile.topValue == selectedCard.value - 1) {
      pile.addCard(cards);
      checkComplete();
      return pile.shape;
    }

    return null;
  }

  int? _moveToTableau(List<GCard> cards) {
    //search tableau piles if there is card with opposite color and value + 1
    GCard selectedCard = cards[0];
    print(tableau.piles);
    List<TableauPile> piles = tableau.piles
        .where((pile) =>
            pile.bottomColor != selectedCard.color &&
            pile.bottomValue == selectedCard.value + 1)
        .toList();
    //TODO 카드를 이동한 뒤 기존 pile에서 draw하고 있음, 이부분 순서 다시 생각해보기
    if (piles.isNotEmpty) {
      TableauPile pile = piles[0];
      pile.addCard(cards);
      //UI_UPDATE
      notifyListeners();
      return pile.id;
    }
    return null;
  }

  List<int> checkAvailableMoveToTableau(GCard card) {
    List<int> result = [];

    for (TableauPile pile in tableau.piles) {
      if (pile.cards.isNotEmpty) {
        GCard last = pile.cards.last;
        if (last.color != card.color && last.value == card.value + 1) {
          result.add(pile.id);
        }
      }
    }

    return result;
  }

  SHAPE? checkAvailableMoveToFoundation(GCard card) {
    for (FoundationPile pile in foundation.piles) {
      if (pile.shape == card.shape && pile.topValue == card.value - 1) {
        return pile.shape;
      }
    }
    return null;
  }

  @override
  void checkComplete() {
    bool isComplete = foundation.isGameComplete();
    isGameComplete = isComplete;
    if (isComplete) {
      gameStatus = GameStatus.done;
    }
    //UI_UPDATE
    notifyListeners();
  }

  @override
  void autoComplete() {
    /*
    - 태블로의 모든 파일을 순회하며 카드를 파운데이션으로 이동한다 : 
    카드이동 시도시 카드장수가 이전과 동일하거나 카드가 0장일때까지 카드 이동
    - 파일에서 카드이동 실행 전에 stock에서 카드 이동 : 
      파운데이션 섹션별로 현재 파일 상태에서 다음으로 이동가능한 카드가 없을때까지 카드 이동 
      stock .cards에 해당 카드가 있다 -> stock. move
      없다 -> 파운데이션 다음으로 
    */
    while (gameStatus != GameStatus.done) {
      for (TableauPile tPile in tableau.piles) {
        //stock 먼저 확인
        for (FoundationPile fPile in foundation.piles) {
          if (fPile.topValue < 13) {
            stock.autoComplete(fPile.shape, fPile.topValue + 1);
            //UI_UPDATE
            notifyListeners();
          }
        }

        GCard? bottomCard = tPile.bottomOfFaceUp;
        int curValue = bottomCard == null
            ? 0
            : foundation.piles
                .firstWhere((pile) => pile.shape == bottomCard!.shape)
                .topValue;

        while (bottomCard != null && curValue == bottomCard.value - 1) {
          tPile.drawCard(bottomCard);
          _moveToFoundation([bottomCard]);

          bottomCard = tPile.bottomOfFaceUp;
          curValue = bottomCard == null
              ? 0
              : foundation.piles
                  .firstWhere((pile) => pile.shape == bottomCard!.shape)
                  .topValue;

          //UI_UPDATE
          notifyListeners();
        }
      }
    }
  }

  List<dynamic>? getHint() {
    List<dynamic>? hint = null;
    if (hintList.isNotEmpty) {
      hint = hintList[curHintIdx];
      if (curHintIdx == hintList.length - 1) {
        curHintIdx = 0;
      } else {
        curHintIdx++;
      }
    }
    return hint;
  }
}

enum SectionType { stock, foundation, tableau }




/*

[hint]

update hint list

1. when game start
 - for each TABLEAU check last card for available move
A[card, from, to]
from: TABLEAU pile
to : other TABLEAU pile or FOUNDATION pile

2. when move card  M[card, from, to]
- remove available move by card

- check existed available moves by 'to' .. when its TABLEAU pile
- check new available move and add at 'from'


3. when if 1,2 has nothing 
- check STOCK as 'from' .. to TABLEAU, FOUNDATION

- ADVANCED : check if there is cards that can be built for move tableau cards or card to another tableau pile



*/