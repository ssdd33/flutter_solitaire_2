import 'package:flutter_solitaire_2/model/card_game.dart';

void main() {
  CardGame cg = CardGame();

  print(cg.sectionMap);
  print(cg.cardSet[0].value);
  cg.initGame();
  print(cg.cardSet[0].value);
  print(cg.sectionMap[SectionType.tableau.name]!.piles[0].cards[0].isFaceUp);
}
