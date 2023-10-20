import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/interface/card.dart';

import 'package:flutter_solitaire_2/model/board/stock.dart';

class StockController extends ChangeNotifier {
  final Stock stock;
  StockController({
    required this.stock,
  });

  List<GCard> get faceUpCards => stock.faceUpCards.length <= 3
      ? stock.faceUpCards
      : stock.faceUpCards.sublist(stock.faceUpCards.length - 3);

  int get faceDownCardsCount => stock.faceDownCards.length;

  void onTraverseCard() {
    stock.piles[0].traverseCard();
    notifyListeners();
  }
}
