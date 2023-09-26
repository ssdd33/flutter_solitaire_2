import 'dart:collection';

import 'package:flutter_solitaire_2/interface/card.dart';
import 'package:flutter_solitaire_2/interface/pile.dart';
import 'package:flutter_solitaire_2/interface/section.dart';

abstract class Game {
  List<Game> history = [];
  bool isGameComplete = false;
  late HashMap<String, Section> sectionMap;
  late List<GCard> cardSet;

  // Game() {
  //   //TODO 이부분이 좀 어색함, Library로 제공되었을때 list에 add하는 방식  || 변수에 할당하는 방식
  //   sectionMap = HashMap();
  //   cardSet = [];
  //   _initBoard();
  //   _initCardSet();
  // }
/** sectionMap 초기 설정 */
  void _initBoard();

  /** 카드 셔플, Section.init으로 섹션에 초기카드 전달 */
  void initGame();

  void _initCardSet();
/**카드 이동내역 기록 */
  void writeHistory() {
    history.add(this);
  }

  void undo() {
    if (history.length != 0) {
      Game prevState = history.removeLast();
      sectionMap = prevState.sectionMap;
    }
  }

/**카드가 모두 정렬되어 게임이 끝났는지 확인, isGameComplete에 값 저장 
*/
  void checkComplete();

/**
 * sectionId 에 따라 로직 분기 : 카드게임에서는 어느섹션으로 이동할지 구분 값으로 사용됨 
 * 카드가 이동한 경우 true, 이동가능한 구역이 없어 이동을 못한 경우 false 반환
 */
  bool moveInterSection(String sectionId, List<GCard> cards);
}
