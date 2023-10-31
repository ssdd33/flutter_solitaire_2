import 'dart:collection';

import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/game.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';

abstract class Section<T extends Pile, K> {
  final String id;
  final Game game;
  LinkedHashMap<K, T> pileMap = LinkedHashMap();
  List<T> get piles => pileMap.values.toList();

  Section({
    required this.id,
    required this.game,
  });
  void init(List<GCard> defaultCards);

  /// toPileId 반환 -> viewController단에서 game.addHistory 실행하기위함
  dynamic move(K fromPileId, GCard card);

  void undo(K pileId) {
    print("$K $pileId");
    print(pileMap);
    pileMap[pileId]!.undo();
    print("section undo: ${pileMap[pileId]!.cards}");
  }

  void restart() {
    for (var pile in piles) {
      pile.restart();
    }
  }
}
