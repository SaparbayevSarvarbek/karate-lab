import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../theme/app_palette.dart';

class RemoteImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final IconData fallbackIcon;

  const RemoteImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.sports_martial_arts,
  });

  bool get _isEmpty => url == null || url!.trim().isEmpty;

  bool get _isAsset =>
      !_isEmpty && (url!.startsWith('assets/') || url!.startsWith('images/'));

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16.r);
    final Widget child;
    if (_isEmpty) {
      child = _placeholder(context);
    } else if (_isAsset) {
      child = Image.asset(
        url!,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return _loading(context);
        },
        errorBuilder: (context, error, stackTrace) => _placeholder(context),
      );
    } else {
      child = Image.network(
        url!,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return _loading(context);
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _loading(context);
        },
        errorBuilder: (context, error, stackTrace) => _placeholder(context),
      );
    }
    return ClipRRect(borderRadius: radius, child: child);
  }

  Widget _loading(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: context.palette.backgroundLight,
      child: Center(
        child: SizedBox(
          width: 24.w,
          height: 24.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryBlue.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryNavy,
            AppColors.primaryBlue.withValues(alpha: 0.55),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          fallbackIcon,
          size: (height != null && height! > 0 ? height! : 48.w) * 0.36,
          color: Colors.white.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}

class AvatarImage extends StatelessWidget {
  final String? url;
  final double size;
  final String name;

  const AvatarImage({
    super.key,
    required this.url,
    this.size = 44,
    this.name = '',
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first.characters.take(1).toString();
    final last = parts.length > 1 ? parts.last.characters.take(1).toString() : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final empty = url == null || url!.trim().isEmpty;
    if (empty) {
      return Container(
        width: size.w,
        height: size.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.primaryNavy],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            _initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
    return ClipOval(
      child: Image.network(
        url!,
        width: size.w,
        height: size.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => AvatarImage(
          url: null,
          size: size,
          name: name,
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: size.w,
            height: size.w,
            color: context.palette.backgroundLight,
          );
        },
      ),
    );
  }
}
