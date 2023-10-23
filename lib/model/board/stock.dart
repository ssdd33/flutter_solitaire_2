import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/interface/section.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:collection/collection.dart';

class StockPile extends Pile {
  GCard? get topOfFaceUp => cards.lastWhereOrNull((card) => card.isFaceUp);

  GCard? get topOfFaceDown => cards.firstWhereOrNull((card) => !card.isFaceUp);
  StockPile(super.id, super.defaultCards);

  @override
  void addCard(List<GCard> cards) {
    throw UnimplementedError();
  }

  @override
  List<GCard>? drawCard(GCard selectedCard) {
    cards.remove(selectedCard);
    addHistory(cards);
    return [selectedCard];
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
    addHistory(cards);
  }
}

class Stock extends Section<StockPile, SectionType> {
  Stock(CardGame game) : super(game: game, id: SectionType.stock.name) {
    init([]);
  }
  List<GCard> get faceUpCards =>
      pileMap[SectionType.stock]!.cards.where((card) => card.isFaceUp).toList();
  List<GCard> get faceDownCards => pileMap[SectionType.stock]!
      .cards
      .where((card) => !card.isFaceUp)
      .toList();
  @override
  void init(List<GCard> defaultCards) {
    pileMap[SectionType.stock] = StockPile(SectionType.stock, defaultCards);
  }

  @override
  move(SectionType fromPileId, GCard card) {
    //XXX stock은 pile이 하나이므로 파라미터 fromPileId는 의미 없음 -> 옵셔널로 수정

    StockPile pile = pileMap[SectionType.stock]!;

    dynamic toPileId;
    toPileId = game.moveInterSection(SectionType.foundation.name, [card]);

    toPileId ??= game.moveInterSection(SectionType.tableau.name, [card]);
    if (toPileId != null) {
      pile.drawCard(card);
    }
    return toPileId;
  }

  void autoComplete(SHAPE shape, int value) {
    int startValue = value;
    List<GCard> selectedCards = pileMap[SectionType.stock]!
        .cards
        .where((card) => card.shape == shape && card.value == startValue)
        .toList();

    while (selectedCards.isNotEmpty) {
      move(SectionType.stock, selectedCards[0]);
      startValue++;
      selectedCards = pileMap[SectionType.stock]!
          .cards
          .where((card) => card.shape == shape && card.value == startValue)
          .toList();
    }
  }
}
