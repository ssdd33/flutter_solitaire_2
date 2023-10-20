import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/interface/section.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';

class TableauPile extends Pile {
  TableauPile(super.id, super.defaultCards);
  // GCard? get topOfFaceUp => cards.firstWhere((card) => card.isFaceUp);
  GCard? get bottomOfFaceUp => cards.lastWhere((card) => card.isFaceUp);
  GCard? get bottomOfFaceDown => cards.lastWhere((card) => !card.isFaceUp);
  COLOR get bottomColor => cards.length == 0 ? COLOR.ALL : cards.last.color;
  int get bottomValue => cards.length == 0 ? 14 : cards.last.value;

  @override
  void addCard(List<GCard> newCards) {
    cards.addAll(newCards);
    addHistory(cards);
  }

  @override
  List<GCard>? drawCard(GCard selectedCard) {
    //TODO drawcard에서 반환값 필요없음
    if (selectedCard.isFaceUp) {
      int indexOfTop = cards.indexOf(selectedCard);
      List<GCard> leftCards = cards.sublist(0, indexOfTop);
      List<GCard> drawedCards = cards.sublist(indexOfTop);
      cards = leftCards;
      addHistory(cards);
      return drawedCards;
    }
    return null;
  }

  void _turnOverFaceDownCard() {
    if (cards.length != 0) {
      cards = cards.map((card) {
        if (card == bottomOfFaceDown) {
          return card.copyWith(isFaceUp: true);
        }
        return card;
      }).toList();
    }
  }
}

class Tableau extends Section<TableauPile, int> {
  Tableau(CardGame game) : super(game: game, id: SectionType.tableau.name);

  @override
  void init(List<GCard> defaultCards) {
    for (int i = 0; i <= 6; i++) {
      int id = i;
      List<GCard> assignedCards = defaultCards.sublist(i, i * 2 + 1);
      assignedCards = assignedCards.map((card) {
        if (card == assignedCards.last) {
          return card.copyWith(isFaceUp: true);
        }
        return card;
      }).toList();

      pileMap[id] = TableauPile(id, assignedCards);
    }
  }

  @override
  void move(String fromPileId, GCard card) {
    //if bottom  : moveto Foundation
    //if not available to foundation || not bottom : move to tableau (draw)
    TableauPile pile = pileMap[fromPileId]!;
    bool isAvailableToFoundation = true;

    if (pile.bottomOfFaceUp == card) {
      isAvailableToFoundation =
          game.moveInterSection(SectionType.foundation.name, [card]);

      if (isAvailableToFoundation) {
        pile.drawCard(card);
      }
    }

    if (pile.bottomOfFaceUp != card || !isAvailableToFoundation) {
      List<GCard> selectedCards = pile.cards.sublist(pile.cards.indexOf(card));
      bool isAvailableToTableau =
          game.moveInterSection(SectionType.tableau.name, selectedCards);

      if (isAvailableToTableau) {
        pile.drawCard(card);
      }
    }
    bool isAvailableAutoComplete = checkIsAvailableAutoComplete();
    if (isAvailableAutoComplete) {
      game.gameStatus = GameStatus.allUp;
    }
    game.isAvailableAutoComplete = isAvailableAutoComplete;
  }

  bool checkIsAvailableAutoComplete() {
    return piles.firstWhere((pile) =>
            pile.cards.firstWhere((card) => !card.isFaceUp) != null) ==
        null;
  }
}
