// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';

import 'package:flutter_solitaire_2/model/board/foundation.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';

class FoundationController with ChangeNotifier {
  final BuildContext context;
  late final CardGame game;
  late final Foundation foundation;
  FoundationController({
    required this.context,
  }) {
    game = CardGameScreen.game(context);
    foundation = game.foundation;
  }

  GameStatus get status => game.gameStatus;
  List<FoundationPile> get piles => foundation.piles;

  void onMoveCard(SHAPE fromPileId, GCard card) {
    int? toPileId = foundation.move(fromPileId, card);
    if (toPileId != null) {
      game.addHistory(fromPileId, toPileId);
      notifyListeners();
    }
  }
}
