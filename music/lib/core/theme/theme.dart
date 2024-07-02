import 'package:flutter/material.dart';
import 'package:music/core/theme/app_pallete.dart';

final ThemeData theme = ThemeData(
  scaffoldBackgroundColor: AppPallete.transparentColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppPallete.transparentColor,
    iconTheme: IconThemeData(color: AppPallete.white),
  ),
  brightness: Brightness.dark,
  useMaterial3: true,
);

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({super.key, this.child, this.padding});

  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topLeft,
          colors: [
            AppPallete.transparentColor,
            AppPallete.gradient1,
            AppPallete.gradient2
          ],
        ),
      ),
      child: child,
    );
  }
}
