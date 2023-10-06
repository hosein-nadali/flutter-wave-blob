import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:wave_blob/utils.dart';

class WaveDrawable {
  final int N;

  final Path _path = Path();
  final double _minSpeed = 0.8;

  late List<double> _radius;
  late List<double> _angle;
  late List<double> _radiusNext;
  late List<double> _angleNext;
  late List<double> _progress;
  late List<double> _speed;

  late final double L;

  bool _stub = true;
  bool _autoScale = true;
  double _scale = 1.0;
  double _maxSpeed = 8.2;
  double _minRadius = -1;
  double _maxRadius = -1;
  double _amplitude = 0.0;
  double _animateToAmplitude = 0.0;
  double _animateAmplitudeDiff = 0.0;
  double _lastStubUpdateAmplitude = 0.0;
  List<Color>? _colors;

  WaveDrawable(this.N) {
    L = (4.0 / 3.0) * tan(pi / (2 * N));

    _radius = List.filled(N, 0.0);
    _angle = List.filled(N, 0.0);
    _radiusNext = List.filled(N, 0.0);
    _angleNext = List.filled(N, 0.0);
    _progress = List.filled(N, 0.0);
    _speed = List.filled(N, 0.0);

    for (int i = 0; i < N; i++) {
      _generateBlob(_radius, _angle, i);
      _generateBlob(_radiusNext, _angleNext, i);
      _progress[i] = 0;
    }
  }

  double get maxRadius => _maxRadius;
  double get minRadius => _minRadius;
  double get maxSpeed => _maxSpeed;
  double get minSpeed => _minSpeed;

  void draw(Canvas canvas, Paint paint, Size size) {
    final double cX = size.width;
    final double cY = size.height;

    paint.shader = Utils.createShader(cX, cY, _colors, angle: _angle[0]);

    _path.reset();

    if (_stub) _loadStubWaves();

    if (_animateToAmplitude != _amplitude) {
      _amplitude += _animateAmplitudeDiff * 16;
      if (_animateAmplitudeDiff > 0) {
        if (_amplitude > _animateToAmplitude) {
          _amplitude = _animateToAmplitude;
        }
      } else {
        if (_amplitude < _animateToAmplitude) {
          _amplitude = _animateToAmplitude;
        }
      }
    }

    _update(_amplitude, _stub ? 0.1 : 0.8);

    for (int i = 0; i < N; i++) {
      List<v.Vector4> pointStart = [];
      List<v.Vector4> pointEnd = [];

      double progress = _progress[i];
      int nextIndex = i + 1 < N ? i + 1 : 0;
      double progressNext = _progress[nextIndex];
      double r1 = _radius[i] * (1.0 - progress) + _radiusNext[i] * progress;
      double r2 = _radius[nextIndex] * (1.0 - progressNext) +
          _radiusNext[nextIndex] * progressNext;
      double angle1 = _angle[i] * (1.0 - progress) + _angleNext[i] * progress;
      double angle2 = _angle[nextIndex] * (1 - progressNext) +
          _angleNext[nextIndex] * progressNext;

      double l = L * (min(r1, r2) + (max(r1, r2) - min(r1, r2)) / 2.0);

      var sp1 = Utils.transformPoint(
          v.Vector4(cX, cY - r1, 0.0, 1.0), cX, cY, angle1);
      pointStart.add(sp1);

      var sp2 = Utils.transformPoint(
          v.Vector4(cX + l, cY - r1, 0.0, 1.0), cX, cY, angle1);
      pointStart.add(sp2);

      var ep1 = Utils.transformPoint(
          v.Vector4(cX, cY - r2, 0.0, 1.0), cX, cY, angle2);
      pointEnd.add(ep1);

      var ep2 = Utils.transformPoint(
          v.Vector4(cX - l, cY - r2, 0.0, 1.0), cX, cY, angle2);
      pointEnd.add(ep2);

      if (i == 0) {
        _path.moveTo(pointStart[0].x, pointStart[0].y);
      }

      _path.cubicTo(
        pointStart[1].x,
        pointStart[1].y,
        pointEnd[1].x,
        pointEnd[1].y,
        pointEnd[0].x,
        pointEnd[0].y,
      );
    }

    canvas.save();
    canvas.translate(cX, cY);
    canvas.scale(_autoScale ? _findWaveScale() : _scale);
    canvas.translate(-cX, -cY);
    canvas.drawPath(_path, paint);
    canvas.restore();
  }

  ///
  ///  git remote add origin https://github.com/hosein-nadali/flutter-wave-blob.git
  /// git branch -M main
  /// git push -u origin main
  ///

  void setMaxRadius(double maxRadius) {
    _maxRadius = maxRadius;
  }

  void setMinRadius(double minRadius) {
    _minRadius = minRadius;
  }

  void setAutoScale(bool autoScale) {
    _autoScale = autoScale;
  }

  void setScale(double scale) {
    _scale = min(scale, Utils.maxScale);
    _scale = max(scale, 1.0);
  }

  void setMaxSpeed(double maxSpeed) {
    _maxSpeed = min(maxSpeed, 10.0);
    _maxSpeed = max(maxSpeed, 1.0);
  }

  void setAmplitude(double value) {
    _stub = false;
    _animateToAmplitude = min(Utils.maxAmplitude, value) / Utils.maxAmplitude;
    _animateAmplitudeDiff =
        (_animateToAmplitude - _amplitude) / (100 + 500.0 * 0.33);
  }

  void setColors(List<Color> colors) {
    _colors = colors;
  }

  void _generateBlob(List<double> r, List<double> a, int i) {
    double angleDif = 360 / N * 0.05;
    double radDif = _maxRadius - _minRadius;
    r[i] = _minRadius + ((Utils.randomNumber % 100) / 100).abs() * radDif;
    a[i] = 360 / N * i + ((Utils.randomNumber % 100) / 100) * angleDif;
    _speed[i] = (0.017 + 0.003 * ((Utils.randomNumber % 100).abs() / 100));
  }

  void _update(double amplitude, double speedScale) {
    for (int i = 0; i < N; i++) {
      _progress[i] += (_speed[i] * _minSpeed) +
          amplitude * _speed[i] * _maxSpeed * speedScale;
      if (_progress[i] >= 1) {
        _progress[i] = 0;
        _radius[i] = _radiusNext[i];
        _angle[i] = _angleNext[i];
        _generateBlob(_radiusNext, _angleNext, i);
      }
    }
  }

  void _loadStubWaves() {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - _lastStubUpdateAmplitude > 1000) {
      _lastStubUpdateAmplitude = currentTime.toDouble();
      _animateToAmplitude = 0.5 + 0.5 * (Utils.randomNumber % 100).abs() / 100;
      _animateAmplitudeDiff =
          (_animateToAmplitude - _amplitude) / (100 + 1500.0 * 0.33);
    }
  }

  double _findWaveScale() {
    return min(1.3, 1.0 + 0.26 * _amplitude);
  }
}
