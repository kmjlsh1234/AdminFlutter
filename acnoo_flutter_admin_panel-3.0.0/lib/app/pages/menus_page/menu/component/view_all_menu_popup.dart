// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/theme/_app_colors.dart';
import '../../../../models/menus/menu/menu.dart';
import '../../../../providers/menu/menu_provider.dart';

class ViewAllMenuDialog extends StatelessWidget {
  const ViewAllMenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final menuProvider = Provider.of<MenuProvider>(context, listen: false);

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
                Text(lang.menuView),
                IconButton(
                  onPressed: () => GoRouter.of(context).pop(),
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

          ///---------------- body section (스크롤 가능 영역)
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lang.menu),
                      const SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.4,
                        ),
                        child: _dataMenuTable(menuProvider.menus, lang, theme, textTheme),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Theme _dataMenuTable(List<Menu> menuList, l.S lang, ThemeData theme, TextTheme textTheme) {
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
        ],
        rows: menuList.map((data) {
            return DataRow(
              color: WidgetStateColor.transparent,
              cells: [
                DataCell(Text(data.parentId == null ? data.menuName : lang.empty)),
                DataCell(Text(data.parentId == null ? lang.empty : data.menuName)),
                DataCell(Text(data.menuPath)),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}