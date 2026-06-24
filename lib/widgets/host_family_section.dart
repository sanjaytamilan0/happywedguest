import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class HostFamilySection extends StatefulWidget {
  const HostFamilySection({super.key});

  @override
  State<HostFamilySection> createState() => _HostFamilySectionState();
}

class _HostFamilySectionState extends State<HostFamilySection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6500),
    );

    // Play animation shortly after mounting
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
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

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: textAlign == TextAlign.center ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: letters,
      ),
    );
  }

  Widget _buildDroppingLetters({
    required String text,
    required TextStyle style,
    required double startTime,
    required double endTime,
    double overlapFactor = 1.05, 
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

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width > 600 ? 500 : size.width - 48; // Max width for the section
    final double slideDistance = 150.0;

    return Container(
      width: double.infinity,
      height: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: AssetImage('assets/images/initalbg.jpg.jpeg'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Dark overlay to make text readable
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Title
                  _buildWavyText(
                    text: 'Host Family',
                    style: GoogleFonts.greatVibes(
                      fontSize: screenWidth * 0.15,
                      color: const Color(0xFFD4AF37),
                      fontWeight: FontWeight.w500,
                    ),
                    startTime: 0.0,
                    endTime: 0.25,
                    rotationBegin: math.pi / 5,
                    slideDistance: slideDistance,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenWidth * 0.05),

                  // 2. Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      children: [
                        _buildWavyText(
                          text: "PROUD PARENTS INVITING YOU",
                          style: GoogleFonts.cinzel(
                            fontSize: screenWidth * 0.035,
                            color: Colors.white,
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
                        _buildWavyText(
                          text: "TO JOIN THE CELEBRATION",
                          style: GoogleFonts.cinzel(
                            fontSize: screenWidth * 0.035,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                            height: 1.5,
                          ),
                          startTime: 0.35,
                          endTime: 0.6,
                          rotationBegin: -math.pi / 5,
                          slideDistance: 30.0,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.1),

                  // 3. Falling Names - Father
                  _buildDroppingLetters(
                    text: 'Mr Nityanand Aggarwal',
                    style: GoogleFonts.greatVibes(
                      fontSize: screenWidth * 0.1,
                      color: const Color(0xFFD4AF37), // Gold color
                    ),
                    startTime: 0.5,
                    endTime: 0.7, 
                    overlapFactor: 2.0, 
                  ),
                  const SizedBox(height: 16),
                  
                  // 4. And
                  _buildDroppingLetters(
                    text: '&',
                    style: GoogleFonts.greatVibes(
                      fontSize: screenWidth * 0.08,
                      color: Colors.white,
                    ),
                    startTime: 0.7,
                    endTime: 0.8, 
                    overlapFactor: 2.0,
                  ),
                  const SizedBox(height: 16),

                  // 5. Falling Names - Mother
                  _buildDroppingLetters(
                    text: 'Mrs Asha Aggarwal',
                    style: GoogleFonts.greatVibes(
                      fontSize: screenWidth * 0.1,
                      color: const Color(0xFFD4AF37), // Gold color
                    ),
                    startTime: 0.8,
                    endTime: 1.0, 
                    overlapFactor: 2.0, 
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
