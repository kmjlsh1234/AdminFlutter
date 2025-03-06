// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_add_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuAddParam _$MenuAddParamFromJson(Map<String, dynamic> json) => MenuAddParam(
      parentId: (json['parentId'] as num?)?.toInt(),
      menuName: json['menuName'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      menuPath: json['menuPath'] as String,
      image: json['image'] as String,
      visibility: $enumDecode(_$MenuVisibilityEnumMap, json['visibility']),
    );

Map<String, dynamic> _$MenuAddParamToJson(MenuAddParam instance) =>
    <String, dynamic>{
      'parentId': instance.parentId,
      'menuName': instance.menuName,
      'sortOrder': instance.sortOrder,
      'menuPath': instance.menuPath,
      'image': instance.image,
      'visibility': _$MenuVisibilityEnumMap[instance.visibility]!,
    };

const _$MenuVisibilityEnumMap = {
  MenuVisibility.VISIBLE: 'VISIBLE',
  MenuVisibility.INVISIBLE: 'INVISIBLE',
};
