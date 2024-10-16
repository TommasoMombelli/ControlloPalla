class Coord {
  final double x;
  final double y;

  Coord({required this.x, required this.y});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      x: json['x'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '"x"': x.toStringAsFixed(2),
      '"y"': y.toStringAsFixed(2),
    };
  }

  @override
  String toString() {
    return 'x: $x, y: $y';
  }
}
