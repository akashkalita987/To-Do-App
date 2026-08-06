class Point {
  double x;
  double y;

  Point(this.x, this.y);

  Point.origin() : x = 0, y = 0;
}

final p = Point.origin();
