import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart' as l;
import '../../../core/service/shop/item/item_service.dart';
import '../../../core/theme/_app_colors.dart';
import '../../../models/shop/item/item.dart';

class ItemInfoView extends StatefulWidget {
  const ItemInfoView({super.key, required this.itemId});
  final int itemId;

  @override
  State<ItemInfoView> createState() => _ItemInfoViewState();
}

class _ItemInfoViewState extends State<ItemInfoView> {
  final ScrollController scrollController = ScrollController();
  final ItemService itemService = ItemService();
  late Future<Item> item;

  //아이템 단일 조회
  Future<Item> getItem() async {
    try{
      return await itemService.getItem(widget.itemId);
    } catch(e){
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  @override
  void initState(){
    super.initState();
    item = getItem();
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

    return FutureBuilder<Item>(
        future: item,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final item = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16), // 전체 패딩 추가
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.image,
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
                        buildProfileDetailRow(lang.category, item.categoryId.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.itemUnit, item.itemUnitId.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.sku, item.sku, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.itemUnitSku, item.unitSku, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.name, item.name, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.description, item.description, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.num, item.num.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.stockQuantity, item.stockQuantity.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.status, item.status, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.info, item.info, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.periodType, item.periodType, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.period, item.period.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.expiration, item.expiration.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.type, item.currencyType, textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.amount, item.amount.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.createdAt, item.createdAt.toString(), textTheme),
                        _buildDivider(theme),
                        buildProfileDetailRow(lang.updatedAt, item.updatedAt.toString(), textTheme),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Container(
                    color: theme.colorScheme.primaryContainer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        modItemButton(textTheme, item),
                      ],
                    ),
                  )
                ],
              )
            )
          );
        });
  }

  ElevatedButton modItemButton(TextTheme textTheme, Item item) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        showModFormDialog(item);
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

  void showModFormDialog(Item item) async {
    bool success = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Text(''));
      },
    );

    if (success) {
      setState(() {
        this.item = getItem();
      });
    }
  }
}
