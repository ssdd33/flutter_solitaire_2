class GCard {
  final SHAPE shape;
  final COLOR color;
  final int value;
  final bool isFaceUp;

  GCard(this.shape, this.color, this.value, [this.isFaceUp = false]);
}

enum SHAPE { HEART, SPACE, CLOVER, DIAMOND, ALL }

enum COLOR { RED, BLACK, ALL }
