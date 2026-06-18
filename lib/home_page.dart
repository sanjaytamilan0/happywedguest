import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/nav_provider.dart';
import 'widgets/top_nav.dart';
import 'views/home_view.dart';
import 'views/profile_view.dart';
import 'views/gallery_view.dart';
import 'views/links_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(navTabProvider);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;

          return Stack(
            children: [
              // Main Scrollable Content
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 48,
                  bottom: 48, // space for bottom action bar removed
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header Logo / Text
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // Top Pill Navigation
                    const TopNavBar(),
                    const SizedBox(height: 48),

                    // Responsive Main Content Layout
                    Builder(
                      builder: (context) {
                        switch (currentTab) {
                          case NavTab.profile:
                            return ProfileView(isDesktop: isDesktop);
                          case NavTab.gallery:
                            return GalleryView(isDesktop: isDesktop);
                          case NavTab.links:
                            return LinksView(isDesktop: isDesktop);
                          case NavTab.home:
                            return HomeView(isDesktop: isDesktop);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.diamond_outlined, size: 16, color: Colors.amber[700]),
            const SizedBox(width: 8),
            Icon(Icons.favorite, size: 16, color: Colors.amber[700]),
            const SizedBox(width: 8),
            Icon(Icons.diamond_outlined, size: 16, color: Colors.amber[700]),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Udaya',
          style: GoogleFonts.greatVibes(
            fontSize: 64,
            color: const Color(0xFFD83076),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Celebrating the Union of',
          style: GoogleFonts.lora(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '&',
          style: GoogleFonts.greatVibes(
            fontSize: 24,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
