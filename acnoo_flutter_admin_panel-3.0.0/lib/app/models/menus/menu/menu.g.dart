// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
      id: (json['id'] as num).toInt(),
      parentId: (json['parentId'] as num?)?.toInt(),
      menuName: json['menuName'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      menuPath: json['menuPath'] as String,
      image: json['image'] as String,
      visibility: $enumDecode(_$MenuVisibilityEnumMap, json['visibility']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'menuName': instance.menuName,
      'sortOrder': instance.sortOrder,
      'menuPath': instance.menuPath,
      'image': instance.image,
      'visibility': _$MenuVisibilityEnumMap[instance.visibility]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$MenuVisibilityEnumMap = {
  MenuVisibility.VISIBLE: 'VISIBLE',
  MenuVisibility.INVISIBLE: 'INVISIBLE',
};
