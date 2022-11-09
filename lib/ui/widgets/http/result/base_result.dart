import 'package:json_annotation/json_annotation.dart';

/**
 * 大阳智投数据基类
 */

part 'base_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResult<T> {
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "data")
  T? data;

  BaseResult({this.code, this.msg, this.data});

  factory BaseResult.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseResultFromJson(json, fromJsonT);


  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$BaseResultToJson(this, toJsonT);

}





