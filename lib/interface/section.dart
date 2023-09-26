import 'dart:collection';

import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';

abstract class Section<T extends Pile> {
  final String id;
  final Game game;
  LinkedHashMap<String, T> pileMap = LinkedHashMap();
  List<T> get piles => pileMap.values.toList();

  Section({
    required this.id,
    required this.game,
  });
  void init(List<GCard> defaultCards);
  void move(String fromPileId, GCard card);
}
