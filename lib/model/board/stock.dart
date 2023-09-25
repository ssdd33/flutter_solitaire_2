import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/interface/section.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';

class StockPile extends Pile {
  GCard? get topOfFaceUp =>
      cards.lastWhere((card) => card.isFaceUp, orElse: null);

  GCard? get topOfFaceDown =>
      cards.firstWhere((card) => !card.isFaceUp, orElse: null);
  StockPile(super.id, super.defaultCards);

  @override
  void addCard(List<GCard> cards) {
    throw UnimplementedError();
  }

  @override
  List<GCard>? drawCard(GCard selectedCard) {
    if (topOfFaceUp != null) {
      List<GCard> drawedCard = [topOfFaceUp!];
      cards.remove(topOfFaceUp);
      return drawedCard;
    }
    return null;
  }

  void traverseCard() {
    if (topOfFaceDown != null) {
      cards = cards.map((card) {
        if (card == topOfFaceDown) {
          return card.copyWith(isFaceUp: true);
        }
        return card;
      }).toList();
    } else {
      cards = cards.map((card) => card.copyWith(isFaceUp: false)).toList();
    }
  }
}

class Stock extends Section<StockPile> {
  Stock(CardGame game) : super(game: game, id: SectionType.stock.name);

  @override
  void init(List<GCard> defaultCards) {
    pileMap["stock"] = StockPile("stock", defaultCards);
  }

  @override
  void move(String fromPileId, GCard card) {
    StockPile pile = pileMap[fromPileId]!;

    bool isAvailableToFoundation =
        game.moveInterSection(SectionType.foundation.name, [card]);
    if (isAvailableToFoundation) {
      pile.drawCard(card);
    } else {
      bool isAvailableToTableau =
          game.moveInterSection(SectionType.tableau.name, [card]);
      if (isAvailableToTableau) {
        pile.drawCard(card);
      }
    }
  }
}
