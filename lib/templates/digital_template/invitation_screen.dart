import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'reception_screen.dart';

class DigitalInvitationScreen extends StatefulWidget {
  final bool isPreview;
  const DigitalInvitationScreen({super.key, this.isPreview = false});

  @override
  State<DigitalInvitationScreen> createState() => _DigitalInvitationScreenState();
}

class _DigitalInvitationScreenState extends State<DigitalInvitationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Monogram animations
  late Animation<double> _glitchAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _monogramFadeAnimation;
  late Animation<double> _aSlideAnimation;
  late Animation<double> _kSlideAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500), 
    );

    // -- Monogram Animations (0.0 to 0.5 interval) --
    final monogramInterval = const Interval(0.0, 0.5, curve: Curves.easeOutQuart);
    final monogramBackInterval = const Interval(0.0, 0.5, curve: Curves.easeOutBack);

    _glitchAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: monogramBackInterval),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: monogramBackInterval),
    );

    _monogramFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.35, curve: Curves.easeIn)),
    );

    _aSlideAnimation = Tween<double>(begin: -60.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: monogramInterval),
    );

    _kSlideAnimation = Tween<double>(begin: 60.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: monogramInterval),
    );

    _rotationAnimation = Tween<double>(begin: math.pi * 2, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: monogramInterval),
    );

    // Start the animation
    _controller.forward();

    // Navigate to next screen when done
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            if (widget.isPreview) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => DigitalReceptionScreen(isPreview: widget.isPreview),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
                  transitionDuration: const Duration(milliseconds: 500),
                ),
              );
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double fullWidth = size.width;
    // Responsive scaling: use width on mobile, use a proportion of height on web/desktop
    final double screenWidth = size.width > size.height ? size.height * 0.5 : size.width;
    final double screenHeight = size.height;

    // The user requested 30% extra bottom distance for the text slide.
    final double slideDistance = screenHeight * 0.3; 

    return Scaffold(
      body: Stack(
        children: [
          Center(
        child: Container(
          width: screenWidth,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/first.jpg.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.18),
              // Animated Monogram
              _buildAnimatedMonogram(screenWidth),
              SizedBox(height: screenWidth * 0.03),
              
              // Main Names (Letter by Letter Wave with Rotation)
              _buildWavyText(
                text: 'KAVERI & GANGADHAR',
                style: GoogleFonts.cinzel(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                  color: const Color(0xFF8C8665),
                ),
                startTime: 0.35, // Start as monogram settles
                endTime: 0.75,
                rotationBegin: math.pi / 5, // Tilts right initially
                slideDistance: slideDistance,
              ),
              
              SizedBox(height: screenWidth * 0.03),
              
              // Hashtag (Letter by Letter Wave with Opposite Rotation)
              _buildWavyText(
                text: '#KAVEGAN WEDDING',
                style: GoogleFonts.cinzel(
                  fontSize: screenWidth * 0.025,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3.0,
                  color: const Color(0xFFA5A181),
                ),
                startTime: 0.55, // Staggered after names
                endTime: 0.95,
                rotationBegin: -math.pi / 5, // Tilts left initially
                slideDistance: slideDistance,
              ),
            ],
          ),
        ),
      ),
      ),
      ),
          if (Navigator.of(context).canPop())
            Positioned(
              top: 16,
              right: 16,
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper widget to animate text letter-by-letter with slide, fade, and rotate
  Widget _buildWavyText({
    required String text,
    required TextStyle style,
    required double startTime,
    required double endTime,
    required double rotationBegin,
    required double slideDistance,
  }) {
    List<Widget> letters = [];
    final int length = text.length;
    final double letterDuration = (endTime - startTime) / 2.5;

    for (int i = 0; i < length; i++) {
      if (text[i] == ' ') {
        letters.add(Text(' ', style: style));
        continue;
      }

      final double letterStart = startTime + (i / length) * ((endTime - startTime) - letterDuration);
      final double letterEnd = letterStart + letterDuration;
      final Interval letterInterval = Interval(letterStart, letterEnd, curve: Curves.easeOutBack);
      final Interval fadeInterval = Interval(letterStart, letterEnd, curve: Curves.easeIn);

      final Animation<double> fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: fadeInterval),
      );

      final Animation<Offset> slideAnim = Tween<Offset>(begin: Offset(0, slideDistance), end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: letterInterval),
      );

      final Animation<double> rotateAnim = Tween<double>(begin: rotationBegin, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: letterInterval),
      );

      letters.add(
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translate(slideAnim.value.dx, slideAnim.value.dy)
                ..rotateZ(rotateAnim.value),
              child: Opacity(
                opacity: fadeAnim.value,
                child: Text(text[i], style: style),
              ),
            );
          },
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: letters,
    );
  }

  Widget _buildGlitchedLetter({
    required Widget child,
    required double glitch,
    required double screenWidth,
  }) {
    Widget sizedChild = SizedBox(
      width: screenWidth * 0.8,
      height: screenWidth * 0.4,
      child: Center(child: child),
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRect(
          clipper: _HorizontalSliceClipper(0.0, 0.35),
          child: Transform.translate(
            offset: Offset(-50.0 * glitch, 0),
            child: sizedChild,
          ),
        ),
        ClipRect(
          clipper: _HorizontalSliceClipper(0.35, 0.65),
          child: Transform.translate(
            offset: Offset(80.0 * glitch, 0),
            child: sizedChild,
          ),
        ),
        ClipRect(
          clipper: _HorizontalSliceClipper(0.65, 1.0),
          child: Transform.translate(
            offset: Offset(-40.0 * glitch, 0),
            child: sizedChild,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedMonogram(double screenWidth) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glitch = _glitchAnimation.value;
        final scale = _scaleAnimation.value;
        final opacity = _monogramFadeAnimation.value;

        final Shader linearGradient = const LinearGradient(
          colors: <Color>[Color(0xFFE5C07B), Color(0xFFD4AF37), Color(0xFFC59B27)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0.0, 0.0, screenWidth * 0.5, screenWidth * 0.5));

        final monogramFontSize = screenWidth * 0.25;

        Widget letterA = Text(
          'K',
          style: GoogleFonts.greatVibes(
            fontSize: monogramFontSize,
            foreground: Paint()..shader = linearGradient,
            height: 1.0,
          ),
        );

        Widget letterK = Text(
          'G',
          style: GoogleFonts.greatVibes(
            fontSize: monogramFontSize,
            foreground: Paint()..shader = linearGradient,
            height: 1.0,
          ),
        );

        return Opacity(
          opacity: opacity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(-screenWidth * 0.06 + _aSlideAnimation.value, 0.0)
                  ..rotateY(_rotationAnimation.value)
                  ..scale(scale),
                child: _buildGlitchedLetter(
                  child: letterA,
                  glitch: glitch,
                  screenWidth: screenWidth,
                ),
              ),
              Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(screenWidth * 0.08 + _kSlideAnimation.value, screenWidth * 0.04)
                  ..rotateY(-_rotationAnimation.value)
                  ..scale(scale),
                child: _buildGlitchedLetter(
                  child: letterK,
                  glitch: glitch,
                  screenWidth: screenWidth,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HorizontalSliceClipper extends CustomClipper<Rect> {
  final double startFraction;
  final double endFraction;

  _HorizontalSliceClipper(this.startFraction, this.endFraction);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      0,
      size.height * startFraction,
      size.width,
      size.height * endFraction,
    );
  }

  @override
  bool shouldReclip(_HorizontalSliceClipper oldClipper) {
    return oldClipper.startFraction != startFraction ||
           oldClipper.endFraction != endFraction;
  }
}
