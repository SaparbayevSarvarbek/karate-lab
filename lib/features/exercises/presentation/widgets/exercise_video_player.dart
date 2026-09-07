import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_colors.dart';

class ExerciseVideoPlayer extends StatefulWidget {
  final String url;
  final double aspectRatio;

  const ExerciseVideoPlayer({
    super.key,
    required this.url,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _hasError = false;
  bool _buffering = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller = controller;
    try {
      await controller.initialize();
      controller.setLooping(true);
      controller.addListener(_onVideoEvent);
      if (!mounted) return;
      setState(() => _initialized = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _hasError = true);
    }
  }

  void _onVideoEvent() {
    final c = _controller;
    if (c == null || !mounted) return;
    final buffering = c.value.isBuffering;
    if (buffering != _buffering) setState(() => _buffering = buffering);
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoEvent);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: _hasError
            ? _error(context)
            : (!_initialized || c == null)
                ? _loading(context)
                : Stack(
                    children: [
                      Center(child: AspectRatio(aspectRatio: c.value.aspectRatio, child: VideoPlayer(c))),
                      if (_buffering)
                        const Center(
                          child: CircularProgressIndicator(color: Colors.white70),
                        ),
                      _ControlsOverlay(controller: c),
                    ],
                  ),
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryNavy, Color(0xFF1E3A8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const Center(child: CircularProgressIndicator(color: Colors.white70)),
      ],
    );
  }

  Widget _error(BuildContext context) {
    return Container(
      color: AppColors.primaryNavy,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off_rounded, size: 36.w, color: Colors.white54),
          SizedBox(height: 8.h),
          Text(
            'Videoni yuklab bo\'lmadi',
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;

  const _ControlsOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    final value = controller.value;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        value.isPlaying ? controller.pause() : controller.play();
      },
      child: Stack(
        children: [
          if (!value.isPlaying)
            Container(color: Colors.black.withValues(alpha: 0.3)),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: value.isPlaying ? 0.0 : 0.45),
                shape: BoxShape.circle,
              ),
              child: Icon(
                value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 36.w,
                color: value.isPlaying ? Colors.transparent : Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 12.w,
            right: 12.w,
            bottom: 10.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  padding: EdgeInsets.zero,
                  colors: const VideoProgressColors(
                    playedColor: AppColors.primaryBlue,
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.white12,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 16.w,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${_fmt(value.position)} / ${_fmt(value.duration)}',
                      style: TextStyle(color: Colors.white, fontSize: 11.sp),
                    ),
                    const Spacer(),
                    const Icon(Icons.all_inclusive_rounded, color: Colors.white54, size: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class VideoThumbnailCard extends StatelessWidget {
  final String videoUrl;
  final VoidCallback onTap;
  final double height;
  final String? imageUrl;

  const VideoThumbnailCard({
    super.key,
    required this.videoUrl,
    required this.onTap,
    this.height = 200,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: const LinearGradient(
            colors: [AppColors.primaryNavy, Color(0xFF1E3A8A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, e, s) => const SizedBox.shrink(),
                ),
              ),
            Container(color: Colors.black.withValues(alpha: 0.35)),
            Center(
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Icon(Icons.play_arrow_rounded, size: 40.w, color: AppColors.primaryNavy),
              ),
            ),
            Positioned(
              left: 12.w,
              bottom: 10.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.videocam_rounded, size: 14.w, color: Colors.white),
                    SizedBox(width: 4.w),
                    Text('Video dars', style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatusBadge({super.key, required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13.w, color: color),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: TextStyle(color: color, fontSize: 11.5.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
