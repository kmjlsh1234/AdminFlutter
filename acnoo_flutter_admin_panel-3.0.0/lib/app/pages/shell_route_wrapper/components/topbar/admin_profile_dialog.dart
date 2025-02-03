import 'dart:ui';

import 'package:acnoo_flutter_admin_panel/app/core/service/admin/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../models/admin/admin.dart';
import '../../../../widgets/dialog_header/_dialog_header.dart';

class AdminProfileDialog extends StatelessWidget {
  const AdminProfileDialog({
    super.key,
    required this.admin,
  });
  final Admin admin;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final _fontSize = responsiveValue<double>(
      context,
      xs: 12,
      sm: 12,
      md: 14,
      lg: 16,
    );

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5,
        sigmaY: 5,
      ),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 610),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                //const DialogHeader(headerTitle: 'View Details'),
                DialogHeader(headerTitle: lang.profile),
                // Task Details
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final _size = constraints.biggest;

                      return Column(
                        children: [
                          ...{
                            /*"Project"*/ l.S.current.email:
                            admin.email,
                            /*"Title"*/ l.S.current.position ?? 'N/A':
                            admin.roleId.toString(),
                            /*"Start Date"*/ l.S.current.name:
                            admin.name,
                            /*"End Date"*/ l.S.current.loginAt ?? "":
                            admin.loginAt,
                            /*"Assigned To"*/ l.S.current.createdAt:
                            admin.createdAt,
                            /*"Status"*/ l.S.current.updatedAt:
                            admin.updatedAt,
                          }.entries.map(
                                (info) => Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: _size.width *
                                        responsiveValue<double>(
                                          context,
                                          xs: 0.375,
                                          sm: 0.375,
                                          md: 0.25,
                                          lg: 0.225,
                                        ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          info.key,
                                          style: _theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            fontSize: _fontSize,
                                            color: _theme
                                                .checkboxTheme.side?.color,
                                          ),
                                        ),
                                        Text(
                                          ':',
                                          style: _theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            fontSize: _fontSize,
                                            color: _theme
                                                .checkboxTheme.side?.color,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      info.value ?? 'Unknown',
                                      style: _theme.textTheme.bodyLarge
                                          ?.copyWith(
                                        fontSize: _fontSize,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}