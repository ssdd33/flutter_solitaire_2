import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/interface/section.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';

class TableauPile extends Pile {
  TableauPile(super.id, super.defaultCards);
  // GCard? get topOfFaceUp => cards.firstWhere((card) => card.isFaceUp);
  GCard? get bottomOfFaceUp => cards.isEmpty ? null : cards.last;
  GCard? get bottomOfFaceDown =>
      cards.isEmpty ? null : cards.lastWhere((card) => !card.isFaceUp);
  COLOR get bottomColor => cards.isEmpty ? COLOR.ALL : cards.last.color;
  int get bottomValue => cards.isEmpty ? 14 : cards.last.value;

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
      if (bottomOfFaceUp == null && cards.isNotEmpty) {
        cards[cards.length - 1] = cards.last.copyWith(isFaceUp: true);
      }
      addHistory(cards);
      return drawedCards;
    }
    return null;
  }

  // void _turnOverFaceDownCard() {
  //   if (cards.isNotEmpty) {
  //     cards = cards.map((card) {
  //       if (card == bottomOfFaceDown) {
  //         return card.copyWith(isFaceUp: true);
  //       }
  //       return card;
  //     }).toList();
  //   }
  // }
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
  move(int fromPileId, GCard card) {
    //if bottom  : moveto Foundation
    //if not available to foundation || not bottom : move to tableau (draw)
    TableauPile pile = pileMap[fromPileId]!;
    bool isAvailableToFoundation = true;
    dynamic toPileId;

// card 1장이 선택된 경우
    if (pile.bottomOfFaceUp == card) {
      toPileId = game.moveInterSection(SectionType.foundation.name, [card]);

      if (toPileId == null) {
        isAvailableToFoundation = false;
      }

      if (isAvailableToFoundation) {
        pile.drawCard(card);
      }
    }

// pile이 선택된 경우  or 이동가능한 foundation이 없는 경우
    if (pile.bottomOfFaceUp != card || !isAvailableToFoundation) {
      GCard selectedCard =
          pile.cards.where((pCard) => pCard == card).toList()[0];
      int indexOfCard = pile.cards.indexOf(selectedCard);
      List<GCard> selectedCards = pile.cards.sublist(indexOfCard);

      toPileId = game.moveInterSection(SectionType.tableau.name, selectedCards);

      if (toPileId != null) {
        pile.drawCard(card);
      }
    }

    bool isAvailableAutoComplete = checkIsAvailableAutoComplete();
    if (isAvailableAutoComplete) {
      game.gameStatus = GameStatus.allUp;
    }
    game.isAvailableAutoComplete = isAvailableAutoComplete;

    return toPileId;
  }

  bool checkIsAvailableAutoComplete() {
    return piles
            .where((pile) =>
                pile.cards.isEmpty ||
                (pile.cards.isNotEmpty &&
                    pile.cards.where((card) => !card.isFaceUp).isEmpty))
            .length ==
        7;
  }
}
