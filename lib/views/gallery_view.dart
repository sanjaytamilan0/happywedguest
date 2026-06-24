import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'media_full_screen_view.dart';
import '../widgets/template_preview_list.dart';
import '../providers/nav_provider.dart';

enum MediaType { pictures, videos }

class GalleryView extends ConsumerStatefulWidget {
  final bool isDesktop;

  const GalleryView({super.key, required this.isDesktop});

  @override
  ConsumerState<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends ConsumerState<GalleryView> {
  Map<String, String>? _selectedInvitation;
  String? _selectedCeremony;
  MediaType _selectedMediaType = MediaType.pictures;

  final List<Map<String, String>> _invitations = [
    {'title': 'Kunal & Simran', 'templateId': 'multiview', 'status': 'Confirmed'},
    {'title': 'Akshay & Krishna', 'templateId': 'basic', 'status': 'Pending'},
    {'title': 'Kaveri & Gangadhar', 'templateId': 'digital', 'status': 'Declined'},
    {'title': 'Rohan & Priya', 'templateId': 'advance', 'status': 'Confirmed'},
  ];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  final List<String> _ceremonies = [
    'Invitation',
    'Pre-wedding',
    'Haldhi',
    'Mehendi',
    'Sangeet',
    'Wedding Ceremony',
    'Reception',
  ];

  final List<String> _weddingPhotos = [
    'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1583939003579-730e3918a45a?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1519225421980-715cb0215aed?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1469334031218-e382a71b716b?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1606800052052-a08af7148866?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1520854221256-17451cc331bf?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1543886167-96a86e9e4f4b?q=80&w=800&auto=format&fit=crop',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedInvitation == null) ...[
          _buildHeader('Invitations'),
          const SizedBox(height: 24),
          _buildInvitationList(),
        ] else if (_selectedCeremony == null) ...[
          _buildHeaderWithBack(_selectedInvitation!['title']!, () {
            setState(() {
              _selectedInvitation = null;
            });
            Future.microtask(() => ref.read(isInvitationSelectedProvider.notifier).setSelection(false));
          }),
          const SizedBox(height: 24),
          _buildCeremonyList(),
        ] else ...[
          _buildHeaderWithBack(_selectedCeremony!, () {
            setState(() {
              _selectedCeremony = null;
              _selectedMediaType = MediaType.pictures;
            });
          }),
          const SizedBox(height: 24),
          if (_selectedCeremony != 'Invitation') ...[
            _buildMediaTabs(),
            const SizedBox(height: 24),
          ],
          _buildMediaGrid(),
        ],
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Center(
      child: Text(
        title,
        style: GoogleFonts.cinzel(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF8C8665),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildHeaderWithBack(String title, VoidCallback onBack) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.cinzel(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF8C8665),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _invitations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final invitation = _invitations[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedInvitation = invitation;
            });
            Future.microtask(() => ref.read(isInvitationSelectedProvider.notifier).setSelection(true));
          },
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invitation['title']!,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(invitation['status']!).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _getStatusColor(invitation['status']!).withOpacity(0.5)),
                        ),
                        child: Text(
                          invitation['status']!.toUpperCase(),
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(invitation['status']!),
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCeremonyList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.isDesktop ? 3 : 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _ceremonies.length,
      itemBuilder: (context, index) {
        final folder = _ceremonies[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCeremony = folder;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withAlpha(204),
                ),
                const SizedBox(height: 16),
                Text(
                  folder,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaTabs() {
    return Row(
      children: [
        _buildMediaTab('Pictures', MediaType.pictures),
        const SizedBox(width: 12),
        _buildMediaTab('Videos', MediaType.videos),
      ],
    );
  }

  Widget _buildMediaTab(String title, MediaType type) {
    final isSelected = _selectedMediaType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMediaType = type;
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
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaGrid() {
    if (_selectedCeremony == 'Invitation') {
      return _buildInvitationTemplateView();
    }
    if (_selectedMediaType == MediaType.pictures) {
      return _buildPicturesGrid();
    } else {
      return _buildVideosGrid();
    }
  }

  Widget _buildInvitationTemplateView() {
    return Center(
      child: TemplatePreviewList(templateId: _selectedInvitation!['templateId']!),
    );
  }

  Widget _buildPicturesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.isDesktop ? 4 : 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 12, // Placeholder count
      itemBuilder: (context, index) {
        final url = _weddingPhotos[(index + 5) % _weddingPhotos.length];
        return GestureDetector(
          onTap: () => Get.dialog(MediaFullScreenView(url: url, isVideo: false), useSafeArea: false),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Skeletonizer(
                  enabled: true,
                  child: Container(color: Colors.grey[300]),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideosGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.isDesktop ? 3 : 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6, // Placeholder count
      itemBuilder: (context, index) {
        final videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
        final thumbnailUrl = _weddingPhotos[(index + 3) % _weddingPhotos.length];
        return GestureDetector(
          onTap: () => Get.dialog(MediaFullScreenView(url: videoUrl, isVideo: true), useSafeArea: false),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Skeletonizer(
                      enabled: true,
                      child: Container(color: Colors.grey[300]),
                    );
                  },
                ),
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
