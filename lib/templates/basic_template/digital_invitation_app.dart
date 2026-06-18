import 'package:flutter/material.dart';
import 'invitation_screen.dart';

class DigitalInvitationApp extends StatelessWidget {
  const DigitalInvitationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xFFFCFAF5),
      ),
      child: const InvitationScreen(),
    );
  }
}
