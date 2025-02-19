import 'dart:math';

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String selectedModel =
      'https://models.readyplayer.me/65a8dba831b23abb4f401bae.glb';

  void switchModel(String modelUrl) {
    setState(() {
      selectedModel = modelUrl;
    });
  }

  final backgroundColors = [Colors.black, const Color(0xFFEEEEEE)];
  final _random = Random();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MViewer',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ModelViewer(
                key: UniqueKey(),
                backgroundColor:
                    backgroundColors[_random.nextInt(backgroundColors.length)],
                src: selectedModel,
                alt: 'A 3D Model',
                ar: true,
                autoRotate: true,
                disableZoom: true,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => switchModel(
                      'https://models.readyplayer.me/65a8dba831b23abb4f401bae.glb'),
                  child: const Text('Model 1'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => switchModel(
                      'https://modelviewer.dev/shared-assets/models/Astronaut.glb'),
                  child: const Text('Model 2'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
