

import '../widgets/mixins/helper_mixin.dart';

class TokenModel with HelperMixin {
  String token;
  // int expiresIn;
  // String tokenType;
  // String scope;
  // String refreshToken;
  // int timestamp;
  // int type;

  TokenModel(
      {required this.token,
      // required this.expiresIn,
      // required this.tokenType,
      // required this.scope,
      // required this.refreshToken,
      //   required this.type,
      // required this.timestamp
  }
      );

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      token: json['token'],
        // expiresIn: int.parse(json['expires_in']),
        // tokenType: json['token_type'],
        // type: json['type'],
        // scope: json['scope'],
        // refreshToken: json['refresh_token'],
        // timestamp: json['timestamp'] != null
        //     ? int.parse(json['timestamp'])
        //     : HelperMixin.getTimestamp()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      // 'expires_in': expiresIn.toString(),
      // 'token_type': tokenType,
      // 'type': type,
      // 'scope': scope,
      // 'refresh_token': refreshToken,
      // 'timestamp': timestamp.toString()
    };
  }

  TokenModel copyWith(
      {String? token,
      int? expiresIn,
      String? tokenType,
        int? type,
      String? scope,
      String? refreshToken,
      int? timestamp}) {
    return TokenModel(
      token: token ?? this.token,
      // expiresIn: expiresIn ?? this.expiresIn,
      // tokenType: tokenType ?? this.tokenType,
      // type: type ?? this.type,
      // scope: scope ?? this.scope,
      // refreshToken: refreshToken ?? this.refreshToken,
      // timestamp: timestamp ?? this.timestamp,
    );
  }

  void printAttributes() {
    print("token: ${this.token}\n");
    // print("expiresIn: ${this.expiresIn}\n");
    // print("tokenType: ${this.tokenType}\n");
    // print("scope: ${this.scope}\n");
    // print("refreshToken: ${this.refreshToken}\n");
  }
}
