import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_routes.dart';
import '../templates/basic_template/invitation_screen.dart';
import '../templates/basic_template/reception_screen.dart';
import '../templates/basic_template/wedding_screen.dart';
import '../widgets/host_family_section.dart';
import '../widgets/home_gallery_section.dart';
import '../widgets/wish_board_section.dart';
import '../widgets/wedding_contact_section.dart';
import 'gallery_view.dart';

class HomeView extends StatelessWidget {
  final bool isDesktop;

  const HomeView({super.key, required this.isDesktop});

  Widget _buildScreenBox(BuildContext context, Widget child, String route) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width > size.height ? size.height * 0.5 : size.width;
    
    return GestureDetector(
      onTap: () {
        Get.toNamed(route);
      },
      child: SizedBox(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width > size.height ? size.height * 0.5 : size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Text(
            'Ceremonies',
            style: GoogleFonts.cinzel(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8C8665),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 24,
          runSpacing: 24,
          children: [
            _buildScreenBox(
              context,
              const InvitationScreen(isPreview: false),
              AppRoutes.INVITATION,
            ),
            _buildScreenBox(
              context,
              const ReceptionScreen(isPreview: false),
              AppRoutes.RECEPTION,
            ),
            _buildScreenBox(
              context,
              const WeddingScreen(isPreview: false),
              AppRoutes.WEDDING,
            ),
          ],
        ),
        
        const SizedBox(height: 48),
        
        Center(
          child: SizedBox(
            width: screenWidth,
            child: const HostFamilySection(),
          ),
        ),
        const SizedBox(height: 48),
        Center(
          child: HomeGallerySection(isDesktop: isDesktop),
        ),
        const SizedBox(height: 48),
        Center(
          child: WishBoardSection(isDesktop: isDesktop),
        ),
        const SizedBox(height: 48),
        Center(
          child: WeddingContactSection(isDesktop: isDesktop),
        ),
        const SizedBox(height: 48),
        Center(
          child: GalleryView(isDesktop: isDesktop),
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
