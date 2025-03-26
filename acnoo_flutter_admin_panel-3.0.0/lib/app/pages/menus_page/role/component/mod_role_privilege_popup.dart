// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/core/error/error_handler.dart';
import 'package:acnoo_flutter_admin_panel/app/core/service/menus/privilege_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/theme/_app_colors.dart';
import '../../../../core/utils/future_builder_factory.dart';
import '../../../../core/utils/size_config.dart';
import '../../../../models/menus/privilege/privilege.dart';
import '../../../../models/menus/privilege/privilege_menu.dart';
import '../../../../models/menus/role_privilege/role_privilege.dart';

class ModRolePrivilegeDialog extends StatefulWidget {
  const ModRolePrivilegeDialog({super.key, required this.roleId, required this.rolePrivilegeList});
  final int roleId;
  final List<RolePrivilege> rolePrivilegeList;

  @override
  State<ModRolePrivilegeDialog> createState() => _ModRolePrivilegeDialogState();
}

class _ModRolePrivilegeDialogState extends State<ModRolePrivilegeDialog> {

  final ScrollController scrollController = ScrollController();
  final PrivilegeService privilegeService = PrivilegeService();

  //Future Model
  late Future<List<PrivilegeMenuModel>> privilegeMenuList;
  late Future<List<PrivilegeNotMenuModel>> privilegeNotMenuList;

