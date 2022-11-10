// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Login_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginEntity _$LoginEntityFromJson(Map<String, dynamic> json) => LoginEntity(
      gcBalance: json['gcBalance'] as num?,
      userId: json['userId'] as num?,
      authFlag: json['authFlag'] as num?,
      nickname: json['nickname'] as String?,
      token: json['token'] as String?,
      walletAddress: json['walletAddress'] as String?,
      realName: json['realName'] as String?,
      headPic: json['headPic'] as String?,
    );

Map<String, dynamic> _$LoginEntityToJson(LoginEntity instance) =>
    <String, dynamic>{
      'gcBalance': instance.gcBalance,
      'authFlag': instance.authFlag,
          'userId': instance.userId,
      'nickname': instance.nickname,
      'token': instance.token,
      'walletAddress': instance.walletAddress,
      'realName': instance.realName,
      'headPic': instance.headPic,
    };
