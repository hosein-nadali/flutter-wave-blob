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
    double cX = width / 2;
    double cY = height / 2;

    if (centerCircle && overCircle) {
      Paint paint = Paint()..style = PaintingStyle.fill;

      if (circleColors == null) {
        paint.color = Colors.blue;
      } else if (circleColors!.isEmpty) {
        paint.color = Colors.blue;
      } else if (circleColors!.length == 1) {
        paint.color = circleColors![0];
      } else {
        paint.shader = ui.Gradient.linear(
          const Offset(0.0, 0.0),
          Offset(width, height),
          circleColors!,
        );
      }

      canvas.save();
      canvas.drawCircle(Offset(cX, cY), waves[0].minRadius, paint);
      canvas.restore();
    }

    for (WaveDrawable wave in waves) {
      Paint paint = Paint()..style = PaintingStyle.fill;
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
      wave.draw(canvas, paint, Size(cX, cY));
      canvas.restore();
    }

    if (centerCircle && !overCircle) {
      Paint paint = Paint()..style = PaintingStyle.fill;

      if (circleColors == null) {
        paint.color = Colors.blue;
      } else if (circleColors!.isEmpty) {
        paint.color = Colors.blue;
      } else if (circleColors!.length == 1) {
        paint.color = circleColors![0];
      } else {
        paint.shader = ui.Gradient.linear(
          const Offset(0.0, 0.0),
          Offset(width, height),
          circleColors!,
        );
      }

      canvas.save();
      canvas.drawCircle(Offset(cX, cY), waves[0].minRadius, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
