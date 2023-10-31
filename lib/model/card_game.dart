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
  List<dynamic> hintListHistory = [];
  /**
   * List< [GCard card, dynamic from, dynamic to] >
   */
  List<dynamic> hintList = [];
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
        List<List<dynamic>> newHints = [];
        for (int toPileId in availableToList) {
          newHints.add([last, pile.id, toPileId]);
        }
        addHint(newHints);
      }

      if (availableToShape != null) {
        addHint([
          [last, pile.id, availableToShape]
        ]);
      }
    }

    //UI_UPDATE
    notifyListeners();
  }

// UI controller에서 실행되어야함
  void addHistory(dynamic from, dynamic to) {
    print(hintListHistory);
    history.add([from, to, hintListHistory.length - 1]);
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
      List<dynamic> snapshot = history.removeLast();
      print(snapshot);
      List<dynamic> prevMove = snapshot.sublist(0, 2);
      int hintListIdx = snapshot[2];

      if (prevMove.where((id) => id == SectionType.stock).length == 2) {
        stock.undo(prevMove[0]);
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
      if (hintListIdx >= 0) {
        hintList = hintListHistory[hintListIdx];
        hintListHistory = hintListHistory.sublist(0, hintListIdx);
        curHintIdx = 0;
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

/**
 * tableau pile중 파라미터로 받은 파일로 이동가능한 카드를 가지고 있는 파일이 있는지 확인
 * 반환값 List< [GCard card, int fromTpile]>
 */
  List<dynamic> checkAvailableMovesFromTableau(int tPileId) {
    List result = [];
    TableauPile toPile = tableau.pileMap[tPileId]!;
    int valueOfPile = toPile.bottomValue;
    COLOR colorOfPile = toPile.bottomColor;

    for (TableauPile pile in tableau.piles) {
      if (pile.cards.isNotEmpty) {
        List<GCard> faceUpCards =
            pile.cards.where((card) => card.isFaceUp).toList();
        //TODO faceUpCards의 순서가 지켜지는지 확인 필요
        GCard topOfFaceUp = faceUpCards[0];

        if (topOfFaceUp.color != colorOfPile &&
            topOfFaceUp.value == valueOfPile - 1) {
          result.add([topOfFaceUp, pile.id]);
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

  void addHint(List<List<dynamic>> hints) {
    hintList.addAll(hints);
    hintListHistory.add(hintList
        .map((hint) => hint.map((el) {
              if (el is GCard) {
                return GCard(el.shape, el.color, el.value, el.isFaceUp);
              }
              return el;
            }).toList())
        .toList());
  }

  void checkHintList(GCard card) {
    if (hintList.isEmpty) return;
    List<dynamic> prevHint =
        hintList.firstWhere((hint) => hint[0] == card).toList();

    //XXX 이미 이동된 힌트와 카드, 'to'가 겹치는 경우의 기존 힌트 제거
    hintList = hintList
        .where((hint) => hint[0] != card && hint[2] != prevHint[2])
        .toList();
    curHintIdx = 0;
    int fromTPileId = prevHint[1];
    GCard? lastCardOfTPile = tableau.pileMap[fromTPileId]!.cards.isEmpty
        ? null
        : tableau.pileMap[fromTPileId]!.cards.last;

    if (lastCardOfTPile != null) {
      //XXX 기존 힌트의 from에서 새로운 카드가 이동가능한지 확인
      List<int> availableMovesToTableau =
          checkAvailableMoveToTableau(lastCardOfTPile);
      SHAPE? availableMoveToFoundation =
          checkAvailableMoveToFoundation(lastCardOfTPile);

      if (availableMovesToTableau.isNotEmpty) {
        List<List<dynamic>> newHints = [];
        for (int tPileId in availableMovesToTableau) {
          newHints.add([lastCardOfTPile, fromTPileId, tPileId]);
        }
        addHint(newHints);
      }

      if (availableMoveToFoundation != null) {
        addHint([
          [lastCardOfTPile, fromTPileId, availableMoveToFoundation]
        ]);
      }
    }
    //XXX 기존 힌트의 from의 새로운 카드로 이동가능한 카드가 있는지 다른 tableau pile 확인
    List<dynamic> availableMovesFromTableau =
        checkAvailableMovesFromTableau(fromTPileId);
    if (availableMovesFromTableau.isNotEmpty) {
      List<List<dynamic>> newHints = [];
      for (List<dynamic> toPileData in availableMovesFromTableau) {
        newHints.add([...toPileData, fromTPileId]);
      }
      addHint(newHints);
    }

    //XXX 여기서도 ui update가 필요한지
    notifyListeners();
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
      print('getHint: $hintList');
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

------------------

1030
undo 실행후 hintList 복원 
*/
