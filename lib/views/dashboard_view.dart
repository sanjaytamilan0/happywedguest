import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum DashboardCategory { newInv, pending, accepted, rejected }

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DashboardCategory _selectedCategory = DashboardCategory.newInv;

  @override
  Widget build(BuildContext context) {
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
        return _buildInvitationList('New Invitations');
      case DashboardCategory.pending:
        return _buildInvitationList('Pending Invitations');
      case DashboardCategory.accepted:
        return _buildInvitationList('Accepted Invitations');
      case DashboardCategory.rejected:
        return _buildInvitationList('Rejected Invitations');
    }
  }

  Widget _buildInvitationList(String title) {
    final List<String> dummyCouples = [
      'Sanjay & Priya',
      'Rahul & Anjali',
      'Karthik & Meera',
      'Arjun & Neha',
      'Vikram & Shruti'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lora(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFD83076).withOpacity(0.1),
                  child: const Icon(Icons.favorite, color: Color(0xFFD83076)),
                ),
                title: Text(
                  '${dummyCouples[index % dummyCouples.length]}\'s Wedding',
                  style: GoogleFonts.lora(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('You are invited to join the celebration!'),
                trailing: ElevatedButton(
                  onPressed: () {},
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
