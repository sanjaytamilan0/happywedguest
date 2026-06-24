import 'package:flutter/material.dart';
import 'invitation_screen.dart';

class DigitalInvitationApp extends StatelessWidget {
  final bool isPreview;
  const DigitalInvitationApp({super.key, this.isPreview = true});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xFFFCFAF5),
      ),
      child: InvitationScreen(isPreview: isPreview),
    );
  }
}
