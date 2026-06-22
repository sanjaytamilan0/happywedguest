import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

// Provider to track if the user has clicked the ceremony card in this session
class HasClickedCeremonyNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setClicked() {
    state = true;
  }
}

final hasClickedCeremonyProvider = NotifierProvider<HasClickedCeremonyNotifier, bool>(() {
  return HasClickedCeremonyNotifier();
});

class CeremonyCard extends ConsumerStatefulWidget {
  const CeremonyCard({super.key});

  @override
  ConsumerState<CeremonyCard> createState() => _CeremonyCardState();
}

class _CeremonyCardState extends ConsumerState<CeremonyCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasClicked = ref.watch(hasClickedCeremonyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 24.0),
          child: Text(
            'Ceremony Schedule',
            style: GoogleFonts.lora(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (!hasClicked) {
              ref.read(hasClickedCeremonyProvider.notifier).setClicked();
            }
            Get.toNamed(AppRoutes.INVITATION);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://placehold.co/800x600/png?text=Wedding',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Haldhi',
                      style: GoogleFonts.lora(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Animated "Tap Here" guidance overlay
              if (!hasClicked)
                Positioned(
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.touch_app, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Tap to open invitation!',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
