// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drop_out_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DropOutUser _$DropOutUserFromJson(Map<String, dynamic> json) => DropOutUser(
      (json['id'] as num).toInt(),
      (json['userId'] as num).toInt(),
      (json['mobile'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      json['email'] as String,
      DateTime.parse(json['dropAt'] as String),
    );

Map<String, dynamic> _$DropOutUserToJson(DropOutUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'mobile': instance.mobile,
      'email': instance.email,
      'dropAt': instance.dropAt.toIso8601String(),
    };
