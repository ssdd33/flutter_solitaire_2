import 'package:flutter/material.dart';

import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';

class Header extends StatelessWidget {
  const Header({super.key});
  /*
  game status : init, started, allup, done
  init :start btn
  started : restart btn, undo
  allup: restart  btn ,undo,  autocomplete btn
done: restart , new game 
  */

  @override
  Widget build(BuildContext context) {
    CardGame game = CardGameScreen.game(context);
    GameStatus status = game.gameStatus;
    print('**HEADER BUILD');
    return Container(
        height: double.infinity,
        decoration: BoxDecoration(border: Border.all()),
        child: Center(
          child: status == GameStatus.init
              ? NewGameButton(
                  onPressed: game.initGame,
                )
              : status == GameStatus.playing
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      NewGameButton(onPressed: game.initGame),
                      const SizedBox(width: 10),
                      RestartButton(onPressed: game.restartGame),
                      const SizedBox(width: 10),
                      UndoButton(onPressed: game.undo),
                      const SizedBox(width: 10),
                      HintButton(onPressed: () {
                        print(game.hintList);
                        print(game.getHint());
                      })
                    ])
                  : status == GameStatus.done
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              NewGameButton(onPressed: game.initGame),
                              const SizedBox(width: 10),
                              RestartButton(onPressed: game.restartGame)
                            ])
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              NewGameButton(onPressed: game.initGame),
                              const SizedBox(width: 10),
                              RestartButton(onPressed: game.restartGame),
                              const SizedBox(width: 10),
                              AutoCompleteButton(onPressed: game.autoComplete),
                              const SizedBox(width: 10),
                              UndoButton(onPressed: game.undo)
                            ]),
        ));
  }
}

class NewGameButton extends StatelessWidget {
  final void Function() onPressed;
  const NewGameButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: const Text('new game'));
  }
}

class RestartButton extends StatelessWidget {
  final void Function() onPressed;
  const RestartButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: const Text('reStart'));
  }
}

class AutoCompleteButton extends StatelessWidget {
  final void Function() onPressed;
  const AutoCompleteButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed, child: const Text('auto complete'));
  }
}

class UndoButton extends StatelessWidget {
  final void Function() onPressed;
  const UndoButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: const Text('undo'));
  }
}

class HintButton extends StatelessWidget {
  final void Function() onPressed;
  const HintButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: const Text('hint'));
  }
}
