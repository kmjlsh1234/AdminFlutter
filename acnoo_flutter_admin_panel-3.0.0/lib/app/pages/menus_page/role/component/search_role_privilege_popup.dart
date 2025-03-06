import 'package:acnoo_flutter_admin_panel/app/constants/menus/privilege/privilege_serach_type.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/menus/role_privilege_service.dart';
import 'package:acnoo_flutter_admin_panel/app/models/menus/privilege/privilege_search_param.dart';
import 'package:flutter/material.dart';

import '../../../../../../generated/l10n.dart' as l;
import '../../../../core/error/error_handler.dart';
import '../../../../core/service/menus/privilege_service.dart';
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/menus/privilege/privilege.dart';

class SearchRolePrivilegeDialog extends StatefulWidget {
  const SearchRolePrivilegeDialog({super.key});

  @override
  State<SearchRolePrivilegeDialog> createState() => _SearchRolePrivilegeDialogState();
}

class _SearchRolePrivilegeDialogState extends State<SearchRolePrivilegeDialog> {

  final TextEditingController searchController = TextEditingController();
  final PrivilegeService privilegeService = PrivilegeService();
  final RolePrivilegeService rolePrivilegeService = RolePrivilegeService();

  //Search
  PrivilegeSearchType privilegeSearchType = PrivilegeSearchType.NAME;
  List<Privilege> searchResults = [];

  //권한 검색
  Future<void> searchPrivilege() async {
    try{
      PrivilegeSearchParam privilegeSearchParam = PrivilegeSearchParam(
          searchType: privilegeSearchType,
          searchValue: searchController.text,
          page: 1,
          limit: 10
      );

      List<Privilege> privilegeList = await privilegeService.getPrivilegeList(privilegeSearchParam);

      setState(() {
        searchResults = privilegeList;
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
                  Text(lang.rolePrivilege),
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
                    DropdownButtonFormField<PrivilegeSearchType>(
                      dropdownColor: theme.colorScheme.primaryContainer,
                      value: privilegeSearchType,
                      hint: Text(
                        lang.selectYouStatus,
                        style: textTheme.bodySmall,
                      ),
                      items: PrivilegeSearchType.values.map((type) {
                        return DropdownMenuItem<PrivilegeSearchType>(
                          value: type,
                          child: Text(type.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          privilegeSearchType = value!;
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
                                onPressed: () => searchPrivilege(),
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
                                  final privilege = searchResults[index];
                                  return ListTile(
                                    title: Text(privilege.privilegeName, style: textTheme.bodyMedium),
                                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: () {
                                      Navigator.of(context).pop(privilege);
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