import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:acnoo_flutter_admin_panel/generated/l10n.dart' as l;

class StoreOverviewWidget extends StatefulWidget {
  const StoreOverviewWidget({
    super.key,
    required this.color,
    required this.title,
    required this.value,
    required this.subAmount,
    required this.icon,
  });
  final Color color;
  final String title;
  final String value;
  final String subAmount;
  final String icon;

  @override
  State<StoreOverviewWidget> createState() => _StoreOverviewWidgetState();
}

class _StoreOverviewWidgetState extends State<StoreOverviewWidget> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _lang = l.S.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsetsDirectional.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: widget.color.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: '+${widget.subAmount} ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onTertiary,
                    ),
                    children: [
                      TextSpan(
                        text: _lang.fromYesterday,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: -15,
            end: -30,
            child: CircleAvatar(
              radius: 57,
              backgroundColor: widget.color.withOpacity(0.15),
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 22,
                  bottom: 25,
                  top: 35,
                  end: 44,
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: widget.color,
                  child: SvgPicture.asset(widget.icon),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
