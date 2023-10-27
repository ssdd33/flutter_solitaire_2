import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/model/board/tableau.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';

class TableauController with ChangeNotifier {
  late final BuildContext context;
  late CardGame game;
  late Tableau tableau;

  TableauController({
    required this.context,
  }) {
    game = CardGameScreen.game(context);
    tableau = game.tableau;
  }

  void onClickCard(int pileId, GCard card) {
    dynamic toPileId = tableau.move(pileId, card);
    if (toPileId != null) {
      game.addHistory(pileId, toPileId);
      notifyListeners();
    }
  }

  GCard? CardOfHint(int pileId) {}

  GameStatus get gameStatus => game.gameStatus;
  List<TableauPile> get piles => tableau.piles;
}