  //권한 - 메뉴 리스트 조회(정렬됨)
  Future<List<PrivilegeMenuModel>> getPrivilegeSortMenuList() async {
    try{
      //TODO: 서버에서 권한 리스트 가져오기
      List<PrivilegeMenu> list = await privilegeService.getPrivilegeSortMenuList();

      //TODO: 클라에서 사용할 모델로 변환
      List<PrivilegeMenuModel> modelList = list.map((privilegeMenu) => PrivilegeMenuModel(privilegeMenu: privilegeMenu)).toList();


      if (widget.rolePrivilegeList.isNotEmpty) {
        for (var model in modelList) {
          RolePrivilege? rolePrivilege = widget.rolePrivilegeList.firstWhereOrNull(
                (rolePrivilege) => rolePrivilege.privilegeId == model.privilegeMenu.privilegeId);

          if (rolePrivilege != null) {
            model.readAuth = rolePrivilege.readAuth;
            model.writeAuth = rolePrivilege.writeAuth;
          } else{
            model.readAuth = 0;
            model.writeAuth = 0;
          }
        }
      }
      return modelList;
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  //권한 - 메뉴 외 리스트 조회 (버튼이나 특수 권한등 메뉴에 묶여있지 않은 권한만 따로 조회)
  Future<List<PrivilegeNotMenuModel>> getPrivilegeNotMenuList() async {
    try{
      List<Privilege> list = await privilegeService.getPrivilegeNotMenuList();
      List<PrivilegeNotMenuModel> modelList = list.map((privilege) => PrivilegeNotMenuModel(privilege: privilege)).toList();
      if (widget.rolePrivilegeList.isNotEmpty) {
        for (var model in modelList) {
          RolePrivilege? rolePrivilege = widget.rolePrivilegeList.firstWhereOrNull(
                (rolePrivilege) => rolePrivilege.privilegeId == model.privilege.id);

          if (rolePrivilege != null) {
            model.readAuth = rolePrivilege.readAuth;
            model.writeAuth = rolePrivilege.writeAuth;
          } else{
            model.readAuth = 0;
            model.writeAuth = 0;
          }
        }
      }
      return modelList;
    } catch (e) {
      ErrorHandler.handleError(e, context);
      rethrow;
    }
  }

  void saveRolePrivilege() async{
    List<RolePrivilege> list = [];
    List<PrivilegeMenuModel> privilegeMenuList = await this.privilegeMenuList;
    List<PrivilegeNotMenuModel> privilegeNotMenuList = await this.privilegeNotMenuList;

    for(PrivilegeMenuModel model in privilegeMenuList) {
      list.add(
        RolePrivilege(
            privilegeId: model.privilegeMenu.privilegeId,
            privilegeName: model.privilegeMenu.privilegeName,
            privilegeCode: model.privilegeMenu.privilegeCode,
            readAuth: model.readAuth,
            writeAuth: model.writeAuth
        )
      );
    }

    for(PrivilegeNotMenuModel model in privilegeNotMenuList) {
      list.add(
          RolePrivilege(
              privilegeId: model.privilege.id,
              privilegeName: model.privilege.privilegeName,
              privilegeCode: model.privilege.privilegeCode,
              readAuth: model.readAuth,
              writeAuth: model.writeAuth
          )
      );
    }

    GoRouter.of(context).pop(list);
  }

  @override
  void initState(){
    super.initState();
    privilegeMenuList = getPrivilegeSortMenuList();
    privilegeNotMenuList = getPrivilegeNotMenuList();
  }

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///---------------- header section
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(lang.modRolePrivilege),
                IconButton(
                  onPressed: () => GoRouter.of(context).pop(null),
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

          ///---------------- body section with scroll
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(lang.privilegeMenu),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              setState(() {
                                privilegeMenuList = getPrivilegeSortMenuList();
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: FutureBuilderFactory.createFutureBuilder(
                            future: privilegeMenuList,
                            onSuccess: (context, privilegeMenuList){
                              return dataMenuTable(privilegeMenuList, theme, textTheme, lang);
                            }
                        ),
                      ),

                      const SizedBox(height: 50),

                      Row(
                        children: [
                          Text(lang.notPrivilegeMenu),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              setState(() {
                                privilegeNotMenuList = getPrivilegeNotMenuList();
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: FutureBuilderFactory.createFutureBuilder(
                            future: privilegeNotMenuList,
                            onSuccess: (context, privilegeNotMenuList){
                              return dataNotMenuTable(privilegeNotMenuList, theme, textTheme, lang);
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          ///---------------- footer section (Submit Button)
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: _sizeInfo.innerSpacing),
                    backgroundColor: theme.colorScheme.primaryContainer,
                    textStyle: textTheme.bodySmall?.copyWith(color: AcnooAppColors.kError),
                    side: const BorderSide(color: AcnooAppColors.kError),
                  ),
                  onPressed: () => GoRouter.of(context).pop(null),
                  label: Text(
                    lang.cancel,
                    style: textTheme.bodySmall?.copyWith(color: AcnooAppColors.kError),
                  ),
                ),
                SizedBox(width: _sizeInfo.innerSpacing),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: _sizeInfo.innerSpacing),
                  ),
                  onPressed: () => saveRolePrivilege(),
                  label: Text(lang.save),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Theme dataMenuTable(List<PrivilegeMenuModel> privilegeMenuList, ThemeData theme, TextTheme textTheme, l.S lang) {
    return Theme(
      data: ThemeData(
        dividerColor: theme.colorScheme.outline,
        checkboxTheme: const CheckboxThemeData(
          side: BorderSide(
            color: AcnooAppColors.kNeutral500,
            width: 1.0,
          ),
        ),
      ),
      child: DataTable(
        border: TableBorder.all(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        dividerThickness: 0.0,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        horizontalMargin: 16.0,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        columns: [
          DataColumn(label: Text(lang.depth1)),
          DataColumn(label: Text(lang.depth2)),
          DataColumn(label: Text(lang.path)),
          DataColumn(label: Text(lang.readAuth)),
          DataColumn(label: Text(lang.writeAuth)),
        ],
        rows: privilegeMenuList.map(
              (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.privilegeMenu.parentId == null ? data.privilegeMenu.privilegeName : '')),
                DataCell(Text(data.privilegeMenu.parentId == null ? '' : data.privilegeMenu.privilegeName)),
                DataCell(Text(data.privilegeMenu.menuPath)),
                DataCell(
                  Checkbox(
                      value: data.readAuth != 0,
                      onChanged: (bool? value) {
                        setState(() {
                          data.readAuth = value! ? 1 : 0;
                        });
                      }),
                ),
                DataCell(
                  Checkbox(
                      value: data.writeAuth != 0,
                      onChanged: (bool? value) {
                        setState(() {
                          data.writeAuth = value! ? 1 : 0;
                        });
                      }),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  Theme dataNotMenuTable(List<PrivilegeNotMenuModel> privilegeNotMenuList, ThemeData theme, TextTheme textTheme, l.S lang) {
    return Theme(
      data: ThemeData(
        dividerColor: theme.colorScheme.outline,
        checkboxTheme: const CheckboxThemeData(
          side: BorderSide(
            color: AcnooAppColors.kNeutral500,
            width: 1.0,
          ),
        )
      ),
      child: DataTable(
        border: TableBorder.all(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        dividerThickness: 0.0,
        headingTextStyle: textTheme.titleMedium,
        dataTextStyle: textTheme.bodySmall,
        horizontalMargin: 16.0,
        headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
        columns: [
          DataColumn(label: Text(lang.privilegeName)),
          DataColumn(label: Text(lang.privilegeCode)),
          DataColumn(label: Text(lang.readAuth)),
          DataColumn(label: Text(lang.writeAuth)),
        ],
        rows: privilegeNotMenuList.map(
              (data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.privilege.privilegeName)),
                DataCell(Text(data.privilege.privilegeCode)),
                DataCell(
                  Checkbox(
                    value: data.readAuth != 0,
                    onChanged: (bool? value) {
                      setState(() {
                        data.readAuth = value! ? 1 : 0;
                      });
                    }),
                ),
                DataCell(
                  Checkbox(
                      value: data.writeAuth != 0,
                      onChanged: (bool? value) {
                        setState(() {
                          data.writeAuth = value! ? 1 : 0;
                        });
                      }),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}

class PrivilegeMenuModel{
  final PrivilegeMenu privilegeMenu;
  int readAuth = 0;
  int writeAuth = 0;

  PrivilegeMenuModel({required this.privilegeMenu});
}

class PrivilegeNotMenuModel{
  final Privilege privilege;
  int readAuth = 0;
  int writeAuth = 0;

  PrivilegeNotMenuModel({required this.privilege});
}

