import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class MediaFullScreenView extends StatefulWidget {
  final String url;
  final bool isVideo;

  const MediaFullScreenView({
    super.key,
    required this.url,
    required this.isVideo,
  });

  @override
  State<MediaFullScreenView> createState() => _MediaFullScreenViewState();
}

class _MediaFullScreenViewState extends State<MediaFullScreenView> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          _videoController?.setVolume(0.0); // Required for autoplay on Web
          _videoController?.play();
          _videoController?.setLooping(true);
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _shareToWhatsApp() async {
    final String text = 'Check out this memory from the wedding: ${widget.url}';
    final Uri whatsappUrl = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(text)}');
    final Uri webWhatsappUrl = Uri.parse('https://api.whatsapp.com/send?text=${Uri.encodeComponent(text)}');

    try {
      // Bypassing canLaunchUrl since Web/Mobile block schemes without manifest entries
      await launchUrl(webWhatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  Future<void> _downloadMedia() async {
    if (kIsWeb) {
      try {
        final anchor = html.AnchorElement(href: widget.url)
          ..setAttribute("download", "wedding_memory.jpg")
          ..target = "blank";
        anchor.click();
        return;
      } catch (e) {
        // Fallback to URL launch if HTML anchor fails
      }
    }

    final Uri downloadUrl = Uri.parse(widget.url);
    try {
      await launchUrl(downloadUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not download media')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Media Content
            Center(
              child: widget.isVideo
                  ? (_videoController != null && _videoController!.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        )
                      : Skeletonizer(
                          enabled: true,
                          effect: ShimmerEffect(
                            baseColor: Colors.grey[800]!,
                            highlightColor: Colors.grey[600]!,
                          ),
                          child: const Bone.square(size: 300),
                        ))
                  : InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4,
                      child: Image.network(
                        widget.url,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Skeletonizer(
                            enabled: true,
                            effect: ShimmerEffect(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[600]!,
                            ),
                            child: const Bone.square(size: 300),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.broken_image, color: Colors.white54, size: 50),
                                SizedBox(height: 16),
                                Text('Image could not be loaded', style: TextStyle(color: Colors.white54)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),

            // Top Gradient Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Close Button
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),

            // Action Buttons
            Positioned(
              bottom: 30,
              right: 30,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'download_btn',
                    onPressed: _downloadMedia,
                    backgroundColor: Colors.white,
                    child: const FaIcon(FontAwesomeIcons.download, color: Colors.black87),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: 'share_btn',
                    onPressed: _shareToWhatsApp,
                    backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                    child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
