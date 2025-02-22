import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_3d_controller/src/data/repositories/i_flutter_3d_repository.dart';
import 'repo/3d_repo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Flutter3DController controller = Flutter3DController();
  Flutter3DController chairController = Flutter3DController();
  List<String> animations = [];
  String? activeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the repository
    controller.init(MyFlutter3DRepository() as IFlutter3DRepository);
    chairController.init(MyFlutter3DRepository() as IFlutter3DRepository);
  }

  // This will fetch all the available animations of your model
  Future<void> _fetchAnimations() async {
    try {
      final availableAnimations = await controller.getAvailableAnimations();
      setState(() {
        animations = availableAnimations;
      });
    } catch (e) {
      print('Error fetching animations: $e');
    }
  }

  setActiveAnimation(String animation) {
    setState(() {
      activeAnimation = animation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Text(
            '3D Model Controller',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center, // Center the chair model
              child: Container(
                width: 130, // Set a specific width
                height: 400,
                margin: EdgeInsets.only(top: 57), // Set a specific height
                child: Flutter3DViewer(
                  activeGestureInterceptor: true,
                  progressBarColor: Colors.blue,
                  enableTouch: true,
                  onProgress: (double progressValue) {},
                  onLoad: (String modelAddress) {
                    chairController.onModelLoaded.value = true;
                  },
                  onError: (String error) {
                    print('Error loading chair model: $error');
                  },
                  controller: chairController,
                  src: 'assets/models/sheen_chair.glb',
                ),
              ),
            ),
            Align(
              alignment: Alignment.center, // Center the business man model
              child: Container(
                width: 200, // Set a specific width
                height: 400, // Set a specific height
                child: Flutter3DViewer(
                  activeGestureInterceptor: true,
                  progressBarColor: Colors.orange,
                  enableTouch: true,
                  onProgress: (double progressValue) {},
                  onLoad: (String modelAddress) {
                    controller.onModelLoaded.value = true;
                    _fetchAnimations();
                  },
                  onError: (String error) {
                    print('Error loading business man model: $error');
                  },
                  controller: controller,
                  src: 'assets/models/business_man.glb',
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.pause),
          onPressed: () {
            controller.pauseAnimation();
            chairController.pauseAnimation();
          },
        ),
        bottomNavigationBar: ValueListenableBuilder<bool>(
          valueListenable: controller.onModelLoaded,
          builder: (context, isModelLoaded, child) {
            if (!isModelLoaded) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SizedBox(
                height: 300, // Adjust the height as needed
                child: GridView.builder(
                  padding: EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Adjust the number of columns as needed
                    crossAxisSpacing:
                        5, // Adjust the horizontal spacing as needed
                    mainAxisSpacing: 2, // Adjust the vertical spacing as needed
                  ),
                  itemCount: animations.length,
                  itemBuilder: (context, index) {
                    String animation = animations[index];
                    bool isActive = activeAnimation == animation;
                    return GestureDetector(
                      onTap: () {
                        controller.playAnimation(animationName: animation);
                        setActiveAnimation(animation);
                      },
                      child: Chip(
                        backgroundColor: isActive ? Colors.black87 : null,
                        label: Text(
                          animation.substring(4).toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
