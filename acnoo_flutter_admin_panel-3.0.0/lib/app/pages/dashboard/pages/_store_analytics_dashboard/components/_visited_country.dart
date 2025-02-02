import 'package:flutter/material.dart';

import '../../../../../core/theme/_app_colors.dart';

class VisitedCountryWidget extends StatelessWidget {
  const VisitedCountryWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.trailingColor,
    required this.ratingPercent,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final Color? trailingColor;
  final double ratingPercent;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final isPositive = ratingPercent >= 11;
    final color =
        isPositive ? AcnooAppColors.kSuccess : AcnooAppColors.kWarning;

    return ListTile(
      leading: Container(
        constraints: BoxConstraints.tight(Size.square(40)),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        title,
        style: _theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: color,
          ),
          Text(
            " ${isPositive ? "+" : ""}${ratingPercent.toString()}%",
            style: _theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
