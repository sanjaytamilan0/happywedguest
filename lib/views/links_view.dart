import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

// Basic
import '../templates/basic_template/digital_invitation_app.dart' as basic_inv;
import '../templates/basic_template/reception_screen.dart' as basic_rec;
import '../templates/basic_template/wedding_screen.dart' as basic_wed;

// Digital
import '../templates/digital_template/digital_invitation_app.dart' as digital_inv;
import '../templates/digital_template/reception_screen.dart' as digital_rec;
import '../templates/digital_template/wedding_screen.dart' as digital_wed;

// Advance
import '../templates/advance_template/digital_invitation_app.dart' as advance_inv;
import '../templates/advance_template/reception_screen.dart' as advance_rec;
import '../templates/advance_template/wedding_screen.dart' as advance_wed;

// Multiview
import '../templates/multiview_template/multiview_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/nav_provider.dart';
import '../widgets/template_preview_list.dart';

class LinksView extends ConsumerStatefulWidget {
  final bool isDesktop;

  const LinksView({super.key, required this.isDesktop});

  @override
  ConsumerState<LinksView> createState() => _LinksViewState();
}

class _LinksViewState extends ConsumerState<LinksView> {
  Widget _buildTemplateOption(BuildContext context, {required String title, required Widget child, required String templateId}) {
    final size = MediaQuery.of(context).size;
    final double screenWidth = size.width > size.height ? size.height * 0.5 : size.width;
    
    return GestureDetector(
      onTap: () {
        ref.read(selectedTemplateProvider.notifier).setTemplate(templateId);
      },
      child: Column(
        children: [
          SizedBox(
            width: screenWidth,
            height: 600,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Theme(
                data: ThemeData(scaffoldBackgroundColor: const Color(0xFFFCFAF5)),
                child: AbsorbPointer(
                  child: Navigator(
                    key: ValueKey(templateId),
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
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _selectedTemplate = ref.watch(selectedTemplateProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.isDesktop ? 64.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          if (_selectedTemplate != null) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                label: Text('Back to Invitations', style: GoogleFonts.montserrat(color: Colors.black87, fontWeight: FontWeight.bold)),
                onPressed: () {
                  ref.read(selectedTemplateProvider.notifier).setTemplate(null);
                },
              ),
            ),
            const SizedBox(height: 24),
            TemplatePreviewList(templateId: _selectedTemplate),
          ] else ...[
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 48,
              children: [
                _buildTemplateOption(
                  context,
                  title: 'Kunal & Simran',
                  child: const MultiviewThemeApp(isPreview: true),
                  templateId: 'multiview',
                ),
                _buildTemplateOption(
                  context,
                  title: 'Akshay & Krishna',
                  child: const basic_inv.DigitalInvitationApp(isPreview: true),
                  templateId: 'basic',
                ),
                _buildTemplateOption(
                  context,
                  title: 'Kaveri & Gangadhar',
                  child: const digital_inv.DigitalThemeApp(isPreview: true),
                  templateId: 'digital',
                ),
                _buildTemplateOption(
                  context,
                  title: 'Rohan & Priya',
                  child: const advance_inv.AdvanceThemeApp(isPreview: true),
                  templateId: 'advance',
                ),
              ],
            ),
          ],
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
