import 'package:flutter/material.dart';

import 'package:flutter_solitaire_2/interface/card.dart';

class FaceUpCardWidget extends StatelessWidget {
  final GCard card;
  const FaceUpCardWidget({
    Key? key,
    required this.card,
  }) : super(key: key);

  String parseValue(int value) {
    switch (value) {
      case 11:
        return 'J';
      case 12:
        return 'Q';
      case 13:
        return 'K';
      default:
        return '$value';
    }
  }

  String parseShape(SHAPE shape) {
    switch (shape) {
      case SHAPE.CLOVER:
        return '♣︎';
      case SHAPE.HEART:
        return '♥︎';
      case SHAPE.DIAMOND:
        return '♦';
      case SHAPE.SPADE:
        return '♠';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 80,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0.7,
                blurRadius: 0.5,
                offset: const Offset(-1, 1))
          ],
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(3),
          color: Colors.amber.shade50),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            '${parseValue(card.value)}${parseShape(card.shape)}'.toUpperCase(),
            style: TextStyle(
                fontSize: 10,
                color: card.color.name.substring(0, 1) == 'R'
                    ? Colors.red
                    : Colors.black),
          ),
        ),
      ),
    );
  }
}
