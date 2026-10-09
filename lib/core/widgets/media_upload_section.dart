import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../constants/app_colors.dart';
import '../theme/app_palette.dart';

/// Yagona media karta — rasm YOKI video (faqat bittasi).
///
/// Karta bosilganda "Rasm / Video" tanlov oynasi chiqadi. Video tanlansa
/// rasm olib tashlanadi va aksincha. Tanlangan video pastki o'ngdagi play
/// tugmasi orqali bevosita ko'rib chiqiladi (autoplay emas — horizontal
/// haddan tashqari chiqmasligi uchun `Expanded`/`AspectRatio` bilan).
class MediaUploadSection extends StatefulWidget {
  final ValueChanged<File?>? onImagePicked;
  final ValueChanged<File?>? onVideoPicked;

  const MediaUploadSection({super.key, this.onImagePicked, this.onVideoPicked});

  @override
  State<MediaUploadSection> createState() => _MediaUploadSectionState();
}

class _MediaUploadSectionState extends State<MediaUploadSection> {
  File? _image;
  File? _video;
  final ImagePicker _picker = ImagePicker();
  bool _busy = false;

  Future<void> _choose() async {
    if (_busy) return;
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.palette.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) {
        final palette = sheetContext.palette;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: palette.border,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              SizedBox(height: 14.h),
              _SheetOption(
                icon: Icons.image_outlined,
                label: 'Rasm',
                color: AppColors.primaryBlue,
                onTap: () => Navigator.of(sheetContext).pop('image'),
              ),
              Divider(height: 1, color: palette.divider),
              _SheetOption(
                icon: Icons.videocam_outlined,
                label: 'Video',
                color: AppColors.success,
                onTap: () => Navigator.of(sheetContext).pop('video'),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );

    if (action == null || !mounted) return;
    if (action == 'image') {
      await _pickImage();
    } else {
      await _pickVideo();
    }
  }

  Future<void> _pickImage() async {
    setState(() => _busy = true);
    try {
      final picked =
          await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1600);
      if (picked != null) {
        setState(() {
          _image = File(picked.path);
          _video = null;
        });
        widget.onImagePicked?.call(_image);
        widget.onVideoPicked?.call(null);
      }
    } catch (_) {
      _showToast('Rasm tanlashda xatolik yuz berdi');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickVideo() async {
    setState(() => _busy = true);
    try {
      final picked = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );
      if (picked != null) {
        setState(() {
          _video = File(picked.path);
          _image = null;
        });
        widget.onVideoPicked?.call(_video);
        widget.onImagePicked?.call(null);
      }
    } catch (_) {
      _showToast('Video tanlashda xatolik yuz berdi');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showToast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _busy ? null : _choose,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.palette.backgroundLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: (_image != null || _video != null)
                ? AppColors.primaryBlue
                : AppColors.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _busy
            ? const Center(child: CircularProgressIndicator())
            : _video != null
                ? _VideoPreview(file: _video!)
                : _image != null
                    ? _buildImagePreview()
                    : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(_image!, fit: BoxFit.cover),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.black54,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text('Rasmni almashtirish',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined,
              size: 40.w, color: AppColors.textHint),
          SizedBox(height: 8.h),
          Text('Rasm yoki video qo\'shish',
              style: TextStyle(color: AppColors.textHint, fontSize: 13.sp)),
          SizedBox(height: 4.h),
          Text('Birini tanlang',
              style: TextStyle(color: AppColors.textHint, fontSize: 11.sp)),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24.w),
            SizedBox(width: 14.w),
            Text(
              label,
              style: TextStyle(
                color: palette.textPrimary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tanlangan lokal video faylni play/pause bilan ko'rsatuvchi old-ko'rinish.
/// `img video_player` dan foydalanadi — faqat bosilganda play qilinadi.
class _VideoPreview extends StatefulWidget {
  final File file;

  const _VideoPreview({required this.file});

  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  VideoPlayerController? _controller;
  bool _playing = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final controller = VideoPlayerController.file(widget.file);
    _controller = controller;
    try {
      await controller.initialize();
      controller.addListener(_listener);
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (_) {
      // play qilib bo'lmasa ham karta ko'rinib tursin
    }
  }

  void _listener() {
    if (!mounted) return;
    setState(() => _playing = _controller?.value.isPlaying ?? false);
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_ready && c != null)
          Center(
            child: AspectRatio(
              aspectRatio: c.value.aspectRatio,
              child: VideoPlayer(c),
            ),
          )
        else
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryNavy, Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        Container(color: Colors.black.withValues(alpha: 0.25)),
        Center(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!_ready || c == null) return;
              c.value.isPlaying ? c.pause() : c.play();
            },
            child: Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 36.w,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.black54,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text('Videoni ko\'rish uchun bosing',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}