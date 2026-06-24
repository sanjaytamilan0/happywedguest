import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class InvitationsSection extends StatelessWidget {
  final bool isDesktop;
  InvitationsSection({super.key, required this.isDesktop});

  final List<Map<String, String>> _invitations = [
    {'title': 'Kunal & Simran', 'templateId': 'multiview', 'status': 'Confirmed'},
    {'title': 'Akshay & Krishna', 'templateId': 'basic', 'status': 'Pending'},
    {'title': 'Kaveri & Gangadhar', 'templateId': 'digital', 'status': 'Declined'},
    {'title': 'Rohan & Priya', 'templateId': 'advance', 'status': 'Confirmed'},
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Invitations',
            style: GoogleFonts.cinzel(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8C8665),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _invitations.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final invitation = _invitations[index];
            return GestureDetector(
              onTap: () {
                String route;
                switch (invitation['templateId']) {
                  case 'multiview':
                    route = AppRoutes.MULTIVIEW_INVITATION;
                    break;
                  case 'digital':
                    route = AppRoutes.DIGITAL_INVITATION;
                    break;
                  case 'advance':
                    route = AppRoutes.ADVANCE_INVITATION;
                    break;
                  case 'basic':
                  default:
                    route = AppRoutes.INVITATION;
                }
                Get.toNamed(route);
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invitation['title']!,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(invitation['status']!).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getStatusColor(invitation['status']!).withOpacity(0.5)),
                          ),
                          child: Text(
                            invitation['status']!.toUpperCase(),
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(invitation['status']!),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
            );
          },
        ),
      ],
    );
  }
}
