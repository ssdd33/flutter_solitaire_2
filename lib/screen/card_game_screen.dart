import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter_solitaire_2/screen/animation/card_move_layer.dart';
import 'package:flutter_solitaire_2/screen/layout/board_screen.dart';
import 'package:flutter_solitaire_2/screen/layout/header.dart';

class CardGameScreen extends InheritedWidget {
  const CardGameScreen(this.cardGame, {super.key, required super.child});
  final CardGame cardGame;

  static CardGame game(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CardGameScreen>()!
        .cardGame;
  }

  static CardGameScreen of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CardGameScreen>()!;
  }

  @override
  bool updateShouldNotify(CardGameScreen oldWidget) {
    return true;
  }
}
