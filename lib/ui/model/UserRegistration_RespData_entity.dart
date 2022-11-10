import 'package:json_annotation/json_annotation.dart';

part 'UserRegistration_RespData_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class UserRegistrationRespDataEntity {


  String? captcha;
  String? deviceId;
  String? loginPassword;
  String? nickname;
  String? payPassword;


  UserRegistrationRespDataEntity(


      this.captcha,
      this.deviceId,
      this.loginPassword,
      this.nickname,
      this.payPassword,

 );

  factory UserRegistrationRespDataEntity.fromJson(Map<String, dynamic> json) =>
      _$UserRegistrationRespDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationRespDataEntityToJson(this);
}

