// 🐦 Flutter imports:
import 'package:acnoo_flutter_admin_panel/app/pages/admin_manage_page/widget/admin_profile_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/widget/nav_bar/user_nav_tab_bar.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/widget/user_currency_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/widget/user_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
import '../../core/constants/user/user_menu.dart';
import '../../widgets/widgets.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key, required this.userId});
  final int userId;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  UserMenu currentMenu = UserMenu.PROFILE;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final double padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 16,
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.all(padding),
            child: ShadowContainer(
              contentPadding: EdgeInsets.zero,
              customHeader: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: UserNavTabBar(selectMenu: currentMenu, userId: widget.userId),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.3,
                    height: 0,
                    color: theme.colorScheme.outline,
                  )
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProfileWidget(padding: padding, theme: theme, textTheme: textTheme, userId: widget.userId)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
