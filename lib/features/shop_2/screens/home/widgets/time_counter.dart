import 'dart:async';
import 'package:flutter/material.dart';

class TSaleCountdown extends StatefulWidget {
  final DateTime endTime;
  const TSaleCountdown({super.key, required this.endTime});

  @override
  State<TSaleCountdown> createState() => _TSaleCountdownState();
}

class _TSaleCountdownState extends State<TSaleCountdown> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.endTime.difference(DateTime.now());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (widget.endTime.isBefore(now)) {
        _timer.cancel();
        setState(() {
          _timeLeft = Duration.zero;
        });
      } else {
        setState(() {
          _timeLeft = widget.endTime.difference(now);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.timer, size: 20, color: Colors.red),
        const SizedBox(width: 6),
        Text(
          'Sale ends in: ${_formatDuration(_timeLeft)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
