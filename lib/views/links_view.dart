import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../templates/basic_template/digital_invitation_app.dart';
import '../templates/digital_template/digital_invitation_app.dart';
import '../templates/advance_template/digital_invitation_app.dart';
import '../templates/multiview_template/multiview_app.dart';

class LinksView extends StatelessWidget {
  final bool isDesktop;

  const LinksView({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : 1,
              childAspectRatio: isDesktop ? 0.55 : 0.6, // Perfect phone aspect ratio
              crossAxisSpacing: 32,
              mainAxisSpacing: 48,
            ),
            itemCount: 4, // Show 4 live preview cards
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildLivePreviewCard(
                  context,
                  title: 'Kunal & Simran',
                  appWidget: const MultiviewThemeApp(isPreview: true),
                  route: AppRoutes.MULTIVIEW_INVITATION,
                );
              } else if (index == 1) {
                return _buildLivePreviewCard(
                  context,
                  title: 'Akshay & Krishna',
                  appWidget: const DigitalInvitationApp(isPreview: true),
                  route: AppRoutes.INVITATION,
                );
              } else if (index == 2) {
                return _buildLivePreviewCard(
                  context,
                  title: 'Kaveri & Gangadhar',
                  appWidget: const DigitalThemeApp(isPreview: true),
                  route: AppRoutes.DIGITAL_INVITATION,
                );
              } else {
                return _buildLivePreviewCard(
                  context,
                  title: 'Rohan & Priya',
                  appWidget: const AdvanceThemeApp(isPreview: true),
                  route: AppRoutes.ADVANCE_INVITATION,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLivePreviewCard(
    BuildContext context, {
    required String title,
    required Widget appWidget,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AbsorbPointer(
                child: FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 400,
                    height: 800,
                    child: Navigator(
                      onGenerateRoute: (settings) {
                        return MaterialPageRoute(
                          builder: (_) => appWidget,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
