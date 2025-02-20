import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/item_unit/item_unit_service.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/shop/item_unit/widget/mod_item_unit_popup.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart' as l;
import '../../../core/theme/_app_colors.dart';
import '../../../models/shop/item_unit/item_unit.dart';

class ItemUnitInfoView extends StatefulWidget {
  const ItemUnitInfoView({super.key, required this.unitId});
  final int unitId;

  @override
  State<ItemUnitInfoView> createState() => _ItemUnitInfoViewState();
}

class _ItemUnitInfoViewState extends State<ItemUnitInfoView> {
  final ScrollController scrollController = ScrollController();
  final ItemUnitService itemUnitService = ItemUnitService();
  late Future<ItemUnit> itemUnit;

  //아이템 유닛 단일 조회
  Future<ItemUnit> getItemUnit() async {
    try{
      return await itemUnitService.getItemUnit(widget.unitId);
    } catch(e){
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  @override
  void initState(){
    super.initState();
    itemUnit = getItemUnit();
  }

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final lang = l.S.of(context);

    return FutureBuilder<ItemUnit>(
        future: itemUnit,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final itemUnit = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16), // 전체 패딩 추가
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      itemUnit.image,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                      },
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
                      buildProfileDetailRow(lang.sku, itemUnit.sku, textTheme),
                      _buildDivider(theme),
                      buildProfileDetailRow(lang.name, itemUnit.name, textTheme),
                      _buildDivider(theme),
                      buildProfileDetailRow(lang.description, itemUnit.description, textTheme),
                      _buildDivider(theme),
                      buildProfileDetailRow(lang.attributes, itemUnit.attributes, textTheme),
                      _buildDivider(theme),
                      buildProfileDetailRow(lang.type, itemUnit.type, textTheme),
                      _buildDivider(theme),
                      buildProfileDetailRow(lang.createdAt, itemUnit.createdAt.toString(), textTheme),
                      _buildDivider(theme),
                      buildProfileDetailRow(lang.updatedAt, itemUnit.updatedAt.toString(), textTheme),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  color: theme.colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      modAdminButton(textTheme, itemUnit),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  ElevatedButton modAdminButton(TextTheme textTheme, ItemUnit itemUnit) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        showModFormDialog(itemUnit);
      },
      label: Text(
        lang.modItemUnit,
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
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

  Widget buildProfileDetailRow(
      String label, String? value, TextTheme textTheme) {
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

  void showModFormDialog(ItemUnit itemUnit) async {
    bool success = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: ModItemUnitDialog(itemUnit: itemUnit));
      },
    );

    if (success) {
      setState(() {
        this.itemUnit = getItemUnit();
      });
    }
  }
}
