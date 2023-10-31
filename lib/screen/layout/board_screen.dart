import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/screen/section/foundation/foundation_screen.dart';
import 'package:flutter_solitaire_2/screen/section/stock/stock_screen.dart';
import 'package:flutter_solitaire_2/screen/section/tableau/tableau_screen.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("** BOARD BUILD");
    return const SizedBox(
      height: double.infinity,
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(flex: 3, child: FoundationScreen()),
                  SizedBox(width: 10),
                  Flexible(flex: 2, child: StockScreen())
                ],
              ),
            ),
            SizedBox(height: 10),
            Flexible(flex: 6, child: TableauScreen())
          ])),
    );
  }
}

/*

cardGameScreen - game
- header -gethint : trigger 
- boardScreen

-- foundation
-- stock
-- tableau





*/