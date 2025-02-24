enum BoardSize {
  b9x9,
  b13x13,
  b19x19;

  static List<BoardSize> boardSizes = [
    BoardSize.b9x9,
    BoardSize.b13x13,
    BoardSize.b19x19,
  ];

  @override
  String toString() {
    switch (this) {
      case BoardSize.b9x9:
        return '9x9';
      case BoardSize.b13x13:
        return '13x13';
      case BoardSize.b19x19:
        return '19x19';
    }
  }
}
