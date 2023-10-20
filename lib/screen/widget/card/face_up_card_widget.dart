import 'package:flutter/material.dart';

import 'package:flutter_solitaire_2/interface/card.dart';

class FaceUpCardWidget extends StatelessWidget {
  final GCard card;
  const FaceUpCardWidget({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0.7,
                blurRadius: 0.5,
                offset: Offset(-1, 1))
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
            '${card.shape.name.substring(0, 1)}${card.value}'.toUpperCase(),
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
