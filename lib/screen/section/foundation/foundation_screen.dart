import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/model/board/foundation.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';
import 'package:flutter_solitaire_2/screen/widget/blank.dart';
import 'package:flutter_solitaire_2/screen/widget/card/face_up_card_widget.dart';

class FoundationScreen extends StatelessWidget {
  const FoundationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CardGame game = CardGameScreen.game(context);
    Foundation foundation = game.foundation;
    GameStatus status = game.gameStatus;

    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(border: Border.all()),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            direction: Axis.horizontal,
            children: [
              if (status == GameStatus.init) ...[
                Blank(),
                Blank(),
                Blank(),
                Blank()
              ],
              if (status != GameStatus.init)
                ...foundation.piles
                    .map((FoundationPile pile) => pile.topValue == 0
                        ? Blank()
                        : FaceUpCardWidget(card: pile.cards.last))
                    .toList()
            ],
          ),
        ));
  }
}
