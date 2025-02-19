// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../constants/admin/admin_menu.dart';
import '../../../core/theme/_app_colors.dart';

class AdminNavBar extends StatefulWidget {
  const AdminNavBar({super.key, required this.onTabSelected, required this.adminMenu});

  final void Function(String) onTabSelected;
  final AdminMenu adminMenu;

  @override
  State<AdminNavBar> createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {
  List<String> get menues => AdminMenu.values.map((e) => e.value).toList();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: menues.map((menu) {
          bool isSelected = menu == widget.adminMenu.value;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding / 2),
            child: SizedBox(
              width: 150, // 버튼 크기 일정하게 유지
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: theme.colorScheme.onTertiary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  widget.onTabSelected(menu);
                },
                child: Text(
                  menu,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? AcnooAppColors.kPrimary600
                        : theme.colorScheme.onTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
