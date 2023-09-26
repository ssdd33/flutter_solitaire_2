import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';

void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'card game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            unselectedWidgetColor: Colors.white,
            primaryColor: Colors.white,
            canvasColor: Colors.green,
            floatingActionButtonTheme:
                Theme.of(context).floatingActionButtonTheme.copyWith(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                    ),
            appBarTheme: Theme.of(context)
                .appBarTheme
                .copyWith(backgroundColor: Colors.green),
            textTheme:
                Theme.of(context).textTheme.apply(bodyColor: Colors.white)),
        home: const CardGameScreen());
  }
}
