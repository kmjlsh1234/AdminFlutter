import 'package:flutter/material.dart';
import '../../../../../core/helpers/fuctions/_get_image.dart';
import '../../../../../core/theme/_app_colors.dart';

class StoreTopSellingItem extends StatelessWidget {
  const StoreTopSellingItem({
    super.key,
    this.imagePath,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.trailingColor,
  });
  final String? imagePath;
  final String title;
  final String trailing;
  final Color? trailingColor;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return ListTile(
      leading: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        constraints: BoxConstraints.tight(const Size.square(40)),
        child: AnimageWidget(
          imagePath: imagePath,
          fit: BoxFit.cover,
          height: double.maxFinite,
          width: double.maxFinite,
        ),
      ),
      title: Text(
        title,
        style: _theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle,
      trailing: Text(
        trailing,
        style: _theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: trailingColor,
        ),
      ),
    );
  }
}

Widget buildReview(
  BuildContext context, {
  double rating = 0.0,
  int reviews = 0,
}) {
  assert(rating <= 5 && rating >= 0, "Rating must be between 0 and 5");

  final _theme = Theme.of(context);

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Row to display stars
      Flexible(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            5,
            (index) {
              final _hasRating = index < rating;
              return Flexible(
                child: Icon(
                  _hasRating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: _hasRating ? Colors.amber : AcnooAppColors.kNeutral300,
                ),
              );
            },
          ),
        ),
      ),

      Text(
        "($reviews)",
        style: _theme.textTheme.bodyMedium?.copyWith(
          color: _theme.colorScheme.onTertiary,
        ),
      )
    ],
  );
}
