import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class ReceptionScreen extends StatefulWidget {
  const ReceptionScreen({super.key});

  @override
  State<ReceptionScreen> createState() => _ReceptionScreenState();
}

class _ReceptionScreenState extends State<ReceptionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    );

    _controller.forward();

    // Navigate to WeddingScreen when done
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            Get.offNamed(AppRoutes.WEDDING);
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: letters,
    );
  }

  // Animates the entire 5 text blocks: Slides from right, then bounces vertically (top to center)
  Widget _buildSlidingLineFromRight({
    required String text,
    required TextStyle style,
    required double startTime,
    required double endTime,
    required double screenWidth,
  }) {
    // 60% of time sliding in horizontally, 40% of time bouncing vertically
    final double slideDuration = (endTime - startTime) * 0.6;
    final double slideEnd = startTime + slideDuration;

    final Interval slideInterval = Interval(startTime, slideEnd, curve: Curves.easeOut);
    final Interval fadeInterval = Interval(startTime, slideEnd, curve: Curves.easeIn);

    // Slide from right
    final Animation<Offset> slideAnim = Tween<Offset>(begin: Offset(screenWidth * 0.5, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: slideInterval),
    );

    final Animation<double> fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: fadeInterval),
    );

    // Y-axis Bounce: Starts at 0, jumps up (negative Y) and bounces down to 0
    final Animation<double> yBounceAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(0.0), 
        weight: 60, // Do nothing during the horizontal slide phase
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -30.0, end: 0.0).chain(CurveTween(curve: Curves.bounceOut)), 
        weight: 40, // Bounce vertically phase
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Interval(startTime, endTime)));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          // Combine horizontal slide with vertical bounce
          offset: Offset(slideAnim.value.dx, yBounceAnim.value),
          child: Opacity(
            opacity: fadeAnim.value,
            child: Text(text, style: style, textAlign: TextAlign.center),
          ),
        );
      },
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
            image: AssetImage('assets/images/second.jpg.jpeg'),
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
                // 1. Title (Reception) - Waves in first (0.0 to 0.25)
                _buildWavyText(
                  text: 'Reception',
                  style: GoogleFonts.greatVibes(
                    fontSize: screenWidth * 0.15,
                    color: const Color(0xFF8C8665),
                    fontWeight: FontWeight.w500,
                  ),
                  startTime: 0.0,
                  endTime: 0.25,
                  rotationBegin: math.pi / 5,
                  slideDistance: slideDistance,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenWidth * 0.05),

                // 2. Subtitle - Waves in after title (0.25 to 0.5)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: _buildWavyText(
                    text: "WE CORDIALLY INVITE YOU TO OUR SON'S RECEPTION CEREMONY PLEASE JOIN US",
                    style: GoogleFonts.cinzel(
                      fontSize: screenWidth * 0.03,
                      color: const Color(0xFF8C8665),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                      height: 1.5,
                    ),
                    startTime: 0.25,
                    endTime: 0.5,
                    rotationBegin: -math.pi / 5,
                    slideDistance: 30.0,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenWidth * 0.08),

                // 3. Falling Names - Staggered letter-by-letter drop
                _buildDroppingLetters(
                  text: 'Akshay',
                  style: GoogleFonts.greatVibes(
                    fontSize: screenWidth * 0.15,
                    color: const Color(0xFFD4AF37), // Gold color
                  ),
                  startTime: 0.5,
                  endTime: 0.85, // Much slower drop
                  overlapFactor: 4.0, // Visible stagger A..k..s..h..
                ),
                _buildDroppingLetters(
                  text: '&',
                  style: GoogleFonts.greatVibes(
                    fontSize: screenWidth * 0.08,
                    color: const Color(0xFF8C8665),
                  ),
                  startTime: 0.5,
                  endTime: 0.85, // Much slower drop
                  overlapFactor: 4.0,
                ),
                _buildDroppingLetters(
                  text: 'Krishna',
                  style: GoogleFonts.greatVibes(
                    fontSize: screenWidth * 0.15,
                    color: const Color(0xFFD4AF37), // Gold color
                  ),
                  startTime: 0.5,
                  endTime: 0.85, // Much slower drop
                  overlapFactor: 4.0, // Visible stagger K..r..i..s..
                ),
                SizedBox(height: screenWidth * 0.08),

                // 4. Sliding Bottom Text - The 5 text blocks slide from right, then bounce vertically into place (0.75 to 1.0)
                _buildSlidingLineFromRight(
                  text: 'Tuesday, 19th July 2022',
                  style: GoogleFonts.cinzel(
                    fontSize: screenWidth * 0.05,
                    color: const Color(0xFF8C8665),
                    fontWeight: FontWeight.w500,
                  ),
                  startTime: 0.75,
                  endTime: 0.90,
                  screenWidth: fullWidth,
                ),
                SizedBox(height: screenWidth * 0.02),
                
                _buildSlidingLineFromRight(
                  text: '8:30 pm Onwards',
                  style: GoogleFonts.cinzel(
                    fontSize: screenWidth * 0.045,
                    color: const Color(0xFF8C8665),
                    fontWeight: FontWeight.w500,
                  ),
                  startTime: 0.78,
                  endTime: 0.92,
                  screenWidth: fullWidth,
                ),
                SizedBox(height: screenWidth * 0.02),
                
                _buildSlidingLineFromRight(
                  text: '@',
                  style: GoogleFonts.cinzel(
                    fontSize: screenWidth * 0.04,
                    color: const Color(0xFF8C8665),
                  ),
                  startTime: 0.81,
                  endTime: 0.94,
                  screenWidth: fullWidth,
                ),
                SizedBox(height: screenWidth * 0.02),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: _buildSlidingLineFromRight(
                    text: 'Krishna Resorts , opp. jain school',
                    style: GoogleFonts.cinzel(
                      fontSize: screenWidth * 0.04,
                      color: const Color(0xFF8C8665),
                      fontWeight: FontWeight.w500,
                    ),
                    startTime: 0.84,
                    endTime: 0.97,
                    screenWidth: fullWidth,
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                
                _buildSlidingLineFromRight(
                  text: 'Jakatnaka ,Surat.',
                  style: GoogleFonts.cinzel(
                    fontSize: screenWidth * 0.04,
                    color: const Color(0xFF8C8665),
                    fontWeight: FontWeight.w500,
                  ),
                  startTime: 0.87,
                  endTime: 1.0,
                  screenWidth: fullWidth,
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
