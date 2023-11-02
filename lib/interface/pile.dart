import 'package:flutter_solitaire_2/interface/card.dart';

abstract class Pile {
  final dynamic id;
  late List<GCard> cards;
  List<List<GCard>> history = [];
  Pile(
    this.id,
    List<GCard>? defaultCards,
  ) {
    if (defaultCards == null) {
      cards = [];
      addHistory([]);
    } else {
      cards = defaultCards;
      addHistory(defaultCards);
    }
  }

  void addCard(List<GCard> newCards);

  List<GCard>? drawCard(GCard selectedCard);

  void addHistory(List<GCard> cardsState) {
    List<GCard> snapShot = cardsState
        .map((card) => GCard(card.shape, card.color, card.value, card.isFaceUp))
        .toList();

    history.add(snapShot);
  }

  void undo() {
    if (history.length > 1) {
      history.removeLast();
      cards = history.last
          .map((card) =>
              GCard(card.shape, card.color, card.value, card.isFaceUp))
          .toList();
    }
  }

  void restart() {
    cards = history[0]
        .map((card) => GCard(card.shape, card.color, card.value, card.isFaceUp))
        .toList();
    history = [history.first];
  }
}
