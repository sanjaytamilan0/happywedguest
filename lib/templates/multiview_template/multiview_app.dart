import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiviewThemeApp extends StatelessWidget {
  final bool isPreview;
  const MultiviewThemeApp({super.key, this.isPreview = false});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF06292)),
        useMaterial3: true,
      ),
      child: InviteScreen(isPreview: isPreview),
    );
  }
}

class InviteScreen extends StatefulWidget {
  final bool isPreview;
  const InviteScreen({super.key, this.isPreview = false});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _kSlideAnimation;
  late Animation<Offset> _sSlideAnimation;
  late Animation<double> _borderFadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _bottomTextSlideAnimation;
  late Animation<double> _rightLineDrawAnimation;

  // Outro Animation (triggers when everything is done)
  late AnimationController _outroController;
  late Animation<double> _outroScaleAnimation;
  late Animation<Offset> _outroSlideAnimation;
  late Animation<double> _outroFadeAnimation;

  // Final Details Animation (triggers after outro)
  late AnimationController _detailsController;
  late Animation<double> _detailsFadeAnimation;
  late Animation<Offset> _detailsSlideAnimation;
  late Animation<Offset> _kunalSlideAnimation;
  late Animation<Offset> _simranSlideAnimation;
  late Animation<double> _namesFadeAnimation;

  // Phase 4: Final Outro (zooms in, moves bottom, hides)
  late AnimationController _finalOutroController;
  late Animation<double> _finalOutroScaleAnimation;
  late Animation<Offset> _finalOutroSlideAnimation;
  late Animation<double> _finalOutroFadeAnimation;

  // Phase 5: Carnival of Love Screen
  late AnimationController _carnivalController;
  late Animation<Offset> _carnivalTitleSlide;
  late Animation<Offset> _carnivalBodySlide;
  late Animation<double> _carnivalFade;

  // Phase 6: Carnival Exit
  late AnimationController _carnivalExitController;
  late Animation<double> _carnivalExitScale;
  late Animation<Offset> _carnivalExitSlide;
  late Animation<double> _carnivalExitFade;

  // Phase 7: Swad Rajasthan Ro Screen
  late AnimationController _swadController;
  late Animation<Offset> _swadTitleSlide;
  late Animation<Offset> _swadBodySlide;
  late Animation<double> _swadFade;

  // Phase 8: Swad Exit
  late AnimationController _swadExitController;
  late Animation<double> _swadExitScale;
  late Animation<Offset> _swadExitSlide;
  late Animation<double> _swadExitFade;

  // Phase 9: RSVP Screen
  late AnimationController _rsvpController;
  late List<Animation<Offset>> _rsvpSlides;
  late List<Animation<double>> _rsvpFades;

