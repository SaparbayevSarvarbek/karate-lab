import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Ilovaning brend belgisi — gradient kvadrat ichida karate ikonkasi.
///
/// Sarlavha (AppBar), splash va onboarding ekranlarida ishlatiladi.
class KarateLabLogo extends StatelessWidget {
  final double size;

  const KarateLabLogo({super.key, this.size = 26});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryBlue, Color(0xFF2B7AFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(
        Icons.sports_martial_arts,
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }
}
