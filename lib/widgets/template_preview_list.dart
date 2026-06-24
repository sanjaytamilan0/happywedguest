import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

// Basic
import '../templates/basic_template/digital_invitation_app.dart' as basic_inv;
import '../templates/basic_template/reception_screen.dart' as basic_rec;
import '../templates/basic_template/wedding_screen.dart' as basic_wed;

// Digital
import '../templates/digital_template/digital_invitation_app.dart' as digital_inv;
import '../templates/digital_template/reception_screen.dart' as digital_rec;
import '../templates/digital_template/wedding_screen.dart' as digital_wed;

// Advance
import '../templates/advance_template/digital_invitation_app.dart' as advance_inv;
import '../templates/advance_template/reception_screen.dart' as advance_rec;
import '../templates/advance_template/wedding_screen.dart' as advance_wed;

// Multiview
import '../templates/multiview_template/multiview_app.dart';

class TemplatePreviewList extends StatelessWidget {
  final String templateId;

  const TemplatePreviewList({super.key, required this.templateId});

  Widget _buildScreenBox(BuildContext context, {required String title, required Widget child, required String route}) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width > size.height ? size.height * 0.5 : size.width;
    
    return GestureDetector(
      onTap: () {
        Get.toNamed(route);
      },
      child: Column(
        children: [
          SizedBox(
            width: screenWidth,
            height: 600,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Theme(
                data: ThemeData(scaffoldBackgroundColor: const Color(0xFFFCFAF5)),
                child: AbsorbPointer(
                  child: Navigator(
                    key: ValueKey(route),
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(
                        builder: (_) => child,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
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

  @override
  Widget build(BuildContext context) {
    if (templateId == 'multiview') {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 24,
        runSpacing: 48,
        children: [
          _buildScreenBox(
            context,
            title: 'Full Ceremony (Multiview)',
            child: const MultiviewThemeApp(isPreview: false),
            route: AppRoutes.MULTIVIEW_INVITATION,
          ),
        ],
      );
    } else if (templateId == 'basic') {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 24,
        runSpacing: 48,
        children: [
          _buildScreenBox(context, title: 'Invitation', child: const basic_inv.DigitalInvitationApp(isPreview: false), route: AppRoutes.INVITATION),
          _buildScreenBox(context, title: 'Reception', child: const basic_rec.ReceptionScreen(isPreview: false), route: AppRoutes.RECEPTION),
          _buildScreenBox(context, title: 'Wedding', child: const basic_wed.WeddingScreen(isPreview: false), route: AppRoutes.WEDDING),
        ],
      );
    } else if (templateId == 'digital') {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 24,
        runSpacing: 48,
        children: [
          _buildScreenBox(context, title: 'Invitation', child: const digital_inv.DigitalThemeApp(isPreview: false), route: AppRoutes.DIGITAL_INVITATION),
          _buildScreenBox(context, title: 'Reception', child: const digital_rec.DigitalReceptionScreen(isPreview: false), route: AppRoutes.DIGITAL_RECEPTION),
          _buildScreenBox(context, title: 'Wedding', child: const digital_wed.DigitalWeddingScreen(isPreview: false), route: AppRoutes.DIGITAL_WEDDING),
        ],
      );
    } else if (templateId == 'advance') {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 24,
        runSpacing: 48,
        children: [
          _buildScreenBox(context, title: 'Invitation', child: const advance_inv.AdvanceThemeApp(isPreview: false), route: AppRoutes.ADVANCE_INVITATION),
          _buildScreenBox(context, title: 'Reception', child: const advance_rec.AdvanceReceptionScreen(isPreview: false), route: AppRoutes.ADVANCE_RECEPTION),
          _buildScreenBox(context, title: 'Wedding', child: const advance_wed.AdvanceWeddingScreen(isPreview: false), route: AppRoutes.ADVANCE_WEDDING),
        ],
      );
    }
    return const SizedBox();
  }
}
