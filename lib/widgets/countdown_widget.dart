import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownWidget extends StatefulWidget {
  final DateTime targetDate;

  const CountdownWidget({super.key, required this.targetDate});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    if (widget.targetDate.isAfter(now)) {
      setState(() {
        _timeLeft = widget.targetDate.difference(now);
      });
    } else {
      if (_timeLeft != Duration.zero) {
        setState(() {
          _timeLeft = Duration.zero;
        });
        _timer.cancel();
      }
    }
  }

  @override
  void dispose() {
    _timer.isActive ? _timer.cancel() : null;
    super.dispose();
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFD83076).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD83076).withOpacity(0.2)),
          ),
          child: Center(
            child: Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD83076),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeUnit(days.toString().padLeft(2, '0'), 'Days'),
          const SizedBox(width: 12),
          _buildTimeUnit(hours.toString().padLeft(2, '0'), 'Hrs'),
          const SizedBox(width: 12),
          _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'Mins'),
          const SizedBox(width: 12),
          _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'Secs'),
        ],
      ),
    );
  }
}
