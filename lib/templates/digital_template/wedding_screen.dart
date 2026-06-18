import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'digital_invitation_app.dart';

class DigitalWeddingScreen extends StatefulWidget {
  final bool isPreview;
  const DigitalWeddingScreen({super.key, this.isPreview = false});

  @override
  State<DigitalWeddingScreen> createState() => _DigitalWeddingScreenState();
}

class _DigitalWeddingScreenState extends State<DigitalWeddingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Extended duration to 20 seconds so the final venue animation gets 5 full seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            if (widget.isPreview) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => DigitalThemeApp(isPreview: widget.isPreview),
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

  Widget _buildWavyText({
    required String text,
    required TextStyle style,
    required double startTime,
    required double endTime,
    required double rotationBegin,
    required double slideDistance,
    TextAlign? textAlign,
  }) {
    List<Widget> letters = [];
    final int length = text.length;
    final double letterDuration = (endTime - startTime) / 3.0;

    for (int i = 0; i < length; i++) {
      if (text[i] == ' ') {
        letters.add(Text(' ', style: style));
        continue;
      }
      
      if (text[i] == '\n') {
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

    return Wrap(
      alignment: textAlign == TextAlign.center ? WrapAlignment.center : WrapAlignment.start,
      children: letters,
    );
  }

  Widget _buildDroppingLetters({
    required String text,
    required TextStyle style,
    required double startTime,
    required double endTime,
    double overlapFactor = 1.05, // Default to slow drop with little stagger
  }) {
    List<Widget> letters = [];
    final int length = text.length;
    final double letterDuration = (endTime - startTime) / overlapFactor; 

    for (int i = 0; i < length; i++) {
      if (text[i] == ' ') {
        letters.add(Text(' ', style: style));
        continue;
      }

      final double letterStart = startTime + (i / length) * ((endTime - startTime) - letterDuration);
      final double letterEnd = letterStart + letterDuration;
      final Interval dropInterval = Interval(letterStart, letterEnd, curve: Curves.easeOutBack);
      final Interval fadeInterval = Interval(letterStart, letterEnd, curve: Curves.easeIn);

      final Animation<Offset> dropAnim = Tween<Offset>(begin: const Offset(0, -100), end: Offset.zero).animate(
        CurvedAnimation(parent: _controller, curve: dropInterval),
      );

      final Animation<double> fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: fadeInterval),
      );

      letters.add(
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: dropAnim.value,
              child: Opacity(
                opacity: fadeAnim.value,
                child: Text(text[i], style: style),
              ),
            );
          },
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      children: letters,
    );
  }

  Widget _buildSlidingUpwards({
    required Widget child,
    required double startTime,
    required double endTime,
    required double slideDistance,
  }) {
    // Only straight move animation (no bounce/overshoot)
    final Interval interval = Interval(startTime, endTime, curve: Curves.easeOut);
    final Interval fadeInterval = Interval(startTime, endTime, curve: Curves.easeIn);

    final Animation<Offset> slideAnim = Tween<Offset>(begin: Offset(0, slideDistance), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: interval),
    );

    final Animation<double> fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: fadeInterval),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: slideAnim.value,
          child: Opacity(
            opacity: fadeAnim.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildDottedLine(double height) {
    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          10,
          (index) => Container(
            width: 2,
            height: 2,
            color: const Color(0xFF8C8665),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double fullWidth = size.width;
    // Responsive scaling: use width on mobile, use a proportion of height on web/desktop
    final double screenWidth = size.width > size.height ? size.height * 0.5 : size.width;
    final double screenHeight = size.height;
    
    final double slideDistance = screenHeight * 0.3;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
            image: AssetImage('assets/images/thirdbg.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Title - Waves in first
                _buildWavyText(
                  text: 'Wedding Ceremony',
                  style: GoogleFonts.greatVibes(
                    fontSize: screenWidth * 0.15,
                    color: const Color(0xFF8C8665),
                    fontWeight: FontWeight.w500,
                  ),
                  startTime: 0.0,
                  endTime: 0.20,
                  rotationBegin: math.pi / 5,
                  slideDistance: slideDistance,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenWidth * 0.05),

                // 2. Subtitle Families
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: _buildWavyText(
                    text: "THAKAR & OZA FAMILY",
                    style: GoogleFonts.cinzel(
                      fontSize: screenWidth * 0.035,
                      color: const Color(0xFF8C8665),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                    startTime: 0.20,
                    endTime: 0.30,
                    rotationBegin: -math.pi / 5,
                    slideDistance: 30.0,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                
                // 3. Subtitle Invitation
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: _buildWavyText(
                    text: "INVITE YOU FOR A WEDDING CELEBRATION OF",
                    style: GoogleFonts.cinzel(
                      fontSize: screenWidth * 0.03,
                      color: const Color(0xFF8C8665),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                    ),
                    startTime: 0.30,
                    endTime: 0.40,
                    rotationBegin: -math.pi / 5,
                    slideDistance: 30.0,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenWidth * 0.06),

                // 4. Falling Names - Staggered letter-by-letter drop
                _buildDroppingLetters(
                  text: 'Kaveri',
                  style: GoogleFonts.greatVibes(
                    fontSize: screenWidth * 0.15,
                    color: const Color(0xFFD4AF37),
                  ),
                  startTime: 0.40,
                  endTime: 0.65,
                  overlapFactor: 4.0, // Visible stagger A..k..s..h..
                ),
                _buildDroppingLetters(
                  text: '&',
                  style: GoogleFonts.greatVibes(
                    fontSize: screenWidth * 0.08,
                    color: const Color(0xFF8C8665),
                  ),
                  startTime: 0.40,
                  endTime: 0.65,
                  overlapFactor: 4.0, 
                ),
                _buildDroppingLetters(
                  text: 'Gangadhar',
                  style: GoogleFonts.greatVibes(
                    fontSize: screenWidth * 0.15,
                    color: const Color(0xFFD4AF37),
                  ),
                  startTime: 0.40,
                  endTime: 0.65,
                  overlapFactor: 4.0, // Visible stagger K..r..i..s..
                ),
                SizedBox(height: screenWidth * 0.08),

                // 5. Date & Time Row - Sliding up from bottom of device ONLY after names sit
                _buildSlidingUpwards(
                  startTime: 0.65, // Starts exactly when names finish at 0.65
                  endTime: 0.75,
                  slideDistance: screenHeight, // Bottom of device
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text('JULY', style: GoogleFonts.cinzel(fontSize: screenWidth * 0.04, color: const Color(0xFF8C8665))),
                          Text('TUESDAY', style: GoogleFonts.cinzel(fontSize: screenWidth * 0.04, color: const Color(0xFF8C8665))),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      _buildDottedLine(screenWidth * 0.1),
                      SizedBox(width: screenWidth * 0.04),
                      Text(
                        '19',
                        style: GoogleFonts.cinzel(fontSize: screenWidth * 0.15, color: const Color(0xFFD4AF37), fontWeight: FontWeight.w400, height: 1.0),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      _buildDottedLine(screenWidth * 0.1),
                      SizedBox(width: screenWidth * 0.04),
                      Column(
                        children: [
                          Text('2022', style: GoogleFonts.cinzel(fontSize: screenWidth * 0.04, color: const Color(0xFF8C8665))),
                          Text('AT 6:00 PM', style: GoogleFonts.cinzel(fontSize: screenWidth * 0.04, color: const Color(0xFF8C8665))),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.08),

                // 6. Venue Header - Letter by letter sit animation over 5 seconds total for venue block
                _buildDroppingLetters(
                  text: ':: VENUE ::',
                  style: GoogleFonts.cinzel(
                    fontSize: screenWidth * 0.045,
                    color: const Color(0xFF8C8665),
                    fontWeight: FontWeight.w500,
                  ),
                  startTime: 0.75,
                  endTime: 0.85,
                  overlapFactor: 4.0, // High stagger so they drop one by one
                ),
                SizedBox(height: screenWidth * 0.02),
                
                // 7. Venue Details - Letter by letter sit animation
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: _buildDroppingLetters(
                    text: 'KRISHNA RESORTS , OPP. JAIN SCHOOL',
                    style: GoogleFonts.cinzel(
                      fontSize: screenWidth * 0.035,
                      color: const Color(0xFF8C8665),
                      fontWeight: FontWeight.w500,
                    ),
                    startTime: 0.80,
                    endTime: 0.95,
                    overlapFactor: 4.0, // High stagger so they drop one by one
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                
                _buildDroppingLetters(
                  text: 'JAKATNAKA ,SURAT.',
                  style: GoogleFonts.cinzel(
                    fontSize: screenWidth * 0.035,
                    color: const Color(0xFF8C8665),
                    fontWeight: FontWeight.w500,
                  ),
                  startTime: 0.85,
                  endTime: 1.0,
                  overlapFactor: 4.0, // High stagger so they drop one by one
                ),
                SizedBox(height: screenWidth * 0.1),
              ],
            ),
          ),
        ),
      ),
      ),
      ),
    );
  }
}
