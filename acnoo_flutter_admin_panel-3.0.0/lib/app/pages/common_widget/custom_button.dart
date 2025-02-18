import 'package:flutter/material.dart';

import '../../core/theme/_app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.textTheme, required this.label, required this.onPressed});
  final TextTheme textTheme;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: onPressed,
      icon: const Icon(Icons.edit, color: AcnooAppColors.kWhiteColor),
      label: Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}