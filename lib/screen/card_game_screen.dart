import 'package:flutter/material.dart';
import 'package:flutter_solitaire_2/screen/layout/board_screen.dart';
import 'package:flutter_solitaire_2/screen/layout/header.dart';

class CardGameScreen extends StatelessWidget {
  const CardGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            decoration: const BoxDecoration(color: Colors.green),
            child: const Column(children: [Header(), BoardScreen()])));
  }
}
