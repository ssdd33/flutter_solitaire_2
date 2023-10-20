import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/interface/card.dart';

import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/screen/widget/card/face_up_card_widget.dart';

class HorizontalPileScreen extends StatelessWidget {
  final Pile pile;
  final int length;
  const HorizontalPileScreen({
    Key? key,
    required this.pile,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: [
        if (pile.cards.length <= length)
          ...pile.cards
              .map((GCard card) =>
                  SizedBox(width: 50, child: FaceUpCardWidget(card: card)))
              .toList(),
        if (pile.cards.length > length)
          ...pile.cards
              .sublist(1, 3)
              .map((GCard card) => FaceUpCardWidget(card: card))
              .toList()
      ],
    );
  }
}
