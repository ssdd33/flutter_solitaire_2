import 'package:flutter_solitaire_2/interface/card.dart';

abstract class Pile {
  final String id;
  late List<GCard> cards;

  Pile(
    this.id,
    List<GCard>? defaultCards,
  ) {
    if (defaultCards == null) {
      cards = [];
    } else {
      cards = defaultCards;
    }
  }

  void addCard(List<GCard> newCards);
  List<GCard>? drawCard(GCard selectedCard);
}
