import 'dart:ui';

import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/utils/date_util.dart';
import '../../../../models/shop/item_unit/item_unit.dart';
import '../../../../widgets/dialog_header/_dialog_header.dart';
import '../../../common_widget/dotted_borderer_container.dart';

class ItemUnitInfoDialog extends StatelessWidget {
  const ItemUnitInfoDialog({super.key, required this.itemUnit});
  final ItemUnit itemUnit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final lang = l.S.of(context);

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 610),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                //const DialogHeader(headerTitle: 'View Details'),
                DialogHeader(headerTitle: lang.itemUnit),
                // Task Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      Text(lang.image, style: textTheme.bodySmall),
                      const SizedBox(height: 8),
                      DottedBorderContainer(
                        child: GestureDetector(
                          onTap: () => {},
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                itemUnit.image,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              )
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16), // 표 내부 패딩 추가
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProfileDetailRow(lang.itemUnitSku, itemUnit.sku, textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.name, itemUnit.name, textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.description, itemUnit.description, textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.attributes, itemUnit.attributes, textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.type, itemUnit.type.value, textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.createdAt, DateUtil.convertDateTimeToString(itemUnit.createdAt), textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.updatedAt, DateUtil.convertDateTimeToString(itemUnit.updatedAt), textTheme),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      color: theme.colorScheme.outline,
      height: 12.0,
    );
  }

  Widget buildProfileDetailRow(String label, String? value, TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Text(
                  ':',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    value ?? "N/A",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}