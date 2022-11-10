// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserRegistration_RespData_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegistrationRespDataEntity _$UserRegistrationRespDataEntityFromJson(Map<String, dynamic> json) =>
    UserRegistrationRespDataEntity(

      json['captcha'] as String?,
      json['deviceId'] as String?,
      json['loginPassword'] as String?,
      json['nickname'] as String?,
      json['payPassword'] as String?,




    );

Map<String, dynamic> _$UserRegistrationRespDataEntityToJson(UserRegistrationRespDataEntity instance) =>
    <String, dynamic>{

      'captcha': instance.captcha,
      'deviceId': instance.deviceId,
      'loginPassword': instance.loginPassword,
      'nickname': instance.nickname,
      'payPassword': instance.payPassword,



    };