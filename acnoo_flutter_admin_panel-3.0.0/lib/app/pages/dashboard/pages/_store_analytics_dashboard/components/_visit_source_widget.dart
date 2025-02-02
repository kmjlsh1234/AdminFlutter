import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/static/static.dart';
import '../../../../../core/theme/theme.dart';

class VisitSourceWidget extends StatelessWidget {
  const VisitSourceWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.trailingColor,
    required this.amount,
    required this.ratingPercent,
  });
  final SvgImageHolder imagePath;
  final String title;
  final Color? trailingColor;
  final String subtitle;
  final double amount;
  final double ratingPercent;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _theme.colorScheme.outline,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: EdgeInsets.all(8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: imagePath.baseColor?.withOpacity(0.1),
          ),
          constraints: BoxConstraints.tight(const Size.square(40)),
          child: SvgPicture.asset(
            imagePath.svgPath,
            height: 20,
            width: 20,
          ),
        ),
        title: Text(
          title,
          style: _theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 6,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(4),
            color: trailingColor?.withOpacity(0.1),
          ),
          child: Text.rich(
            TextSpan(
              text: amount.toString(),
              style: _theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text:
                      " ${ratingPercent < 0 ? "" : "+"}${ratingPercent.toString()}%",
                  style: _theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ratingPercent < 0
                        ? AcnooAppColors.kError
                        : AcnooAppColors.kSuccess,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
