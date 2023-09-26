import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/screen/section/foundation_screen.dart';
import 'package:flutter_solitaire_2/screen/section/stock_screen.dart';
import 'package:flutter_solitaire_2/screen/section/tableau_screen.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Row(
            children: [FoundationScreen(), SizedBox(width: 10), StockScreen()],
          ),
          SizedBox(height: 10),
          TableauScreen()
        ]));
  }
}
