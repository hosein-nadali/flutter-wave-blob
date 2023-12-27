import 'package:flutter/material.dart';
import 'package:wave_blob/wave_blob.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _scale = 1.0;
  double _amplitude = 4250.0;

  bool _autoScale = true;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Timer.periodic(const Duration(milliseconds: 50), (timer) {
    //     setState(() {});
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blob Wave Animation',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 27, 34, 42),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Amplitude'),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: Slider(
                  value: _amplitude,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.lightBlueAccent.withOpacity(0.2),
                  min: 0.0,
                  max: 8500.0,
                  onChanged: (v) {
                    _amplitude = v;
                  },
                ),
              ),
              const Text('Scale'),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _scale,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.lightBlueAccent.withOpacity(0.2),
                        min: 1.0,
                        max: 1.3,
                        onChanged: (v) {
                          setState(() => _scale = v);
                        },
                      ),
                    ),
                    Checkbox(
                      value: _autoScale,
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                      onChanged: (v) {
                        _autoScale = v!;
                      },
                    ),
                    const Text('Auto'),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: MediaQuery.sizeOf(context).width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: WaveBlob(
                  blobCount: 2,
                  amplitude: _amplitude,
                  scale: _scale,
                  autoScale: _autoScale,
                  centerCircle: true,
                  overCircle: true,
                  circleColors: const [
                    /// If you don't want use Gradient, set just one color
                    Colors.blue,
                  ],
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 50.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
