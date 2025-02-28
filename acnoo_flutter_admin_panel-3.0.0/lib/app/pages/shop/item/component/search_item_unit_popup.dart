import 'package:flutter/material.dart';

import '../../../../../../generated/l10n.dart' as l;
import '../../../../constants/shop/item_unit/item_unit_search_type.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/service/shop/item_unit/item_unit_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../models/shop/item_unit/item_unit.dart';
import '../../../../models/shop/item_unit/item_unit_search_param.dart';

class SearchItemUnitDialog extends StatefulWidget {
  const SearchItemUnitDialog({super.key});

  @override
  State<SearchItemUnitDialog> createState() => _SearchItemUnitDialogState();
}

class _SearchItemUnitDialogState extends State<SearchItemUnitDialog> {

  final TextEditingController searchController = TextEditingController();
  final ItemUnitService itemUnitService = ItemUnitService();

  //Search
  ItemUnitSearchType itemUnitSearchType = ItemUnitSearchType.name;
  List<ItemUnit> searchResults = [];

  //아이템 유닛 검색
  Future<void> searchItemUnit() async {
    try{
      ItemUnitSearchParam itemUnitSearchParam = ItemUnitSearchParam(
          searchType: itemUnitSearchType.value,
          searchValue: searchController.text,
          page: 1,
          limit: 10
      );

      List<ItemUnit> itemUnitList = await itemUnitService.getItemUnitList(itemUnitSearchParam);

      setState(() {
        searchResults = itemUnitList;
      });
    } catch(e) {
      ErrorHandler.handleError(e, context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///---------------- header section
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang.formDialog),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    icon: const Icon(
                      Icons.close,
                      color: AcnooAppColors.kError,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.1,
              color: theme.colorScheme.outline,
              height: 0,
            ),

            ///---------------- Search Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 606,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///---------------- 검색 타입 선택 (Dropdown)
                    Text(lang.type, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<ItemUnitSearchType>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: itemUnitSearchType,
                      hint: Text(
                        lang.selectYouStatus,
                        style: textTheme.bodySmall,
                      ),
                      items: ItemUnitSearchType.values.map((type) {
                        return DropdownMenuItem<ItemUnitSearchType>(
                          value: type,
                          child: Text(type.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          itemUnitSearchType = value!;
                        });
                      },
                      validator: (value) =>
                      value == null ? lang.pleaseSelectAPosition : null,
                    ),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.primary, width: 1), // 외곽선 추가
                        borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                        color: theme.colorScheme.surfaceVariant, // 배경색 추가 (선택적)
                      ),
                      child: Column(
                        children: [
                          ///---------------- 검색 입력 필드
                          TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: lang.enterYourFullName,
                              hintStyle: textTheme.bodySmall,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.zero,
                                ),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search, color: theme.colorScheme.primary),
                                onPressed: () => searchItemUnit(),
                              ),
                            ),
                            validator: (value) =>
                            value?.isEmpty ?? true ? lang.pleaseEnterYourFullName : null,
                          ),

                          ///---------------- 검색 결과 리스트
                          if (searchResults.isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                color: theme.colorScheme.surface, // 배경색 통일
                              ),
                              height: 200,
                              child: ListView.builder(
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  final item = searchResults[index];
                                  return ListTile(
                                    title: Text(item.name, style: textTheme.bodyMedium),
                                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: () {
                                      Navigator.of(context).pop(item);
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}