  @override
  void initState() {
    super.initState();
    // Phase 1 (Logo buildup and Bedi family text)
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 7000));

    // Phase 2 (Outro: zoom in, move top, hide)
    _outroController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

    // Phase 3 (Final Details fade in)
    _detailsController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

    // Phase 4 (Final screen hide)
    _finalOutroController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

    // Start Phase 2 when Phase 1 finishes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _outroController.forward();
      }
    });

    // Start Phase 3 when Phase 2 finishes
    _outroController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _detailsController.forward();
      }
    });

    // Start Phase 4 a few seconds after Phase 3 finishes so the user can read the text
    _detailsController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            _finalOutroController.forward();
          }
        });
      }
    });

    // K slides from left
    _kSlideAnimation = Tween<Offset>(begin: const Offset(-10.0, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic)),
    );

    // S slides from right
    _sSlideAnimation = Tween<Offset>(begin: const Offset(10.0, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic)),
    );

    // Border (left side and main circle) fades in AFTER the right side line draws
    _borderFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.55, 0.8, curve: Curves.easeIn)),
    );

    // Remaining text fades in VERY slowly over the remaining time
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeIn)),
    );

    // Bottom text slides up from the bottom while fading in
    _bottomTextSlideAnimation = Tween<Offset>(begin: const Offset(0.0, 1.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.8, 1.0, curve: Curves.easeOutCubic)),
    );

    // Right side line and leaves reveal animation starts immediately after KS finishes
    _rightLineDrawAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.55, curve: Curves.easeInOut)),
    );

    // --- OUTRO ANIMATIONS ---
    // Zoom in 40% (scale to 1.4)
    _outroScaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _outroController, curve: Curves.easeInOutCubic),
    );

    // Move to the top (slide up)
    _outroSlideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.5)).animate(
      CurvedAnimation(parent: _outroController, curve: Curves.easeInOutCubic),
    );

    // Hide (fade out)
    _outroFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _outroController, curve: Curves.easeOut),
    );

    // --- DETAILS ANIMATION ---
    _detailsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _detailsController, curve: Curves.easeIn),
    );
    _detailsSlideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _detailsController, curve: Curves.easeOutCubic),
    );

    // Names slide in from left and right, starting from higher up, and slower
    _kunalSlideAnimation = Tween<Offset>(begin: const Offset(-2.0, -1.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _detailsController, curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)),
    );
    _simranSlideAnimation = Tween<Offset>(begin: const Offset(2.0, -1.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _detailsController, curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic)),
    );
    _namesFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _detailsController, curve: const Interval(0.3, 1.0, curve: Curves.easeIn)),
    );

    // --- FINAL OUTRO ANIMATION (PHASE 4) ---
    // Zoom in 40% (scale to 1.4)
    _finalOutroScaleAnimation = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _finalOutroController, curve: Curves.easeInOutCubic),
    );
    // Move to the bottom (slide down)
    _finalOutroSlideAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1.5)).animate(
      CurvedAnimation(parent: _finalOutroController, curve: Curves.easeInOutCubic),
    );
    // Hide (fade out)
    _finalOutroFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _finalOutroController, curve: Curves.easeOut),
    );

    // --- CARNIVAL OF LOVE (PHASE 5) ---
    _carnivalController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _finalOutroController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _carnivalController.forward();
      }
    });

    _carnivalTitleSlide = Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _carnivalController, curve: Curves.easeOutCubic),
    );
    _carnivalBodySlide = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _carnivalController, curve: Curves.easeOutCubic),
    );
    _carnivalFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _carnivalController, curve: Curves.easeIn),
    );

    // --- CARNIVAL EXIT (PHASE 6) & SWAD RAJASTHAN RO (PHASE 7) ---
    _carnivalExitController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _swadController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

    // Exit Carnival after reading (4 seconds)
    _carnivalController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) _carnivalExitController.forward();
        });
      }
    });

    // Start Swad when Carnival Exit finishes
    _carnivalExitController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _swadController.forward();
      }
    });

    // Phase 6 Exit Animations
    _carnivalExitScale = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _carnivalExitController, curve: Curves.easeInOutCubic),
    );
    _carnivalExitSlide = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1.5)).animate(
      CurvedAnimation(parent: _carnivalExitController, curve: Curves.easeInOutCubic),
    );
    _carnivalExitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _carnivalExitController, curve: Curves.easeOut),
    );

    // Phase 7 Entrance Animations
    _swadTitleSlide = Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _swadController, curve: Curves.easeOutCubic),
    );
    _swadBodySlide = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _swadController, curve: Curves.easeOutCubic),
    );
    _swadFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _swadController, curve: Curves.easeIn),
    );

    // --- SWAD EXIT (PHASE 8) & RSVP SCREEN (PHASE 9) ---
    _swadExitController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _rsvpController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000)); // Longer for staggered animation

    // Exit Swad after reading (4 seconds)
    _swadController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) _swadExitController.forward();
        });
      }
    });

    // Start RSVP when Swad Exit finishes
    _swadExitController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rsvpController.forward();
      }
    });

    // Phase 8 Exit Animations
    _swadExitScale = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _swadExitController, curve: Curves.easeInOutCubic),
    );
    _swadExitSlide = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1.5)).animate(
      CurvedAnimation(parent: _swadExitController, curve: Curves.easeInOutCubic),
    );
    _swadExitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _swadExitController, curve: Curves.easeOut),
    );

    // Phase 9 Staggered Entrance Animations (sliding from bottom one by one, in reverse order)
    int rsvpCount = 8;
    _rsvpSlides = [];
    _rsvpFades = [];
    for (int i = 0; i < rsvpCount; i++) {
      // Reverse the order so the bottom element (index 7) animates first
      int reverseIndex = (rsvpCount - 1) - i;
      double start = reverseIndex * (1.0 / rsvpCount) * 0.5; // Stagger starts up to 0.5
      double end = start + 0.5; // Each animation takes 50% of the total 3 seconds
      
      _rsvpSlides.add(Tween<Offset>(begin: const Offset(0.0, 2.0), end: Offset.zero).animate(
        CurvedAnimation(parent: _rsvpController, curve: Interval(start, end, curve: Curves.easeOutCubic)),
      ));
      _rsvpFades.add(Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _rsvpController, curve: Interval(start, end, curve: Curves.easeIn)),
      ));
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _outroController.dispose();
    _detailsController.dispose();
    _finalOutroController.dispose();
    _carnivalController.dispose();
    _carnivalExitController.dispose();
    _swadController.dispose();
    _swadExitController.dispose();
    _rsvpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFB8860B);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF8E7), // Warm off-white/cream
              Color(0xFFFDF1E3), // Light peach
              Color(0xFFFBE4D5), // Soft peach
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // --- PHASE 1 & 2 (Old Logo + Bedi Family) ---
              AnimatedBuilder(
                animation: _outroController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _outroFadeAnimation,
                    child: SlideTransition(
                      position: _outroSlideAnimation,
                      child: Transform.scale(
                        scale: _outroScaleAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // Logo/Monogram Animation
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        FadeTransition(
                          opacity: _borderFadeAnimation,
                          child: SizedBox(
                            width: 280,
                            height: 280,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Thin golden circular border with gaps
                                ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) {
                                    return const SweepGradient(
                                      colors: [
                                        Colors.transparent, Colors.transparent, // 0.0 to 0.20
                                        Color(0xFFD4AF37), Color(0xFFD4AF37),   // 0.20 to 0.35
                                        Colors.transparent, Colors.transparent, // 0.35 to 0.45
                                        Color(0xFFD4AF37), Color(0xFFFFDF00),   // 0.45 to 0.85
                                        Colors.transparent, Colors.transparent  // 0.85 to 1.0
                                      ],
                                      stops: [
                                        0.0, 0.20, 
                                        0.20, 0.35, 
                                        0.35, 0.45, 
                                        0.45, 0.85, 
                                        0.85, 1.0
                                      ],
                                    ).createShader(bounds);
                                  },
                                  child: Container(
                                    width: 260,
                                    height: 260,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 1.5),
                                    ),
                                  ),
                                ),
                                
                                // Elaborate Lush Pink Floral Wreath
                                Positioned(left: 25, top: 45, child: Transform.rotate(angle: -0.2, child: const Icon(Icons.eco, color: Color(0xFFF8BBD0), size: 40))),
                                Positioned(left: 0, top: 75, child: Transform.rotate(angle: -0.5, child: const Icon(Icons.eco, color: Color(0xFFF48FB1), size: 60))),
                                Positioned(left: -20, top: 120, child: Transform.rotate(angle: -1.0, child: const Icon(Icons.eco, color: Color(0xFFF06292), size: 75))),
                                Positioned(left: -25, bottom: 50, child: Transform.rotate(angle: -1.8, child: const Icon(Icons.eco, color: Color(0xFFF8BBD0), size: 90))),
                                Positioned(left: -5, bottom: -5, child: Transform.rotate(angle: -2.5, child: const Icon(Icons.eco, color: Color(0xFFF48FB1), size: 85))),
                                Positioned(left: 45, bottom: -20, child: Transform.rotate(angle: 2.2, child: const Icon(Icons.eco, color: Color(0xFFF8BBD0), size: 75))),
                                Positioned(left: 95, bottom: -10, child: Transform.rotate(angle: 1.8, child: const Icon(Icons.eco, color: Color(0xFFF48FB1), size: 55))),
                                
                                // Pearls and flowers
                                Positioned(left: 20, top: 85, child: const Icon(Icons.filter_vintage, color: Colors.white70, size: 16)),
                                Positioned(left: 3, top: 125, child: const Icon(Icons.lens, color: Colors.white, size: 8)),
                                Positioned(left: 8, bottom: 80, child: const Icon(Icons.lens, color: Colors.white, size: 10)),
                                Positioned(left: 25, bottom: 40, child: const Icon(Icons.filter_vintage, color: Colors.white70, size: 20)),
                                Positioned(left: 40, bottom: 20, child: const Icon(Icons.lens, color: Colors.white, size: 8)),
                                Positioned(left: 85, bottom: 15, child: const Icon(Icons.filter_vintage, color: Colors.white70, size: 14)),

                                // Animated right side
                                Positioned.fill(
                                  child: AnimatedBuilder(
                                    animation: _rightLineDrawAnimation,
                                    builder: (context, child) {
                                      return ClipRect(
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          heightFactor: _rightLineDrawAnimation.value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: ShaderMask(
                                            blendMode: BlendMode.srcIn,
                                            shaderCallback: (Rect bounds) {
                                              return const SweepGradient(
                                                colors: [
                                                  Color(0xFFFFDF00), Color(0xFFD4AF37),
                                                  Colors.transparent, Colors.transparent,
                                                  Color(0xFFFFDF00), Color(0xFFFFDF00),
                                                ],
                                                stops: [0.0, 0.10, 0.10, 0.85, 0.85, 1.0],
                                              ).createShader(bounds);
                                            },
                                            child: Container(
                                              width: 260,
                                              height: 260,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.white, width: 1.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(right: -5, bottom: 45, child: Transform.rotate(angle: 0.8, child: const Icon(Icons.eco_outlined, color: goldColor, size: 50))),
                                        Positioned(right: 30, top: 15, child: Transform.rotate(angle: 0.4, child: const Icon(Icons.eco_outlined, color: goldColor, size: 35))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // K and S Overlapping in the center
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SlideTransition(
                                position: _kSlideAnimation,
                                child: Transform.translate(
                                  offset: const Offset(-25, 0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return const LinearGradient(
                                            colors: [Color(0xFFF4C4B1), Color(0xFFD48B68), Color(0xFF9E5232)],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ).createShader(bounds);
                                        },
                                        child: Text(
                                          'K',
                                          style: GoogleFonts.cinzelDecorative(
                                            fontSize: 90,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              const Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Inner line
                                      Positioned(
                                        left: 21,
                                        child: Container(
                                          width: 5, 
                                          height: 85, 
                                          color: Colors.white, 
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SlideTransition(
                                position: _sSlideAnimation,
                                child: Transform.translate(
                                  offset: const Offset(30, 20),
                                  child: ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        colors: [Color(0xFFF4C4B1), Color(0xFFD48B68), Color(0xFF9E5232)],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ).createShader(bounds);
                                    },
                                    child: Text(
                                      'S',
                                      style: GoogleFonts.greatVibes(
                                        fontSize: 130,
                                        color: Colors.white,
                                        height: 0.8,
                                        fontWeight: FontWeight.w500,
                                        shadows: [
                                          const Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Old Details Fading In (Phase 1)
                    FadeTransition(
                      opacity: _textFadeAnimation,
                      child: SlideTransition(
                        position: _bottomTextSlideAnimation,
                        child: Column(
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              '26th & 27th November 2025',
                              style: GoogleFonts.lora(
                                fontSize: 18,
                                color: goldColor,
                                fontWeight: FontWeight.w600,
                                shadows: [const Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 1)],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Rajasthali Resort & Spa,\nJaipur',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.greatVibes(
                                fontSize: 32,
                                color: goldColor,
                                fontWeight: FontWeight.w500,
                                shadows: [const Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2)],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Aggarwal & Bedi Family',
                              style: GoogleFonts.dancingScript(
                                fontSize: 36,
                                color: goldColor,
                                fontWeight: FontWeight.w600,
                                shadows: [const Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 2)],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- PHASE 3 & 4 (New Image Text Details + Final Exit) ---
              AnimatedBuilder(
                animation: _finalOutroController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _finalOutroFadeAnimation,
                    child: SlideTransition(
                      position: _finalOutroSlideAnimation,
                      child: Transform.scale(
                        scale: _finalOutroScaleAnimation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: FadeTransition(
                  opacity: _detailsFadeAnimation,
                  child: SlideTransition(
                    position: _detailsSlideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        // Ganesha Logo Placeholder
                        const Icon(Icons.brightness_5, color: Color(0xFFD4AF37), size: 40),
                        const SizedBox(height: 10),
                        Text(
                          '॥ श्री गणेशाय नमः ॥',
                          style: GoogleFonts.lora(fontSize: 22, color: goldColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'With the blessings of Lord Ganesha\nWe cordially invite you to the wedding celebrations of',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lora(
                            fontSize: 14,
                            color: const Color(0xFF8B6508),
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Kunal
                        FadeTransition(
                          opacity: _namesFadeAnimation,
                          child: SlideTransition(
                            position: _kunalSlideAnimation,
                            child: Text(
                              'Kunal',
                              style: GoogleFonts.greatVibes(
                                fontSize: 60,
                                color: const Color(0xFFD4AF37),
                                fontWeight: FontWeight.w500,
                                shadows: [const Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 2)],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '(Gs/O Late Smt. Dayawati & Shri Munshi Lal Gupta)\n(S/O Asha & Gyaneshwar Aggarwal)',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lora(
                            fontSize: 12,
                            color: const Color(0xFF8B6508),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'with',
                          style: GoogleFonts.greatVibes(fontSize: 30, color: const Color(0xFFD4AF37)),
                        ),
                        const SizedBox(height: 10),
                        // Simran
                        FadeTransition(
                          opacity: _namesFadeAnimation,
                          child: SlideTransition(
                            position: _simranSlideAnimation,
                            child: Text(
                              'Simran',
                              style: GoogleFonts.greatVibes(
                                fontSize: 60,
                                color: const Color(0xFFD4AF37),
                                fontWeight: FontWeight.w500,
                                shadows: [const Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 2)],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '(Gd/O Smt. Charanjeet Kaur &\nLate Shri Gurdyal Singh)\n(D/O Tarun & Tadbir Singh Bedi)',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lora(
                            fontSize: 12,
                            color: const Color(0xFF8B6508),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ),
              ),

              // --- PHASE 5 & 6 (Carnival Screen + Exit) ---
              AnimatedBuilder(
                animation: _carnivalExitController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _carnivalExitFade,
                    child: SlideTransition(
                      position: _carnivalExitSlide,
                      child: Transform.scale(
                        scale: _carnivalExitScale.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: FadeTransition(
                  opacity: _carnivalFade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SlideTransition(
                          position: _carnivalTitleSlide,
                          child: Text(
                            'Carnival of Love',
                            style: GoogleFonts.greatVibes(
                              fontSize: 70,
                              color: const Color(0xFFD4AF37),
                              fontWeight: FontWeight.w500,
                              shadows: [const Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 2)],
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: _carnivalBodySlide,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                '(Haldi / Mehndi)',
                                style: GoogleFonts.lora(
                                  fontSize: 24,
                                  color: const Color(0xFF8B6508),
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 50),
                              Text(
                                'Wednesday',
                                style: GoogleFonts.lora(
                                  fontSize: 22,
                                  color: const Color(0xFF8B6508),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '26th November, 2025',
                                style: GoogleFonts.lora(
                                  fontSize: 36,
                                  color: const Color(0xFF8B6508),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '01.00 p.m.',
                                style: GoogleFonts.lora(
                                  fontSize: 24,
                                  color: const Color(0xFF8B6508),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Venue',
                                style: GoogleFonts.lora(
                                  fontSize: 24,
                                  color: const Color(0xFF8B6508),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Pool Side',
                                style: GoogleFonts.lora(
                                  fontSize: 26,
                                  color: const Color(0xFF8B6508),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
                     // --- PHASE 7 & 8 (Swad Rajasthan Ro Screen + Exit) ---
              AnimatedBuilder(
                animation: _swadExitController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _swadExitFade,
                    child: SlideTransition(
                      position: _swadExitSlide,
                      child: Transform.scale(
                        scale: _swadExitScale.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: FadeTransition(
                  opacity: _swadFade,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SlideTransition(
                          position: _swadTitleSlide,
                          child: Text(
                            'Swad Rajasthan Ro',
                            style: GoogleFonts.greatVibes(
                              fontSize: 60, // Slightly smaller to fit width
                              color: const Color(0xFFD4AF37),
                              fontWeight: FontWeight.w500,
                              shadows: [const Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 2)],
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: _swadBodySlide,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                '(Royal Rajasthani Lunch)',
                                style: GoogleFonts.lora(
                                  fontSize: 24,
                                  color: const Color(0xFF8B6508),
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 50),
                              Text(
                                'Thursday',
                                style: GoogleFonts.lora(
                                  fontSize: 22,
                                  color: const Color(0xFF8B6508),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '27th November, 2025',
                                style: GoogleFonts.lora(
                                  fontSize: 36,
                                  color: const Color(0xFF8B6508),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '12.00 p.m.',
                                style: GoogleFonts.lora(
                                  fontSize: 24,
                                  color: const Color(0xFF8B6508),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                'Venue',
                                style: GoogleFonts.lora(
                                  fontSize: 24,
                                  color: const Color(0xFF8B6508),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Swarn Mahal',
                                style: GoogleFonts.lora(
                                  fontSize: 26,
                                  color: const Color(0xFF8B6508),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- PHASE 9 (RSVP Screen) ---
              Stack(
                alignment: Alignment.center,
                children: [
                  // Red Carpet Background
                  FadeTransition(
                    opacity: _rsvpFades[0], // Fades in with the first text
                    child: SizedBox.expand(
                      child: CustomPaint(
                        painter: RedCarpetPainter(),
                      ),
                    ),
                  ),
                  // RSVP Text Content
                  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _rsvpFades[0],
                      child: SlideTransition(
                        position: _rsvpSlides[0],
                        child: Text(
                          'Awaiting your\ngracious presence',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.greatVibes(
                            fontSize: 40,
                            color: const Color(0xFFD4AF37),
                            fontWeight: FontWeight.w500,
                            shadows: [const Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 2)],
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeTransition(
                      opacity: _rsvpFades[1],
                      child: SlideTransition(
                        position: _rsvpSlides[1],
                        child: Column(
                          children: [
                            Text(
                              'Warm Regards',
                              style: GoogleFonts.lora(
                                fontSize: 20,
                                color: const Color(0xFF8B6508),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Aggarwal Family',
                              style: GoogleFonts.greatVibes(
                                fontSize: 45,
                                color: const Color(0xFFD4AF37),
                                fontWeight: FontWeight.w500,
                                shadows: [const Shadow(color: Colors.black12, offset: Offset(1, 1), blurRadius: 2)],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeTransition(
                      opacity: _rsvpFades[2],
                      child: SlideTransition(
                        position: _rsvpSlides[2],
                        child: Text(
                          'R.S.V.P',
                          style: GoogleFonts.lora(
                            fontSize: 22,
                            color: const Color(0xFF8B6508),
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    FadeTransition(
                      opacity: _rsvpFades[3],
                      child: SlideTransition(
                        position: _rsvpSlides[3],
                        child: Column(
                          children: [
                            Text('Mr Nityanand Aggarwal', style: GoogleFonts.lora(fontSize: 16, color: const Color(0xFF8B6508), fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                            Text('9250925737', style: GoogleFonts.lora(fontSize: 16, color: const Color(0xFF8B6508), fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeTransition(
                      opacity: _rsvpFades[4],
                      child: SlideTransition(
                        position: _rsvpSlides[4],
                        child: Column(
                          children: [
                            Text('Mr Aditya Aggarwal', style: GoogleFonts.lora(fontSize: 16, color: const Color(0xFF8B6508), fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                            Text('9810872511', style: GoogleFonts.lora(fontSize: 16, color: const Color(0xFF8B6508), fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeTransition(
                      opacity: _rsvpFades[5],
                      child: SlideTransition(
                        position: _rsvpSlides[5],
                        child: Column(
                          children: [
                            Text('Mr Prateek Aggarwal', style: GoogleFonts.lora(fontSize: 16, color: const Color(0xFF8B6508), fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                            Text('7827818429', style: GoogleFonts.lora(fontSize: 16, color: const Color(0xFF8B6508), fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
  }
}

class RedCarpetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Just a solid red background for now since the painter implementation is missing
    final paint = Paint()..color = const Color(0xFF7A1C20);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
