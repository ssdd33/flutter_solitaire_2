import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';
import 'package:flutter_solitaire_2/screen/layout/board_screen.dart';
import 'package:flutter_solitaire_2/screen/layout/header.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    CardGame game = CardGame();
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
        home: ListenableBuilder(
            listenable: game,
            builder: (BuildContext context, Widget? child) {
              print('*GAME BUILD');
              return CardGameScreen(game,
                  child: SafeArea(
                      child: Stack(
                    children: [
                      Container(
                          decoration: const BoxDecoration(color: Colors.green),
                          child: const Column(children: [
                            Flexible(flex: 1, child: Header()),
                            Flexible(flex: 8, child: BoardScreen())
                          ])),
                    ],
                  )));
            }));
  }
}
