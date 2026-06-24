import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../views/media_full_screen_view.dart';

enum MediaType { pictures, videos }

class HomeGallerySection extends StatefulWidget {
  final bool isDesktop;
  const HomeGallerySection({super.key, required this.isDesktop});

  @override
  State<HomeGallerySection> createState() => _HomeGallerySectionState();
}

class _HomeGallerySectionState extends State<HomeGallerySection> {
  String? _selectedAlbum;
  MediaType _selectedMediaType = MediaType.pictures;

  final List<String> _albums = [
    'Pre-wedding',
    'Haldhi',
    'Mehendi',
    'Sangeet',
    'Wedding Ceremony',
    'Reception',
  ];

  final List<String> _photos = [
    'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1583939003579-730e3918a45a?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1519225421980-715cb0215aed?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1469334031218-e382a71b716b?q=80&w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1606800052052-a08af7148866?q=80&w=800&auto=format&fit=crop',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedAlbum == null) ...[
          Center(
            child: Text(
              'Gallery',
              style: GoogleFonts.cinzel(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF8C8665),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          _buildAlbumList(),
        ] else ...[
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedAlbum = null;
                    _selectedMediaType = MediaType.pictures;
                  });
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _selectedAlbum!,
                  style: GoogleFonts.lora(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildMediaTabs(),
          const SizedBox(height: 24),
          _buildMediaGrid(),
        ],
      ],
    );
  }

  Widget _buildAlbumList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.isDesktop ? 3 : 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        final folder = _albums[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAlbum = folder;
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
                  Icons.photo_library,
                  size: 48,
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
    if (_selectedMediaType == MediaType.pictures) {
      return _buildPicturesGrid();
    } else {
      return _buildVideosGrid();
    }
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
      itemCount: 8,
      itemBuilder: (context, index) {
        final url = _photos[index % _photos.length];
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
      itemCount: 4,
      itemBuilder: (context, index) {
        final videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
        final thumbnailUrl = _photos[(index + 2) % _photos.length];
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
