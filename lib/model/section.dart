import 'package:flutter_solitaire_2/model/card.dart';

abstract class Pile {
  final List<GCard> cards;

  Pile(this.cards);

  void addCard(GCard card);

  void drawCard(GCard card);
}

class Stock {
  final List<GCard> cards;

  Stock(this.cards);
}

class Foundation {
  final SHAPE shape;
  int topValue = -1;

  Foundation(this.shape);
}

class Tableau {
  List<GCard> cards = [GCard(SHAPE.ALL, COLOR.ALL, 14)];
  COLOR get bottomColor => cards.last.color;
  int get bottomValue => cards.last.value;

  Tableau(List<GCard>? defaultCards) {
    if (defaultCards != null) {
      cards.addAll(defaultCards);
    }
  }
}
