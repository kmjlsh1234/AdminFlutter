import 'package:acnoo_flutter_admin_panel/app/constants/menus/menu/menu_visibility.dart';
import 'package:json_annotation/json_annotation.dart';
part 'menu.g.dart';

@JsonSerializable(includeIfNull: true)
class Menu {
  final int id;
  final int? parentId;
  final String menuName;
  final int sortOrder;
  final String menuPath;
  final String image;
  final MenuVisibility visibility;
  final DateTime createdAt;
  final DateTime updatedAt;

  Menu({
    required this.id,
    required this.parentId,
    required this.menuName,
    required this.sortOrder,
    required this.menuPath,
    required this.image,
    required this.visibility,
    required this.createdAt,
    required this.updatedAt
  });

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
