import 'package:flutter/material.dart';

class DottedBorderDecoration extends Decoration {
  const DottedBorderDecoration({
    required this.borderRadius,
    required this.color,
  });

  final BorderRadius borderRadius;
  final Color color;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DottedBorderPainter(borderRadius: borderRadius, color: color);
  }
}

class _DottedBorderPainter extends BoxPainter {
  _DottedBorderPainter({required this.borderRadius, required this.color});

  static const double _strokeWidth = 1.5;
  static const double _dashLength = 6.0;
  static const double _gapLength = 4.0;

  final BorderRadius borderRadius;
  final Color color;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size ?? Size.zero;
    final rect = offset & size;
    final rRect = borderRadius.toRRect(rect);
    final path = Path()..addRRect(rRect);

    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    final dashPath = _createDashedPath(path);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source) {
    final dashedPath = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + _dashLength).clamp(0.0, metric.length);
        dashedPath.addPath(metric.extractPath(distance, end), Offset.zero);
        distance += _dashLength + _gapLength;
      }
    }
    return dashedPath;
  }
}
