import 'package:json_annotation/json_annotation.dart';

part 'Login_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginEntity {
  LoginEntity({this.userId,this.authFlag, this.gcBalance, this.nickname, this.token, this.walletAddress, this.realName, this.headPic});

  num? userId;
  num? authFlag;
  num? gcBalance;
  String? nickname;
  String? token;
  String? walletAddress;
  String? realName;
  String? headPic;
  factory LoginEntity.fromJson(Map<String, dynamic> json) =>
      _$LoginEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LoginEntityToJson(this);
}
