import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'media_full_screen_view.dart';

enum GalleryCategory { pictures, video, album }

class GalleryView extends StatefulWidget {
  final bool isDesktop;

  const GalleryView({super.key, required this.isDesktop});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  GalleryCategory _selectedCategory = GalleryCategory.pictures;
  String? _selectedFolder;

  final List<String> _folders = [
    'Pre-wedding',
    'Haldhi',
    'Mehendi',
    'Sangeet',
    'Wedding Ceremony',
    'Reception',
  ];

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
        _buildCategoryBox('Pictures', GalleryCategory.pictures),
        const SizedBox(width: 12),
        _buildCategoryBox('Video', GalleryCategory.video),
        const SizedBox(width: 12),
        _buildCategoryBox('Album', GalleryCategory.album),
      ],
    );
  }

  Widget _buildCategoryBox(String title, GalleryCategory category) {
    final isSelected = _selectedCategory == category;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCategory = category;
            if (category != GalleryCategory.album) {
              _selectedFolder = null; // Clear folder if navigating away from album
            }
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

  Widget _buildDynamicContent() {
    switch (_selectedCategory) {
      case GalleryCategory.pictures:
        return _buildPicturesGrid();
      case GalleryCategory.video:
        return _buildVideosGrid();
      case GalleryCategory.album:
        if (_selectedFolder == null) {
          return _buildFoldersGrid();
        } else {
          return _buildMediaGrid();
        }
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
      itemCount: 12, // Placeholder count
      itemBuilder: (context, index) {
        final url = 'https://placehold.co/800x800/png?text=Pic+$index';
        return GestureDetector(
          onTap: () => Get.dialog(MediaFullScreenView(url: url, isVideo: false), useSafeArea: false),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://placehold.co/400x400/png?text=Pic+$index',
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
        // Since picsum doesn't host real videos, using a reliable sample video for the full view
        // while keeping the picsum thumbnail
        final videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
        return GestureDetector(
          onTap: () => Get.dialog(MediaFullScreenView(url: videoUrl, isVideo: true), useSafeArea: false),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://placehold.co/400x400/png?text=Video+$index',
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

  Widget _buildFoldersGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.isDesktop ? 3 : 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _folders.length,
      itemBuilder: (context, index) {
        final folder = _folders[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedFolder = folder;
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

  Widget _buildMediaGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _selectedFolder = null;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _selectedFolder!,
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.isDesktop ? 4 : 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 8, // Placeholder count
          itemBuilder: (context, index) {
            final url = 'https://placehold.co/800x800/png?text=${_selectedFolder!.replaceAll(' ', '+')}+$index';
            return GestureDetector(
              onTap: () => Get.dialog(MediaFullScreenView(url: url, isVideo: false), useSafeArea: false),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://placehold.co/400x400/png?text=${_selectedFolder!.replaceAll(' ', '+')}+$index',
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
        ),
      ],
    );
  }
}
