import 'package:acnoo_flutter_admin_panel/app/constants/menus/menu/menu_visibility.dart';
import 'package:json_annotation/json_annotation.dart';
part 'menu_mod_param.g.dart';

@JsonSerializable(includeIfNull: true)
class MenuModParam {
  final int? parentId;
  final String? menuName;
  final int? sortOrder;
  final String? menuPath;
  final String? image;
  final MenuVisibility? visibility;

  MenuModParam({
    required this.parentId,
    required this.menuName,
    required this.sortOrder,
    required this.menuPath,
    required this.image,
    required this.visibility
  });

  factory MenuModParam.fromJson(Map<String, dynamic> json) => _$MenuModParamFromJson(json);
  Map<String, dynamic> toJson() => _$MenuModParamToJson(this);
}
