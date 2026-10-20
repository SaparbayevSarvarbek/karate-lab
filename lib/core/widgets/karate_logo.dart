import 'package:flutter/material.dart';

class KarateLabLogo extends StatelessWidget {
  final double size;

  const KarateLabLogo({super.key, this.size = 26});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(size * 0.04),
        child: Image.asset('assets/icon/app_icon.png', fit: BoxFit.contain),
      ),
    );
  }
}
