import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PropveilCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final double radius;
  final bool hasGlow;

  const PropveilCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.backgroundColor = PropveilTheme.surfaceNavy,
    this.radius = 20.0,
    this.hasGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: hasGlow ? PropveilTheme.tealAccent.withOpacity(0.5) : PropveilTheme.borderSubtle,
          width: 1.0,
        ),
        boxShadow: hasGlow 
            ? [
                BoxShadow(
                  color: PropveilTheme.tealAccent.withOpacity(0.15),
                  blurRadius: 15,
                  spreadRadius: -2,
                )
              ]
            : null,
      ),
      padding: padding,
      child: child,
    );
  }
}
