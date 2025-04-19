import 'package:flutter/material.dart';
import 'package:roslibdart/roslibdart.dart';
import 'dart:math';
import 'dart:async';
import '../painters/boat_painter.dart';

class ControllerPage extends StatefulWidget {
  final String serverUri;

  const ControllerPage({super.key, required this.serverUri});

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  late Ros ros;
  late Topic rudderTopic;
  late Topic sailTopic;
  double rudderAngle = 0.0;
  double sailAngle = 45.0;
  Timer? _publishTimer;
  
  // Keep track of whether values changed since last publish
  bool _rudderChanged = false;
  bool _sailChanged = false;

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
    
    // Start periodic publisher
    _publishTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _publishCurrentValues();
    });
  }
  
  @override
  void dispose() {
    _publishTimer?.cancel();
    ros.close();
    super.dispose();
  }

  // This method publishes current values if they've changed
  void _publishCurrentValues() {
    if (_rudderChanged) {
      publish(rudderTopic, rudderAngle.toInt());
      _rudderChanged = false;
      print('Published rudder: ${rudderAngle.toInt()}');
    }
    
    if (_sailChanged) {
      publish(sailTopic, sailAngle.toInt());
      _sailChanged = false;
      print('Published sail: ${sailAngle.toInt()}');
    }
  }

  void publish(Topic topic, int angle) {
    topic.publish({'data': angle});
  }

  void handleRudderSlider(double value) {
    // Only update state, mark as changed
    setState(() {
      if (rudderAngle.toInt() != value.toInt()) {
        _rudderChanged = true;
      }
      rudderAngle = value;
    });
    print('Rudder angle updated: $value (will publish soon)');
  }

  void handleSailSlider(double value) {
    // Only update state, mark as changed
    setState(() {
      if (sailAngle.toInt() != value.toInt()) {
        _sailChanged = true;
      }
      sailAngle = value;
    });
    print('Sail angle updated: $value (will publish soon)');
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
          Slider(
            value: rudderAngle, 
            min: -25,
            max: 25,
            onChanged: handleRudderSlider, 
            onChangeEnd: (value) {
              // jump to neutral (0) after releasing the slider
              handleRudderSlider(0);
            },
          ),
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