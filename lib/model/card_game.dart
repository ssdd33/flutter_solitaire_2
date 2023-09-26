import 'dart:collection';

import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';

import 'package:flutter_solitaire_2/model/board/foundation.dart';
import 'package:flutter_solitaire_2/model/board/stock.dart';
import 'package:flutter_solitaire_2/model/board/tableau.dart';

class CardGame extends Game {
  Stock get _stock => sectionMap[SectionType.stock.name]! as Stock;

  Foundation get _foundation =>
      sectionMap[SectionType.foundation.name]! as Foundation;

  Tableau get _tableau => sectionMap[SectionType.tableau.name]! as Tableau;
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
  }

  @override
  void _initBoard() {
    sectionMap = HashMap();
    sectionMap[SectionType.stock.name] = Stock(this);
    sectionMap[SectionType.foundation.name] = Foundation(this);
    sectionMap[SectionType.tableau.name] = Tableau(this);
  }

  @override
  void initGame() {
    cardSet.shuffle();

    _foundation.init([]);
    _tableau.init(cardSet.sublist(0, 24));
    _tableau.init(cardSet.sublist(24));
  }

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
    //search tableau piles if there is card with opposite color and value + 1
    GCard selectedCard = cards[0];
    TableauPile? pile = _tableau.piles.firstWhere((pile) =>
        pile.bottomColor != selectedCard.color &&
        pile.bottomValue == selectedCard.value + 1);
    if (pile != null) {
      //TODO 카드를 이동한 뒤 기존 pile에서 draw하고 있음, 이부분 순서 다시 생각해보기
      pile.addCard(cards);
      return true;
    }
    return false;
  }

  @override
  void checkComplete() {
    isGameComplete = _foundation.isGameComplete();
  }
}

enum SectionType { stock, foundation, tableau }
