import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/model/board/foundation.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';
import 'package:flutter_solitaire_2/screen/section/foundation/foundation_controller.dart';
import 'package:flutter_solitaire_2/screen/widget/blank.dart';
import 'package:flutter_solitaire_2/screen/widget/card/face_up_card_widget.dart';

class FoundationScreen extends StatelessWidget {
  const FoundationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FoundationController controller = FoundationController(context: context);

    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(border: Border.all()),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            direction: Axis.horizontal,
            children: [
              if (controller.status == GameStatus.init) ...[
                const Blank(),
                const Blank(),
                const Blank(),
                const Blank()
              ],
              if (controller.status != GameStatus.init)
                ...controller.piles
                    .map((FoundationPile pile) => pile.topValue == 0
                        ? const Blank()
                        : GestureDetector(
                            onTap: () => controller.onMoveCard(
                                pile.shape, pile.cards.last),
                            child: FaceUpCardWidget(card: pile.cards.last)))
                    .toList()
            ],
          ),
        ));
  }
}
