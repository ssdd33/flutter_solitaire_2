import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';
import 'package:flutter_solitaire_2/screen/card_game_screen.dart';
import 'package:flutter_solitaire_2/screen/section/tableau/tableau_controller.dart';
import 'package:flutter_solitaire_2/screen/widget/blank.dart';

class TableauScreen extends StatelessWidget {
  const TableauScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TableauController controller = TableauController(context: context);

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all()),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.horizontal,
        children: [
          Blank(),
          Blank(),
          Blank(),
          Blank(),
          Blank(),
          Blank(),
          Blank()
        ],
      ),
    );
  }
}


/*
init -> blank
playing -> 



*/