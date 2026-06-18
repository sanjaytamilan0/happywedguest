import 'package:flutter/material.dart';
import '../widgets/rsvp_card.dart';
import '../widgets/ceremony_card.dart';

class HomeView extends StatelessWidget {
  final bool isDesktop;

  const HomeView({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: RsvpCard(guestName: 'sanjay'),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: const CeremonyCard(),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: const [
          RsvpCard(guestName: 'sanjay'),
          SizedBox(height: 48),
          CeremonyCard(),
        ],
      );
    }
  }
}
