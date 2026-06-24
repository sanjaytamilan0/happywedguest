import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';
import '../widgets/countdown_widget.dart';

class RsvpCard extends ConsumerStatefulWidget {
  final String guestName;

  const RsvpCard({super.key, required this.guestName});

  @override
  ConsumerState<RsvpCard> createState() => _RsvpCardState();
}

class _RsvpCardState extends ConsumerState<RsvpCard> {
  late ConfettiController _confettiController;
  bool _hasResponded = false;
  bool _isAccepting = false;
  bool _isAccepted = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cardWidth = size.width > size.height ? size.height * 0.5 : double.infinity;

    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          child: SizedBox(
            width: cardWidth,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/thirdbg.jpeg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'SAVE THE DATE',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8C8665),
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.diamond_outlined, size: 16, color: const Color(0xFF8C8665)),
              const SizedBox(width: 8),
              Icon(Icons.favorite, size: 16, color: const Color(0xFF8C8665)),
              const SizedBox(width: 8),
              Icon(Icons.diamond_outlined, size: 16, color: const Color(0xFF8C8665)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Celebrating the Union of',
            style: GoogleFonts.lora(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF8C8665),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Akshay',
            style: GoogleFonts.greatVibes(
              fontSize: 64,
              color: const Color(0xFF8C8665),
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
          ),
          Text(
            '&',
            style: GoogleFonts.greatVibes(
              fontSize: 32,
              color: const Color(0xFF8C8665),
              height: 1.0,
            ),
          ),
          Text(
            'Krishna',
            style: GoogleFonts.greatVibes(
              fontSize: 64,
              color: const Color(0xFF8C8665),
              fontWeight: FontWeight.w500,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 32),
          CountdownWidget(targetDate: DateTime.now().add(const Duration(days: 45, hours: 8, minutes: 30))),
          const SizedBox(height: 48),
          Text(
            'Hello, ${widget.guestName}!',
            style: GoogleFonts.cinzel(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8C8665),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'You are cordially invited to celebrate with us',
            style: GoogleFonts.cinzel(
              fontSize: 16,
              color: const Color(0xFF8C8665),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6), // Semi-transparent for template bg
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF8C8665).withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  'RSVP',
                  style: GoogleFonts.cinzel(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8C8665),
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 16),
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border(
                //       left: BorderSide(
                //         color: Theme.of(context).colorScheme.primary,
                //         width: 4,
                //       ),
                //     ),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Your Assigned Ceremonies:',
                //         style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           color: Colors.grey[800],
                //         ),
                //       ),
                //       const SizedBox(height: 8),
                //       Text(
                //         'Wedding: Kaveri & Gangadhar, Haldhi',
                //         style: TextStyle(color: Colors.grey[700]),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 24),
                // RSVP Action Buttons
                SizedBox(
                  height: 56,
                  child: Center(
                    child: _isAccepting
                        ? const CircularProgressIndicator()
                        : _isAccepted
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.favorite, color: const Color(0xFF8C8665), size: 28),
                                  const SizedBox(width: 12),
                                  Text('Accepted', style: GoogleFonts.greatVibes(fontSize: 32, fontWeight: FontWeight.bold, color: const Color(0xFF8C8665))),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _hasResponded
                                          ? null
                                          : () {
                                              setState(() {
                                                _hasResponded = true;
                                                _isAccepting = true;
                                              });
                                              Future.delayed(const Duration(seconds: 1), () {
                                                if (mounted) {
                                                  setState(() {
                                                    _isAccepting = false;
                                                    _isAccepted = true;
                                                  });
                                                  _confettiController.play();
                                                }
                                              });
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF8C8665),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        'I am coming',
                                        style: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey[600],
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        'Not coming',
                                        style: GoogleFonts.cinzel(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
    Align(
      alignment: Alignment.bottomCenter,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive, // radial explosive
        shouldLoop: false,
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        maxBlastForce: 100,
        minBlastForce: 20,
        gravity: 0.2,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ], // manually specify colors
        createParticlePath: drawStar, // custom shape
      ),
    ),
    ]);
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {

    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
