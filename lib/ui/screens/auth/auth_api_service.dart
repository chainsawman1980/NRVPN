import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'api_service.dart';

class AuthApiService extends ApiService {
  static String signUpUrl = '/mobile/login/register';
  static String signInUrl = '/api/register';
  static String refreshTokenUrl = '/oauth2/token';

  Future<Response<dynamic>> signIn(
      String email, String trc20, String password) async {
    return post(signInUrl, {
      'playerName': email,
      'trc20Address': trc20,
      'password': password,
    });
  }

  Future<Response<dynamic>> signUp(Map<String, dynamic> data) async {
    return post(signUpUrl, {
      'name': data['username'],
      'mail': data['email'],
      'pass': {'pass1': data['password'], 'pass2': data['confirmPassword']}
    });
  }

  Future<Response<dynamic>> refreshToken(refreshToken) async {
    return post(refreshTokenUrl, {
      'refresh_token': refreshToken,
      'grant_type': 'refresh_token',
    });
  }

//   void signOut() async {
//     await _authenticationService.signOut();
//     _authenticationStateStream.value = UnAuthenticated();
//   }
}
