import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:happywed_guest/templates/basic_template/digital_invitation_app.dart';
import '../widgets/rsvp_card.dart';
import '../widgets/ceremony_card.dart';
import '../widgets/host_family_section.dart';

class HomeView extends StatelessWidget {
  final bool isDesktop;

  const HomeView({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const RsvpCard(guestName: 'sanjay'),
                  const SizedBox(height: 48),
                  const HostFamilySection(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: SizedBox(
                height: 600,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Navigator(
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(
                        builder: (_) => const DigitalInvitationApp(isPreview: true),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const RsvpCard(guestName: 'sanjay'),
          const SizedBox(height: 48),
          // Bounded preview box to replace CeremonyCard
          SizedBox(
            height: 600,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (_) => const DigitalInvitationApp(),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 48),
          const HostFamilySection(),
        ],
      );
    }
  }
}
