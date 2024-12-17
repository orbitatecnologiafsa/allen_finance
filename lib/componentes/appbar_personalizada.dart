import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.bottom, 
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final themeMode = AdaptiveTheme.of(context).mode;

    Color backgroundColor;
    if (themeMode == AdaptiveThemeMode.light) {
      backgroundColor = Colors.blue;
    } else if (themeMode == AdaptiveThemeMode.dark) {
      backgroundColor = themeData.colorScheme.surface;
    } else if (themeMode == AdaptiveThemeMode.system) {
      backgroundColor = MediaQuery.platformBrightnessOf(context) == Brightness.light
          ? themeData.colorScheme.primary
          : themeData.colorScheme.surface;
    } else {
      backgroundColor = themeData.colorScheme.surface;
    }

    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: true,
      leadingWidth: 80,
      title: Text(title),
      leading: leading,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)); // Adjust preferred size
}
