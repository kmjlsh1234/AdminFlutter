import 'package:acnoo_flutter_admin_panel/app/constants/search_type_enum.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../core/helpers/field_styles/_dropdown_styles.dart';

class GenericDropDown<T extends SearchTypeEnum> extends StatelessWidget{

  final String labelText;
  final T searchType;
  final List<T> searchList;
  final ValueChanged<T> callBack;

  const GenericDropDown({super.key, required this.labelText, required this.searchType, required this.searchList, required this.callBack});

  @override
  Widget build(BuildContext context){
    final textTheme = Theme.of(context).textTheme;
    final dropdownStyle = AcnooDropdownStyle(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 100),
      child: DropdownButtonFormField2<T>(
        decoration: InputDecoration(labelText: labelText),
        style: dropdownStyle.textStyle,
        iconStyleData: dropdownStyle.iconStyle,
        buttonStyleData: dropdownStyle.buttonStyle,
        dropdownStyleData: dropdownStyle.dropdownStyle,
        menuItemStyleData: dropdownStyle.menuItemStyle,
        isExpanded: true,
        value: searchType,
        items: searchList.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              item.value,
              style: textTheme.bodySmall,
            ),
          );
        }).toList(),
        onChanged: (value) {
          callBack(value!);
        },
      ),
    );
  }
}
