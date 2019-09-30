import 'package:camera/new/camera.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;


Future<Null> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(new Winterblick());
}


class Winterblick extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Winterblick',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: LandingPage(title: 'Winterblick'),
    );
  }
}

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _LandingPageState createState() => _LandingPageState(cameras);
}

class _LandingPageState extends State<LandingPage> {
  int _counter = 0;
  List<CameraDescription> cameras;

  CameraController _controller;
  Future<void> _initializeControllerFuture;


  _LandingPageState(this.cameras);

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }


  @override
  void initState() {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      cameras[0],
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
