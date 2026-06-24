import 'package:flutter/material.dart';
import 'invitation_screen.dart';

class AdvanceThemeApp extends StatelessWidget {
  final bool isPreview;
  const AdvanceThemeApp({super.key, this.isPreview = true});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: const Color(0xFFFCFAF5),
      ),
      child: AdvanceInvitationScreen(isPreview: isPreview),
    );
  }
}
