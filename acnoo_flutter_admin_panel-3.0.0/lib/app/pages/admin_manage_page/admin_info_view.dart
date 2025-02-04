// 🐦 Flutter imports:
// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_profile/user_profile_details_widget.dart';
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../generated/l10n.dart' as l;
import '../../widgets/shadow_container/_shadow_container.dart';
import 'admin_info_nav_item.dart';
import 'admin_info_top_bar.dart';
import 'admin_profile_widget.dart';

class AdminInfoView extends StatelessWidget {
  const AdminInfoView({super.key,required this.adminId});
  final int adminId;

  List<AdminInfoNavItem> get navItems {
    return <AdminInfoNavItem>[
      AdminInfoNavItem(title: 'profile', navigationPath: '/admins/info/${1}'),
      AdminInfoNavItem(title: 'log', navigationPath: '/admins/info/${1}'),
      AdminInfoNavItem(title: 'currency', navigationPath: '/admins/info/${1}'),
      AdminInfoNavItem(title: 'currency Record', navigationPath: '/admins/info/${1}'),
      AdminInfoNavItem(title: 'extra', navigationPath: '/admins/info/${1}'),
    ];
  }

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
        customHeader: AdminInfoTopBarWidget(),
        margin: EdgeInsetsDirectional.all(_innerSpacing),
        child: SingleChildScrollView(
          child: ShadowContainer(
            contentPadding: EdgeInsets.zero,
            showHeader: false,
            child: AdminProfileWidget(
                padding: _padding,
                theme: theme,
                textTheme: textTheme,
                adminId: adminId
            ),
          ),
        ),
      ),
    );
  }
}

const (String,) _userProfile =
    ('assets/images/static_images/avatars/person_images/person_image_01.jpeg',);
