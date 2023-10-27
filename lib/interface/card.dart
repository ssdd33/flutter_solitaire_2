class GCard {
  final SHAPE shape;
  final COLOR color;
  final int value;
  final bool isFaceUp;

  GCard(this.shape, this.color, this.value, [this.isFaceUp = false]);

  GCard copyWith({
    SHAPE? shape,
    COLOR? color,
    int? value,
    bool? isFaceUp,
  }) {
    return GCard(
      shape ?? this.shape,
      color ?? this.color,
      value ?? this.value,
      isFaceUp ?? this.isFaceUp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GCard &&
        other.shape == shape &&
        other.color == color &&
        other.value == value;
  }

  @override
  int get hashCode {
    return shape.hashCode ^ color.hashCode ^ value.hashCode;
  }

  @override
  String toString() {
    return '${isFaceUp ? '*' : ''}${shape.name.substring(0, 1)}$value${isFaceUp ? '*' : ''}';
  }
}

enum SHAPE { SPADE, HEART, CLOVER, DIAMOND, ALL }

enum COLOR { RED, BLACK, ALL }
