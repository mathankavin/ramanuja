import 'package:camera/camera.dart';
import 'package:cometchat_sdk/models/call.dart';
import 'package:cometchat_sdk/models/group.dart';
import 'package:cometchat_sdk/models/user.dart';
import 'package:flutter/material.dart';

class ActiveVideoCallScreen extends StatefulWidget {
  final Call call;

  ActiveVideoCallScreen({required this.call});

  @override
  _ActiveCallScreenState createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveVideoCallScreen> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _cameraController!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String receiverName = 'Unknown';

    if (widget.call.receiver is User) {
      receiverName = (widget.call.receiver as User).name;
    } else if (widget.call.receiver is Group) {
      receiverName = (widget.call.receiver as Group).name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Active Call with $receiverName'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController!);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Text('In ${widget.call.type} Call with $receiverName'),
          ],
        ),
      ),
    );
  }
}
