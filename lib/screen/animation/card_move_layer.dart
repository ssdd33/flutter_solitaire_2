import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/screen/widget/blank.dart';

class CardMoveLayer extends StatefulWidget {
  const CardMoveLayer({super.key});

  @override
  State<CardMoveLayer> createState() => _CardMoveLayerState();
}

class _CardMoveLayerState extends State<CardMoveLayer> {
  Alignment alignment = Alignment.bottomLeft;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                color: Color.fromARGB(100, 255, 0, 0)),
            child: Column(
              children: [
                Text('card move layer',
                    style: TextStyle(
                      fontSize: 20,
                    )),
                Expanded(
                  child: AnimatedAlign(
                      alignment: alignment,
                      duration: Duration(milliseconds: 500),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              alignment = alignment == Alignment.bottomLeft
                                  ? Alignment.topRight
                                  : Alignment.bottomLeft;
                            });
                          },
                          child: Blank())),
                ),
              ],
            )));
  }
}
