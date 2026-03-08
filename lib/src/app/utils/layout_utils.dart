import 'package:flutter/material.dart';

double getResponsiveMaxWidth(
  BuildContext context, {
  double mobileFraction = 0.95,
  double webFraction = 0.5,
  double webBreakpoint = 600.0,
}) {
  final width = MediaQuery.of(context).size.width;
  if (width < webBreakpoint) {
    return width * mobileFraction;
  } else {
    return width * webFraction;
  }
}
