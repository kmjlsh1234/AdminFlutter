import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_period_type.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/utils/date_util.dart';
import '../../../../models/shop/item/item.dart';
import '../../../../widgets/dialog_header/_dialog_header.dart';
import '../../../common_widget/dotted_borderer_container.dart';


class BundleItemInfoDialog extends StatelessWidget {
  const BundleItemInfoDialog({
    super.key,
    required this.item,
  });
  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final lang = l.S.of(context);
    final _fontSize = responsiveValue<double>(
      context,
      xs: 12,
      sm: 12,
      md: 14,
      lg: 16,
    );

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
                DialogHeader(headerTitle: lang.item),
                // Task Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lang.thumbnail, style: textTheme.bodySmall),
                              const SizedBox(height: 8),
                              DottedBorderContainer(
                                child: GestureDetector(
                                  onTap: () => {}, child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.thumbnail,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lang.image, style: textTheme.bodySmall),
                              const SizedBox(height: 8),
                              DottedBorderContainer(
                                child: GestureDetector(
                                  onTap: () => {}, child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.image,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                ),
                                ),
                              ),
                            ],
                          )
                        ],
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
                            buildProfileDetailRow(lang.sku, item.sku, textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.name, item.name, textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.itemUnitSku, item.unitSku, textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.num, item.num?.toString() ?? '', textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.stockQuantity, item.stockQuantity?.toString() ?? '', textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.status, item.status.value, textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.periodType, item.periodType.value, textTheme),
                            _buildDivider(theme),
                            Visibility(
                              visible: item.periodType != ItemPeriodType.NONE,
                                child: Column(
                                  children: [
                                    buildProfileDetailRow(lang.period, item.period?.toString()??'', textTheme),
                                    _buildDivider(theme),
                                  ],
                                )
                            ),
                            buildProfileDetailRow(lang.amount, item.amount?.toString() ?? '', textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.createdAt, DateUtil.convertDateTimeToString(item.createdAt), textTheme),
                            _buildDivider(theme),
                            buildProfileDetailRow(lang.updatedAt, DateUtil.convertDateTimeToString(item.updatedAt), textTheme),
                            _buildDivider(theme),
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