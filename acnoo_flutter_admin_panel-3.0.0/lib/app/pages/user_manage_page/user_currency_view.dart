// 🐦 Flutter imports:
// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/user_currency_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/user_info_nav_item.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/user_profile_widget.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/user_manage_page/user_top_bar.dart';
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/user_profile_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
import '../../widgets/shadow_container/_shadow_container.dart';

class UserCurrencyView extends StatelessWidget{
  const UserCurrencyView({super.key, required this.userId});
  final int userId;

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final textTheme = theme.textTheme;
    final _padding = responsiveValue<double>(
      context,
      xs: 16 / 2,
      sm: 16 / 2,
      md: 16 / 2,
      lg: 24 / 2,
    );
    final _innerSpacing = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    return Scaffold(
      body: ShadowContainer(
        customHeader: UserTopBar(userId: userId),
        margin: EdgeInsetsDirectional.all(_innerSpacing),
        child: SingleChildScrollView(
          child: ShadowContainer(
            contentPadding: EdgeInsets.zero,
            showHeader: false,
            child: UserCurrencyWidget(
              padding: 16,
              theme: Theme.of(context),
              textTheme: Theme.of(context).textTheme,
              userId: userId,
            ),
          ),
        ),
      ),
    );
  }
}
