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
  final double? maxWidth;
  final double? maxHeight;

  const RemoteImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.sports_martial_arts,
    this.maxWidth,
    this.maxHeight,
  });

  bool get _isEmpty => url == null || url!.trim().isEmpty;

  bool get _isAsset =>
      !_isEmpty && (url!.startsWith('assets/') || url!.startsWith('images/'));

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16.r);
    final double? effectiveWidth = _sanitize(width);
    final double? effectiveHeight = _sanitize(height);

    final Widget child;
    if (_isEmpty) {
      child = _placeholder(context, effectiveWidth, effectiveHeight);
    } else if (_isAsset) {
      child = Image.asset(
        url!,
        width: effectiveWidth,
        height: effectiveHeight,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return _loading(context, effectiveWidth, effectiveHeight);
        },
        errorBuilder: (context, error, stackTrace) => _placeholder(context, effectiveWidth, effectiveHeight),
      );
    } else {
      child = Image.network(
        url!,
        width: effectiveWidth,
        height: effectiveHeight,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return _loading(context, effectiveWidth, effectiveHeight);
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _loading(context, effectiveWidth, effectiveHeight);
        },
        errorBuilder: (context, error, stackTrace) => _placeholder(context, effectiveWidth, effectiveHeight),
      );
    }

    final double? sanitizedMaxWidth = _sanitize(maxWidth);
    final double? sanitizedMaxHeight = _sanitize(maxHeight);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: sanitizedMaxWidth ?? double.infinity,
        maxHeight: sanitizedMaxHeight ?? double.infinity,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          width: effectiveWidth,
          height: effectiveHeight,
          child: child,
        ),
      ),
    );
  }

  static double? _sanitize(double? value) {
    if (value == null) return null;
    if (value.isNaN || value.isInfinite) return null;
    if (value <= 0) return null;
    return value;
  }

  Widget _loading(BuildContext context, double? width, double? height) {
    final double w = _getSafeDimension(width, 100);
    final double h = _getSafeDimension(height, 100);
    return Container(
      width: w,
      height: h,
      color: context.palette.backgroundLight,
      child: Center(
        child: SizedBox(
          width: _safeW(24),
          height: _safeW(24),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryBlue.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context, double? width, double? height) {
    final double w = _getSafeDimension(width, 100);
    final double h = _getSafeDimension(height, 100);
    return Container(
      width: w,
      height: h,
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
          size: _safeW(h > 0 ? h * 0.36 : 48),
          color: Colors.white.withValues(alpha: 0.75),
        ),
      ),
    );
  }

  static double _getSafeDimension(double? value, double fallback) {
    if (value != null && value.isFinite && value > 0) return value;
    return fallback;
  }

  static double _safeW(double value) {
    try {
      return value.w;
    } catch (_) {
      return value;
    }
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

  static double _safeW(double value) {
    try {
      return value.w;
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final empty = url == null || url!.trim().isEmpty;
    final safeSize = _safeW(size);
    if (empty) {
      return Container(
        width: safeSize,
        height: safeSize,
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
        width: safeSize,
        height: safeSize,
        fit: BoxFit.cover,
        cacheWidth: (size * 2).round(),
        cacheHeight: (size * 2).round(),
        errorBuilder: (context, error, stackTrace) => AvatarImage(
          url: null,
          size: size,
          name: name,
        ),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: safeSize,
            height: safeSize,
            color: context.palette.backgroundLight,
          );
        },
      ),
    );
  }
}