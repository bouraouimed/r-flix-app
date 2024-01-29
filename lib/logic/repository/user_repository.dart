import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../model/session.dart';

abstract class UserRepository {
  Future<Session> login(String username, String password);
}

class UserTMDBRepository implements UserRepository {
  @override
  Future<Session> login(String username, String password) async {
    try {

      return Session.fromJson(
          jsonDecode('{"success": true}') as Map<String, dynamic>);

      final response = await http.post(
        Uri.parse(TMDB_LOGIN_API_URL),
        body: jsonEncode(<String, String> {
          "username": username,
          "password": password,
          "request_token": TMDB_LOGIN_REQUEST_TOKEN
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $TMDB_LOGIN_AUTHORIZATION_TOKEN',
        },
      );
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return Session.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to get user session');
      }
    } on Exception catch (_) {
      rethrow;
    }
  }
}

