import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../theme/app_palette.dart';

/// Rasm va video yuklash bo'limi.
///
/// Rasm tanlanganda oldindan ko'rish ko'rsatiladi, video tanlanganda esa
/// fayl nomi ko'rsatiladi. Xatoliklar toast orqali chiqadi (crash qilmaydi).
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
  String? _videoName;
  final ImagePicker _picker = ImagePicker();
  bool _busy = false;

  Future<void> _pickImage() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1600);
      if (picked != null) {
        setState(() => _image = File(picked.path));
        widget.onImagePicked?.call(_image);
      }
    } catch (_) {
      _showToast('Rasm tanlashda xatolik yuz berdi');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickVideo() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final picked = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );
      if (picked != null) {
        setState(() {
          _video = File(picked.path);
          _videoName = picked.name;
        });
        widget.onVideoPicked?.call(_video);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Media', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        _buildThumbnailPicker(context),
        const SizedBox(height: 12),
        _buildVideoPicker(context),
      ],
    );
  }

  Widget _buildThumbnailPicker(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: _busy ? null : _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          color: palette.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: _image != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(_image!, fit: BoxFit.cover),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black54,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text('Rasmni almashtirish', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 40, color: AppColors.textHint),
                    SizedBox(height: 8),
                    Text('Rasm qo\'shish', style: TextStyle(color: AppColors.textHint)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildVideoPicker(BuildContext context) {
    final palette = context.palette;
    return InkWell(
      onTap: _busy ? null : _pickVideo,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.video_library_outlined, color: AppColors.primaryBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _videoName ?? 'Video qo\'shish',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _videoName != null ? AppColors.textPrimary : AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
