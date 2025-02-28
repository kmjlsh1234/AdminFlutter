import 'package:acnoo_flutter_admin_panel/app/constants/shop/item/item_search_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/shop/item/item_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/shop/item/item_search_param.dart';
import 'package:flutter/material.dart';

import '../../../../../../generated/l10n.dart' as l;
import '../../../../core/error/error_handler.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/shop/item/item.dart';

class SearchBundleItemDialog extends StatefulWidget {
  const SearchBundleItemDialog({super.key});

  @override
  State<SearchBundleItemDialog> createState() => _SearchBundleItemDialogState();
}

class _SearchBundleItemDialogState extends State<SearchBundleItemDialog> {

  final TextEditingController searchController = TextEditingController();
  final ItemService itemService = ItemService();

  //Search
  ItemSearchType itemSearchType = ItemSearchType.name;
  List<Item> searchResults = [];
  //아이템 검색
  Future<void> searchItem() async {
    try{
      ItemSearchParam itemSearchParam = ItemSearchParam(
          searchType: itemSearchType.value,
          searchValue: searchController.text,
          page: 1,
          limit: 10,
      );
      /*
      ItemSingleSearchParam itemSingleSearchParam = ItemSingleSearchParam(
          searchType: itemSearchType.value,
          searchValue: searchController.text
      );

      Item item = await itemService.searchItem(itemSingleSearchParam);
      if(item == null){
        throw CustomException(ErrorCode.ITEM_NOT_EXIST);
      }

      Navigator.of(context).pop(item);
       */

      List<Item> itemList = await itemService.getItemList(itemSearchParam);

      setState(() {
        searchResults = itemList;
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
    final _sizeInfo = SizeConfig.getSizeInfo(context);
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
                    DropdownButtonFormField<ItemSearchType>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: itemSearchType,
                      hint: Text(
                        lang.selectYouStatus,
                        style: textTheme.bodySmall,
                      ),
                      items: ItemSearchType.values.map((type) {
                        return DropdownMenuItem<ItemSearchType>(
                          value: type,
                          child: Text(type.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          itemSearchType = value!;
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
                                onPressed: () => searchItem(),
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