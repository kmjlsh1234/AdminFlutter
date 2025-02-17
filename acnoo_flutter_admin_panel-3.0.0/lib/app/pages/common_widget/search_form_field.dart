import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../core/theme/_app_colors.dart';
import '../../../../generated/l10n.dart' as l;

class SearchFormField extends StatefulWidget {
  const SearchFormField(
      {super.key, required this.textTheme, required this.lang, required this.onPressed});

  final TextTheme textTheme;
  final l.S lang;
  final void Function(String) onPressed;

  @override
  State<SearchFormField> createState() => _SearchFormFieldState();
}

class _SearchFormFieldState extends State<SearchFormField> {
  String searchValue = "";

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        // hintText: 'Search...',
        hintText: '${widget.lang.search}...',
        hintStyle: widget.textTheme.bodySmall,
        suffixIcon: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: AcnooAppColors.kPrimary700,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: ElevatedButton(
              onPressed: () =>
              {
                widget.onPressed(searchValue)
              },
              child: const Icon(IconlyLight.search,
                  color: AcnooAppColors.kWhiteColor),
            )),
      ),
      onChanged: (value) {
        searchValue = value;
      },
    );
  }
}