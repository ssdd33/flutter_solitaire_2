import 'package:flutter/material.dart';

import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/model/board/stock.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';
import 'package:flutter_solitaire_2/screen/section/stock/stock_controller.dart';
import 'package:flutter_solitaire_2/screen/widget/blank.dart';
import 'package:flutter_solitaire_2/screen/widget/card/face_down_card_widget.dart';
import 'package:flutter_solitaire_2/screen/widget/card/face_up_card_widget.dart';
import 'package:flutter_solitaire_2/screen/widget/pile/horizontal_pile_widget.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CardGame game = CardGameScreen.game(context);
    Stock stock = game.stock;
    GameStatus status = game.gameStatus;

    StockController controller = StockController(stock: stock);

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: ListenableBuilder(
            listenable: controller,
            builder: (BuildContext context, Widget? child) {
              return Flex(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: [
                  if (status == GameStatus.init) ...[Blank(), Blank()],
                  if (status != GameStatus.init) ...[
                    FaceUpCards(cards: controller.faceUpCards),
                    GestureDetector(
                        onTap: controller.onTraverseCard,
                        child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              FaceDownCardWidget(),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(100, 255, 255, 255)),
                                child: Text('${controller.faceDownCardsCount}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w100)),
                              )
                            ]))
                  ]
                ],
              );
            }),
      ),
    );
  }
}

class FaceUpCards extends StatelessWidget {
  final List<GCard> cards;
  const FaceUpCards({
    Key? key,
    required this.cards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(cards.map((card) => card.toString()).toList());
    return SizedBox(
      width: 82,
      height: 80,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          if (cards.length == 0) Blank(),
          if (cards.length > 0)
            ...cards
                .map((GCard card) => SizedBox(
                    width: 50 +
                        (((cards.indexOf(card) - (cards.length - 1))).abs() *
                            15),
                    child: FaceUpCardWidget(card: card)))
                .toList(),
        ],
      ),
    );
  }
}
