import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

class Joystick extends StatefulWidget {
  final double size;
  final void Function(Offset offset) onChanged;

  const Joystick({super.key, required this.onChanged, this.size = 100});

  @override
  State<Joystick> createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        Offset delta =
            details.localPosition - Offset(widget.size / 2, widget.size / 2);
        Offset clamped = Offset(
          (delta.dx / (widget.size / 2)).clamp(-1.0, 1.0),
          (delta.dy / (widget.size / 2)).clamp(-1.0, 1.0),
        );
        setState(() => offset = clamped);
        widget.onChanged(clamped);
      },
      onPanEnd: (_) {
        setState(() => offset = Offset.zero);
        widget.onChanged(offset);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: Center(
          child: Transform.translate(
            offset: offset * (widget.size / 4),
            child: Container(
              width: widget.size / 4,
              height: widget.size / 4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}