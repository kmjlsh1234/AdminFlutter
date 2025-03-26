// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../constants/user/user_menu.dart';
import '../../widgets/widgets.dart';
import 'component/nav_bar/user_nav_bar.dart';
import 'component/widget/user_profile_widget.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key, required this.userId});
  final int userId;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
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
                        child: UserNavBar(userMenu: UserMenu.PROFILE, userId: userId),
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
                    UserProfileWidget(padding: padding, theme: theme, textTheme: textTheme, userId: userId)
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
