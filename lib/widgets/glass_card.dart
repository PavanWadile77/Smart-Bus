import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(AppConstants.defaultPadding),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(200), // ~80% opacity
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            border: Border.all(color: Colors.white.withAlpha(25)),
          ),
          child: child,
        ),
      ),
    );
  }
}
