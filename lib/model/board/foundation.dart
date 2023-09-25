import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/interface/section.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';

class FoundationPile extends Pile {
  int get topValue => cards.length == 0 ? 0 : cards.last.value;
  FoundationPile(SHAPE shape, List<GCard> defaultCards)
      : super(shape.name, defaultCards);

  @override
  void addCard(List<GCard> newCards) {
    cards.addAll(newCards);
  }

  @override
  List<GCard>? drawCard(GCard selectedCard) {
    return [cards.removeLast()];
  }
}

class Foundation extends Section<FoundationPile> {
  Foundation(CardGame game)
      : super(game: game, id: SectionType.foundation.name);

  @override
  void init(List<GCard> defaultCards) {
    for (SHAPE shape in SHAPE.values) {
      if (shape == SHAPE.ALL) continue;

      pileMap[shape.name] = FoundationPile(shape, []);
    }
  }

  @override
  void move(String fromPileId, GCard card) {
    bool isAvailableToTableau =
        game.moveInterSection(SectionType.tableau.name, [card]);
    if (isAvailableToTableau) {
      FoundationPile pile = pileMap[fromPileId]!;
      pile.drawCard(card);
    }
  }

  bool isGameComplete() {
    return piles.where((pile) => pile.topValue == 13).toList().length == 4;
  }
}