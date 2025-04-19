import 'package:flutter/material.dart';
import 'controller_page.dart';

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