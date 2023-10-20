import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/screen/section/foundation/foundation_screen.dart';
import 'package:flutter_solitaire_2/screen/section/stock/stock_screen.dart';
import 'package:flutter_solitaire_2/screen/section/tableau/tableau_screen.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: const Padding(
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
