import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class Utils {
  static final v.Matrix4 _matrix = v.Matrix4.identity();
  static final Random _random = Random();
  static const double maxAmplitude = 8500;
  static const double maxScale = 1.3;

  static int get randomNumber => _random.nextInt(1 << 32) - (1 << 31);

  static Shader createShader(
    double x,
    double y,
    List<Color>? colors, {
    double? angle,
  }) {
    return LinearGradient(
      tileMode: TileMode.clamp,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // transform: GradientRotation(angle ?? 10 / 10),
      colors: colors ??
          [
            const Color(0xff2BCEFF).withOpacity(0.3),
            const Color(0xff0976E3).withOpacity(0.3),
          ],
    ).createShader(
      Rect.fromCircle(center: Offset(x, y), radius: 50.0),
    );
  }

  static v.Vector4 transformPoint(
    v.Vector4 point,
    double cX,
    double cY,
    double degree,
  ) {
    _matrix.setIdentity();
    _matrix.translate(cX, cY);
    _matrix.rotateZ(v.radians(degree));
    _matrix.translate(-cX, -cY);
    return _matrix.transform(point);
  }
}
