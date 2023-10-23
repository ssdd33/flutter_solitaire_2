// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/model/board/tableau.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';
import 'package:flutter_solitaire_2/screen/section/tableau/tableau_controller.dart';
import 'package:flutter_solitaire_2/screen/widget/blank.dart';
import 'package:flutter_solitaire_2/screen/widget/card/face_down_card_widget.dart';
import 'package:flutter_solitaire_2/screen/widget/card/face_up_card_widget.dart';

class TableauScreen extends StatelessWidget {
  const TableauScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TableauController controller = TableauController(context: context);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        children: [
          if (controller.gameStatus != GameStatus.init)
            ...controller.piles
                .map((pile) => TableauPileScreen(
                    pile: pile,
                    onClickCard: (GCard card) =>
                        controller.onClickCard(pile.id, card)))
                .toList()
        ],
      ),
    );
  }
}

class TableauPileScreen extends StatelessWidget {
  final TableauPile pile;
  final void Function(GCard card) onClickCard;
  const TableauPileScreen({
    Key? key,
    required this.pile,
    required this.onClickCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pile.bottomValue == 14) return const Blank();

    List<GCard> cards = pile.cards;
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        ...cards.map((card) {
          double height =
              ((cards.indexOf(card) - (cards.length - 1)).abs() * 15) + 80;
          if (!card.isFaceUp) {
            return SizedBox(
              height: height,
              child: const FaceDownCardWidget(),
            );
          }
          return SizedBox(
            height: height,
            child: GestureDetector(
                onTap: () => onClickCard(card),
                child: FaceUpCardWidget(card: card)),
          );
        }).toList()
      ],
    );
  }
}


/*
init -> blank
playing -> cardspile 



*/