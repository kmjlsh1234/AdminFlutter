// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../constants/user/user_menu.dart';
import '../../../../core/theme/_app_colors.dart';

class UserNavBar extends StatefulWidget {
  const UserNavBar({super.key, required this.userId, required this.userMenu});
  final int userId;
  final UserMenu userMenu;

  @override
  State<UserNavBar> createState() => _UserNavBarState();
}

class _UserNavBarState extends State<UserNavBar> {
  List<String> get menues => UserMenu.values.map((e) => e.value).toList();

  void selectMenu(String value){
    UserMenu menu = UserMenu.values.firstWhere(
          (menu) => menu.value == value,
      orElse: () => UserMenu.profile,
    );

    switch(menu){
      case UserMenu.profile:
        GoRouter.of(context).go('/users/profile/${widget.userId}');
        break;
      case UserMenu.currency:
        GoRouter.of(context).go('/users/currency/${widget.userId}');
        break;
      case UserMenu.currencyRecord:
        GoRouter.of(context).go('/users/currency/record/${widget.userId}');
        break;
      case UserMenu.log:
        GoRouter.of(context).go('/users/log/${widget.userId}');
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
        children: menues.map((menu) {
          bool isSelected = menu == widget.userMenu.value;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding / 2),
            child: SizedBox(
              width: 150, // 버튼 크기 일정하게 유지
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: isSelected
                      ? Colors.white
                      : Colors.transparent,
                  foregroundColor: isSelected
                      ? AcnooAppColors.kPrimary600
                      : theme.colorScheme.onTertiary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  selectMenu(menu);
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
