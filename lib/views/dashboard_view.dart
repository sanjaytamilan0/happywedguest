import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/nav_provider.dart';
import '../widgets/template_preview_list.dart';

enum DashboardCategory { newInv, pending, accepted, rejected }

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  DashboardCategory _selectedCategory = DashboardCategory.newInv;
  String? _selectedEventTemplate;

  @override
  Widget build(BuildContext context) {
    if (_selectedEventTemplate != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              label: Text('Back to Events', style: GoogleFonts.montserrat(color: Colors.black87, fontWeight: FontWeight.bold)),
              onPressed: () {
                setState(() {
                  _selectedEventTemplate = null;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          TemplatePreviewList(templateId: _selectedEventTemplate!),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategorySelector(),
        const SizedBox(height: 32),
        _buildDynamicContent(),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Row(
      children: [
        _buildCategoryBox('New', DashboardCategory.newInv),
        const SizedBox(width: 8),
        _buildCategoryBox('Pending', DashboardCategory.pending),
        const SizedBox(width: 8),
        _buildCategoryBox('Accepted', DashboardCategory.accepted),
        const SizedBox(width: 8),
        _buildCategoryBox('Rejected', DashboardCategory.rejected),
      ],
    );
  }

  Widget _buildCategoryBox(String title, DashboardCategory category) {
    final isSelected = _selectedCategory == category;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.transparent : Colors.grey.withAlpha(51),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withAlpha(76),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicContent() {
    switch (_selectedCategory) {
      case DashboardCategory.newInv:
        return _buildEventList(
          'New Events',
          [
            {'name': 'Akshay & Krishna', 'date': 'July 19, 2022', 'venue': 'Krishna Resorts', 'templateId': 'basic'},
          ],
        );
      case DashboardCategory.pending:
        return _buildEventList(
          'Pending Events',
          [
            {'name': 'Kaveri & Gangadhar', 'date': 'August 14, 2022', 'venue': 'The Grand Palace', 'templateId': 'digital'},
          ],
        );
      case DashboardCategory.accepted:
        return _buildEventList(
          'Accepted Events',
          [
            {'name': 'Rohan & Priya', 'date': 'September 20, 2022', 'venue': 'Royal Gardens', 'templateId': 'advance'},
            {'name': 'Kunal & Simran', 'date': 'October 05, 2022', 'venue': 'Taj Hotel', 'templateId': 'multiview'},
          ],
        );
      case DashboardCategory.rejected:
        return _buildEventList(
          'Rejected Events',
          [],
        );
    }
  }

  Widget _buildEventList(String title, List<Map<String, String>> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (events.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'No events found.',
                style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFD83076).withOpacity(0.1),
                    child: const Icon(Icons.event, color: Color(0xFFD83076)),
                  ),
                  title: Text(
                    '${event['name']}\'s Wedding',
                    style: GoogleFonts.lora(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${event['date']} • ${event['venue']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      if (event['templateId'] != null) {
                        setState(() {
                          _selectedEventTemplate = event['templateId'];
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFCF9F6),
                      foregroundColor: const Color(0xFFD83076),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Color(0xFFD83076)),
                      ),
                    ),
                    child: const Text('View'),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
