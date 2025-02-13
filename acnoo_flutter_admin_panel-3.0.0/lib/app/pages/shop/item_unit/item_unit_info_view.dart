import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '../../../../generated/l10n.dart' as l;

import 'package:acnoo_flutter_admin_panel/app/core/constants/board/board_status.dart';
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/board/board_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/file/file_service.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/item_unit/item_unit_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/board/board_add_param.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

import '../../../models/shop/item_unit/item_unit.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';

class ItemUnitInfoView extends StatefulWidget {
  const ItemUnitInfoView({super.key, required this.unitId});
  final int unitId;
  @override
  State<ItemUnitInfoView> createState() => _ItemUnitInfoViewState();
}

class _ItemUnitInfoViewState extends State<ItemUnitInfoView> {
  final ScrollController _scrollController = ScrollController();
  final ItemUnitService itemUnitService = ItemUnitService();
  //SearchType
  //BoardType selectType = BoardType.NOTICE;
  //BoardStatus selectStatus = BoardStatus.PUBLISH;

  late ItemUnit itemUnit;
  bool isLoading = true;

  //아이템 유닛 단일 조회
  Future<void> getItemUnit() async {
    try{
      ItemUnit itemUnit = await itemUnitService.getItemUnit(widget.unitId);
      this.itemUnit = itemUnit;
      setState(() {
        isLoading = false;
      });
    } catch(e){
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void dispose(){
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState(){
    super.initState();
    getItemUnit();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final lang = l.S.of(context);

    return Padding(
      padding: const EdgeInsets.all(16), // 전체 패딩 추가
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
        children: [
          // 🔹 왼쪽 정렬된 이미지
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

          const SizedBox(height: 16), // 이미지와 표 사이 간격 추가

          // 🔹 표 컨테이너
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
                buildProfileDetailRow('${lang.sku}', itemUnit.sku, textTheme),
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
        ],
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
      padding: EdgeInsets.all(16),
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
                    value ?? "EMPTY",
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

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;

  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
