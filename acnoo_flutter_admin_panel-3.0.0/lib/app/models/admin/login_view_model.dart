import 'package:json_annotation/json_annotation.dart';
part 'login_view_model.g.dart';

@JsonSerializable()
class LoginViewModel{
  final String email;
  final String password;

  LoginViewModel({
    required this.email,
    required this.password
  });

  factory LoginViewModel.fromJson(Map<String, dynamic> json) => _$LoginViewModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginViewModelToJson(this);
}