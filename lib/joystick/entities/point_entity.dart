class PointEntity {
  double x = 0;
  double y = 0;
  PointEntity({
    required this.x,
    required this.y,
  });
  PointEntity.empty({
    this.x = 0,
    this.y = 0,
  });
}
