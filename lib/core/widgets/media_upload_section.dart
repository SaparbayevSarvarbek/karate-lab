import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../api/api_constants.dart';
import '../constants/app_colors.dart';
import '../l10n/app_translations.dart';
import '../theme/app_palette.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'app_list_tile.dart';
import 'app_snackbar.dart';

/// Yagona media karta — rasm YOKI video (faqat bittasi).
///
/// Karta bosilganda "Rasm / Video" tanlov oynasi chiqadi. Video tanlansa
/// rasm olib tashlanadi va aksincha. Tanlangan video pastki o'ngdagi play
/// tugmasi orqali bevosita ko'rib chiqiladi (autoplay emas — horizontal
/// haddan tashqari chiqmasligi uchun `Expanded`/`AspectRatio` bilan).
class MediaUploadSection extends StatefulWidget {
  final ValueChanged<File?>? onImagePicked;
  final ValueChanged<File?>? onVideoPicked;
  final String? initialImageUrl;

  const MediaUploadSection({
    super.key,
    this.onImagePicked,
    this.onVideoPicked,
    this.initialImageUrl,
  });

  @override
  State<MediaUploadSection> createState() => _MediaUploadSectionState();
}

class _MediaUploadSectionState extends State<MediaUploadSection> {
  File? _image;
  File? _video;
  late String? _initialImageUrl;
  final ImagePicker _picker = ImagePicker();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _initialImageUrl = widget.initialImageUrl;
  }

  Future<void> _choose() async {
    if (_busy) return;
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppMenuRow(
                icon: Icons.image_outlined,
                title: Tr.t('image'),
                tint: AppColors.primaryBlue,
                onTap: () => Navigator.of(sheetContext).pop('image'),
              ),
              const AppTileDivider(),
              AppMenuRow(
                icon: Icons.videocam_outlined,
                title: Tr.t('video'),
                tint: AppColors.success,
                onTap: () => Navigator.of(sheetContext).pop('video'),
              ),
              SizedBox(height: AppSpacing.sm.h),
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
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
      );
      if (picked != null) {
        setState(() {
          _image = File(picked.path);
          _video = null;
          _initialImageUrl = null;
        });
        widget.onImagePicked?.call(_image);
        widget.onVideoPicked?.call(null);
      }
    } catch (_) {
      _showToast(Tr.t('imagePickError'));
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
          _initialImageUrl = null;
        });
        widget.onVideoPicked?.call(_video);
        widget.onImagePicked?.call(null);
      }
    } catch (_) {
      _showToast(Tr.t('videoPickError'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showToast(String message) {
    if (!mounted) return;
    AppSnackbar.error(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final radius = BorderRadius.circular(AppRadius.card.r);
    return InkWell(
      onTap: _busy ? null : _choose,
      borderRadius: radius,
      child: Container(
        height: 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: palette.backgroundLight,
          borderRadius: radius,
          border: Border.all(
            color:
                (_image != null || _video != null || _initialImageUrl != null)
                ? AppColors.primaryBlue
                : palette.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: _busy
            ? const Center(child: CircularProgressIndicator())
            : _video != null
            ? _VideoPreview(file: _video!)
            : _image != null
            ? _buildImagePreview()
            : _initialImageUrl != null
            ? _buildExistingImagePreview()
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(_image!, fit: BoxFit.cover),
        PositionedDirectional(
          bottom: 0,
          start: 0,
          end: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
            color: Colors.black.withValues(alpha: 0.55),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  Tr.t('replaceImage'),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExistingImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          ApiConstants.resolveMediaUrl(_initialImageUrl!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        ),
        PositionedDirectional(
          bottom: 0,
          start: 0,
          end: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
            color: Colors.black.withValues(alpha: 0.55),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  Tr.t('replaceImage'),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    final palette = context.palette;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 40.w,
            color: palette.textHint,
          ),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            Tr.t('addImageOrVideo'),
            style: AppTextStyles.body.copyWith(color: palette.textHint),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            Tr.t('chooseOne'),
            style: AppTextStyles.caption.copyWith(color: palette.textHint),
          ),
        ],
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
                colors: [AppColors.primaryNavy, AppColors.gradientDeepBlue],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
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
        PositionedDirectional(
          start: 0,
          end: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
            color: Colors.black.withValues(alpha: 0.55),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videocam, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  Tr.t('tapToViewVideo'),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
