class TimeControl {
  final int initialTime;
  final int increment;

  static TimeControl defaultTimeControl = TimeControl(10, 0);

  static List<TimeControl> timeControls = [
    TimeControl(1, 0),
    TimeControl(1, 1),
    TimeControl(2, 1),
    TimeControl(5, 0),
    TimeControl(5, 5),
    TimeControl(10, 0),
    TimeControl(10, 5),
    TimeControl(15, 10),
    TimeControl(30, 0),
    TimeControl(60, 0),
  ];

  TimeControl(this.initialTime, this.increment);

  @override
  String toString() {
    return '$initialTime min${increment > 0 ? ' | $increment sec' : ''}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeControl &&
          runtimeType == other.runtimeType &&
          initialTime == other.initialTime &&
          increment == other.increment;

  @override
  int get hashCode => initialTime.hashCode ^ increment.hashCode;
}
