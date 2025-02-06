import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile{
  //user
  final int userId;
  final String status;
  final String mobile;
  final String email;
  final String userType;
  @JsonKey(includeIfNull: true)
  final String? loginAt;
  @JsonKey(includeIfNull: true)
  final String? logoutAt;
  final String createdAt;
  final String updatedAt;
  //profile
  final String nickname;
  final String image;
  @JsonKey(includeIfNull: true)
  final int? basicImageIdx;

  UserProfile(
      this.userId,
      this.status,
      this.mobile,
      this.email,
      this.userType,
      this.loginAt,
      this.logoutAt,
      this.createdAt,
      this.updatedAt,
      this.nickname,
      this.image,
      this.basicImageIdx
      );

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}