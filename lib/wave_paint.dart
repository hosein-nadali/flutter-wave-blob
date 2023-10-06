library wave_blob;

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:wave_blob/wave_drawable.dart';

class WavePaint extends CustomPainter {
  final List<WaveDrawable> waves;
  final double height;
  final double width;
  final double scale;
  final double speed;
  final double amplitude;
  final bool autoScale;
  final bool overCircle;
  final bool centerCircle;
  final List<Color>? colors;
  final List<Color>? circleColors;

  WavePaint({
    required this.waves,
    required this.colors,
    required this.width,
    required this.height,
    required this.scale,
    required this.speed,
    required this.amplitude,
    required this.autoScale,
    required this.overCircle,
    required this.centerCircle,
    required this.circleColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint cPaint = Paint()..style = PaintingStyle.fill;
    Paint bPaint = Paint()..style = PaintingStyle.fill;

    double cX = width / 2;
    double cY = height / 2;

    if (circleColors == null) {
      cPaint.color = Colors.blue;
    } else if (circleColors!.isEmpty) {
      cPaint.color = Colors.blue;
    } else if (circleColors!.length == 1) {
      cPaint.color = circleColors![0];
    } else {
      cPaint.shader = ui.Gradient.linear(
        const Offset(0.0, 0.0),
        Offset(width, height),
        circleColors!,
      );
    }

    if (centerCircle && overCircle) {
      canvas.save();
      canvas.drawCircle(Offset(cX, cY), waves[0].minRadius, cPaint);
      canvas.restore();
    }

    for (WaveDrawable wave in waves) {
      if (wave.maxRadius < 0) {
        double max = width / 2 / 1.25;
        wave.setMaxRadius(max);
      }
      if (wave.minRadius < 0) {
        double min = width / 2 / 1.5;
        wave.setMinRadius(min);
      }

      wave.setAmplitude(amplitude);
      wave.setScale(scale);
      wave.setMaxSpeed(speed);
      wave.setAutoScale(autoScale);

      if (colors != null) {
        wave.setColors(colors!);
      }

      canvas.save();
      wave.draw(canvas, bPaint, Size(cX, cY));
      canvas.restore();
    }

    if (centerCircle && !overCircle) {
      canvas.save();
      canvas.drawCircle(Offset(cX, cY), waves[0].minRadius, cPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
