import 'dart:collection';

import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/model/card_game.dart';



// class Stock {
//   late final List<GCard> cards;
//   GCard? get top => cards.lastWhere((card) => card.isFaceUp, orElse: null);
//   Stock(this.cards);

//   void drawCard() {
//     cards = cards.where((card) => card != top).toList();
//   }

//   void traverseCard() {
//     GCard? topOfFaceDown = cards.firstWhere((card) => !card.isFaceUp);

//     if (topOfFaceDown == null) {
//       cards = cards.map((card) => card.copyWith(isFaceUp: false)).toList();
//     } else {
//       //TODO 객체 참조 확인
//       topOfFaceDown = topOfFaceDown.copyWith(isFaceUp: true);
//     }
//   }
// }

// class Foundation {
//   late GCard top;

//   Foundation(SHAPE shape, COLOR color) {
//     top = GCard(shape, color, 0, true);
//   }

//   void addCard() {
//     top = top.copyWith(value: top.value + 1);
//   }

//   void drawCard() {
//     if (top.value > 0) {
//       top = top.copyWith(value: top.value - 1);
//     }
//   }
// }

// class Tableau {
//   String id;
//   late List<GCard> cards;
//   GCard? get bottom => cards.firstWhere((card) => card.isFaceUp, orElse: null);
//   GCard? get top => cards.length == 0
//       ? GCard(SHAPE.ALL, COLOR.ALL, 14)
//       : cards.lastWhere((card) => card.isFaceUp, orElse: null);

//   Tableau(this.id, List<GCard>? defaultCards) {
//     if (defaultCards != null) {
//       cards.addAll(defaultCards);
//     }

//     void turnOverBottomCard() {
//       cards.last = cards.last.copyWith(isFaceUp: true);
//     }

//     List<GCard>? drawCard(GCard selectedCard) {
//       GCard? selected = cards.singleWhere((card) => card == selectedCard);

//       if (selected != null && selected.isFaceUp) {
//         List<GCard> selectedCards = cards
//             .where((card) => card.isFaceUp && card.value <= selected.value)
//             .toList();

//         cards = cards
//             .where((card) =>
//                 !card.isFaceUp || card.isFaceUp && card.value > selected.value)
//             .toList();
//         // XXX ui 동작하는 방식에 따라 game에서 실행으로 수정 가능
//         if (selected == bottom) {
//           turnOverBottomCard();
//         }
//         return selectedCards;
//       }
//     }

//     void addCard(List<GCard> pile) {
//       cards.addAll(pile);
//     }
//   }
// }
