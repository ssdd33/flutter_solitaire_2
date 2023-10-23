import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';

import 'package:flutter_solitaire_2/model/board/stock.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';

class StockController extends ChangeNotifier {
  final BuildContext context;
  late final CardGame game;

  late final Stock stock;
  StockController(this.context) {
    game = CardGameScreen.game(context);
    stock = game.stock;
  }

  List<GCard> get faceUpCards => stock.faceUpCards.length <= 3
      ? stock.faceUpCards
      : stock.faceUpCards.sublist(stock.faceUpCards.length - 3);

  int get faceDownCardsCount => stock.faceDownCards.length;
  GameStatus get status => game.gameStatus;

  void onTraverseCard() {
    stock.piles[0].traverseCard();
    game.addHistory(SectionType.stock, SectionType.stock);
    notifyListeners();
  }

  void onMoveCard(GCard card) {
    dynamic toPileId = stock.move(SectionType.stock, card);
    if (toPileId != null) {
      game.addHistory(SectionType.stock, toPileId);
      notifyListeners();
    }
  }
}
