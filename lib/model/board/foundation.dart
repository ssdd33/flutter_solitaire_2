import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/interface/section.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';

class FoundationPile extends Pile {
  int get topValue => cards.isEmpty ? 0 : cards.last.value;
  SHAPE shape = SHAPE.ALL;
  FoundationPile(SHAPE shapeValue, List<GCard> defaultCards)
      : super(shapeValue, defaultCards) {
    shape = shapeValue;
  }

  @override
  void addCard(List<GCard> newCards) {
    cards.addAll(newCards);
    addHistory(cards);
  }

  @override
  List<GCard>? drawCard(GCard selectedCard) {
    if (cards.isNotEmpty) {
      GCard removed = cards.removeLast();
      addHistory(cards);
      return [removed];
    }
    return null;
  }
}

class Foundation extends Section<FoundationPile, SHAPE> {
  Foundation(CardGame game)
      : super(game: game, id: SectionType.foundation.name);

  @override
  void init(List<GCard> defaultCards) {
    for (SHAPE shape in SHAPE.values) {
      if (shape == SHAPE.ALL) continue;

      pileMap[shape] = FoundationPile(shape, []);
    }
  }

  @override
  move(SHAPE fromPileId, GCard card) {
    int? toPileId = game.moveInterSection(SectionType.tableau.name, [card]);
    if (toPileId != null) {
      FoundationPile pile = pileMap[fromPileId]!;
      pile.drawCard(card);
    }
    return toPileId;
  }

  bool isGameComplete() {
    return piles.where((pile) => pile.topValue == 13).toList().length == 4;
  }
}
