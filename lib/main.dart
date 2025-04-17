import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:roslibdart/roslibdart.dart';

import 'widgets/joystick.dart'; 
import 'painters/boat_painter.dart'; 
import 'themes/marine_theme.dart';

void main() {
  runApp(const SailboatApp());
}

class SailboatApp extends StatelessWidget {
  const SailboatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sailboat Controller',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      //   useMaterial3: true,
      // ),
      theme: marineTheme,

      home: const ServerInputPage(),
    );
  }
}

class ServerInputPage extends StatefulWidget {
  const ServerInputPage({super.key});

  @override
  State<ServerInputPage> createState() => _ServerInputPageState();
}

class _ServerInputPageState extends State<ServerInputPage> {
  final _controller = TextEditingController(text: 'ws://localhost:9090');

  void _connect() {
    final uri = _controller.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ControllerPage(serverUri: uri)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect to ROSBridge')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
                        Image.asset(
              'assets/images/justbigword.png',
              height: 100,
            ),
            const SizedBox(height: 20),

            const Text(
              'Enter ROSBridge WebSocket URL',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ws://<ip>:9090',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _connect, child: const Text('Connect')),
          ],
        ),
      ),
    );
  }
}

class ControllerPage extends StatefulWidget {
  final String serverUri;

  const ControllerPage({super.key, required this.serverUri});

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  late WebSocketChannel _channel;
  late Ros ros;
  late Topic rudderTopic;
  late Topic sailTopic;
  double rudderAngle = 0.0;
  double sailAngle = 45.0;

  @override
  void initState() {
    super.initState();
    ros = Ros(url: widget.serverUri);
    ros.connect();

    rudderTopic = Topic(
      ros: ros,
      name: '/sailbot/controller_app_rudder',
      type: 'std_msgs/Int32',
    );

    sailTopic = Topic(
      ros: ros,
      name: '/sailbot/controller_app_sail',
      type: 'std_msgs/Int32',
    );
  }

  void publish(Topic topic, int angle) {
    topic.publish({'data': angle});
  }

  void handleJoystickUpdate(Offset offset) {
    double angle = (offset.dx * 25).clamp(-25.0, 25.0);
    setState(() => rudderAngle = angle);
    publish(rudderTopic, angle.toInt());
  }

  void handleSailSlider(double value) {
    setState(() => sailAngle = value);
    publish(sailTopic, value.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sailboat Controller')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: CustomPaint(
              painter: BoatPainter(
                rudderAngle: rudderAngle,
                sailAngle: sailAngle,
              ),
              child: Container(),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Rudder Control', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Joystick(onChanged: handleJoystickUpdate, size: 150),
          Text('Rudder: ${rudderAngle.toStringAsFixed(1)}°'),
          const SizedBox(height: 30),
          const Text('Sail Control', style: TextStyle(fontSize: 16)),
          Slider(
            value: sailAngle,
            min: 0,
            max: 90,
            onChanged: handleSailSlider,
          ),
          Text('Sail: ${sailAngle.toStringAsFixed(1)}°'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

