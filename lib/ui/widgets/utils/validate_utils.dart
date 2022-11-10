import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

class ValidateUtils {
  /// 检查邮箱格式

  bool isEmail(String input) {

    if (input == null || input.isEmpty) return false;
    // 邮箱正则
    String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    return RegExp(regexEmail).hasMatch(input);

  }


  bool isChinaPhoneNumber(String input) {

    if (input == null || input.isEmpty) return false;
    //手机正则验证

    String regexPhoneNumber =

    "^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$";

    return RegExp(regexPhoneNumber).hasMatch(input);

  }

}
