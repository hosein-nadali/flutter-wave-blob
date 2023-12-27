import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wave_blob/wave_drawable.dart';
import 'package:wave_blob/wave_paint.dart';

class WaveBlob extends StatefulWidget {
  final Widget child;

  /// Scale of blobs. It just work when autoScale sets to false
  final double scale;

  /// Speed of blob animation. Between 1.0 to 10.0
  final double speed;

  /// Amplitude of blobs. Between 0.0 to 8500.0
  final double amplitude;

  /// Number of blobs. Between 1 to 5
  final int blobCount;

  /// If sets to True, blobs scale automatically. Default sets to True
  final bool autoScale;

  /// Sets true to draw blobs over center circle
  final bool overCircle;

  /// Status of center circle
  final bool centerCircle;

  /// Gradient color of blobs
  final List<Color>? colors;

  /// Color of center circle. Sets two or more colors for gradient
  final List<Color>? circleColors;

  const WaveBlob({
    super.key,
    required this.child,
    this.scale = 1.0,
    this.speed = 8.6,
    this.amplitude = 4250.0,
    this.blobCount = 2,
    this.autoScale = true,
    this.overCircle = true,
    this.centerCircle = true,
    this.circleColors,
    this.colors,
  });

  @override
  State<WaveBlob> createState() => _WaveBlobState();
}

class _WaveBlobState extends State<WaveBlob> {
  List<WaveDrawable> blobs = [];

  @override
  void initState() {
    super.initState();

    var length = widget.blobCount > 5 ? 5 : widget.blobCount;
    for (int i = 0; i < length; i++) {
      blobs.add(WaveDrawable(8 + i));
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool hasInfiniteDimension = (constraints.maxWidth == double.infinity ||
            constraints.maxHeight == double.infinity);

        if (hasInfiniteDimension) {
          ErrorWidget.builder = (error) => Container();
          throw ("Can't get infinite width or height. Please set dimensions for BlobWave widget");
        }

        return CustomPaint(
          painter: WavePaint(
            waves: blobs,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            scale: widget.scale,
            amplitude: widget.amplitude,
            autoScale: widget.autoScale,
            overCircle: widget.overCircle,
            centerCircle: widget.centerCircle,
            circleColors: widget.circleColors,
            colors: widget.colors,
            speed: widget.speed,
          ),
          child: widget.child,
        );
      },
    );
  }
}
