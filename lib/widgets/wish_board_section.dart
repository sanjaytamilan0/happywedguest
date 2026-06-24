import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';

class WishBoardSection extends StatefulWidget {
  final bool isDesktop;

  const WishBoardSection({super.key, required this.isDesktop});

  @override
  State<WishBoardSection> createState() => _WishBoardSectionState();
}

class _WishBoardSectionState extends State<WishBoardSection> {
  final TextEditingController _wishController = TextEditingController();
  late ConfettiController _confettiController;
  
  bool _sendToBride = true;
  bool _sendToGroom = false;

  String get _selectedRecipientText {
    if (_sendToBride && _sendToGroom) return 'Bride & Groom';
    if (_sendToBride) return 'Bride';
    if (_sendToGroom) return 'Groom';
    return 'Anyone';
  }
  bool _isEditing = true;
  bool _isSending = false;
  String _submittedWish = '';

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _wishController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_wishController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a wish first!')),
      );
      return;
    }
    
    // Split by spaces to check word count
    final words = _wishController.text.trim().split(RegExp(r'\s+'));
    if (words.length > 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wish must be 250 words or less')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isSending = false;
          _submittedWish = _wishController.text;
          _isEditing = false;
        });
        _confettiController.play();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wish sent successfully!')),
        );
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final double maxWidth = widget.isDesktop ? 800 : double.infinity;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: maxWidth,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFCFAF5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E0D8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Wish Board',
                  style: GoogleFonts.cinzel(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8C8665),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              if (!_isEditing && _submittedWish.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E0D8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To: $_selectedRecipientText',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8C8665),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _submittedWish,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Dropdown
                const Text('Send wishes to:', style: TextStyle(color: Color(0xFF8C8665), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _sendToBride,
                      activeColor: const Color(0xFF8C8665),
                      onChanged: (val) {
                        setState(() {
                          _sendToBride = val ?? false;
                          if (_sendToBride) {
                            _sendToGroom = false;
                          }
                        });
                      },
                    ),
                    const Text('Bride'),
                    const SizedBox(width: 24),
                    Checkbox(
                      value: _sendToGroom,
                      activeColor: const Color(0xFF8C8665),
                      onChanged: (val) {
                        setState(() {
                          _sendToGroom = val ?? false;
                          if (_sendToGroom) {
                            _sendToBride = false;
                          }
                        });
                      },
                    ),
                    const Text('Groom'),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Text Area
                TextFormField(
                  controller: _wishController,
                  maxLines: 6,
                  maxLength: 1500, // Approximate characters for 250 words
                  decoration: InputDecoration(
                    hintText: 'Write your wishes here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF8C8665), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    helperText: 'Max 250 words',
                  ),
                ),
                const SizedBox(height: 20),
                
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    _isSending
                        ? const Padding(
                            padding: EdgeInsets.only(right: 32.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Color(0xFF8C8665),
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _handleSend,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8C8665),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text('Send Wish', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
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
            ],
          ),
        ),
      ],
    );
  }
}
