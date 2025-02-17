// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../constants/admin/admin_menu.dart';
import '../../../constants/user/user_menu.dart';
import '../../../core/theme/_app_colors.dart';

class AdminNavBar extends StatefulWidget {
  const AdminNavBar({super.key, required this.adminId, required this.adminMenu});
  final int adminId;
  final AdminMenu adminMenu;

  @override
  State<AdminNavBar> createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {

  void selectMenu(AdminMenu menu){
    switch(menu){
      case AdminMenu.profile:
        GoRouter.of(context).go('/admins/profile/${widget.adminId}');
        break;
      case AdminMenu.log:
        //GoRouter.of(context).go('/users/currency/${widget.adminId}');
        break;
    }
  }

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
        children: AdminMenu.values.map((menu) {
          bool isSelected = menu == widget.adminMenu;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding / 2),
            child: SizedBox(
              width: 150,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: isSelected ? Colors.white : Colors.transparent,
                  foregroundColor: isSelected ? AcnooAppColors.kPrimary600 : theme.colorScheme.onTertiary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  selectMenu(menu);
                },
                child: Text(
                  menu.value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AcnooAppColors.kPrimary600 : theme.colorScheme.onTertiary,
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
