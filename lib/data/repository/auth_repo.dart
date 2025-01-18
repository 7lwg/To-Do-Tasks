import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_task/constants/variables.dart';
import 'package:todo_app_task/data/models/profile_data_model.dart';
import 'package:todo_app_task/data/repository/todos_repo.dart';

// ignore: prefer_typing_uninitialized_variables, non_constant_identifier_names
var PostData;
// ignore: prefer_typing_uninitialized_variables
var response;
String accessToken = '';
String refreshToken = '';
const String authBaseURL = 'https://todo.iraqsapp.com/auth/';
ProfileDataModel? profileData;
// ignore: prefer_const_declarations
final FlutterSecureStorage storage = const FlutterSecureStorage();

Future<void> saveTokens(
    {required String accessToken, required String refreshToken}) async {
  if (accessToken != '') {
    await storage.write(key: 'access_token', value: accessToken);
  }
  if (refreshToken != '') {
    await storage.write(key: 'refresh_token', value: refreshToken);
  }
}

Future<void> deleteTokens() async {
  await storage.write(key: 'access_token', value: '');
  await storage.write(key: 'refresh_token', value: '');
}

Future<void> getTokens(
    {required bool readAccessToken, required bool readRefreshToken}) async {
  if (readAccessToken == true) {
    accessToken = await storage.read(key: 'access_token') ?? "";
  }
  if (readRefreshToken == true) {
    refreshToken = await storage.read(key: 'refresh_token') ?? "";
  }
}

class AuthRepo {
  Future<dynamic> registerRepo() async {
    try {
      PostData = {
        "phone": userPhoneCountryCode + userPhoneNumber,
        "password": password,
        "displayName": userName,
        "experienceYears": experienceYears,
        "address": address,
        "level": experienceLevel
      };

      response = await http.post(
        Uri.parse('${authBaseURL}register'),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
        body: json.encode(PostData),
      );
      accessToken = jsonDecode(response.body)['access_token'].toString();
      refreshToken = jsonDecode(response.body)['refresh_token'].toString();
      saveTokens(accessToken: accessToken, refreshToken: refreshToken);

      return response;
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> loginRepo() async {
    try {
      PostData = {
        "phone": userPhoneCountryCode + userPhoneNumber,
        "password": password,
      };
      response = await http.post(
        Uri.parse('${authBaseURL}login'),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
        body: json.encode(PostData),
      );
      accessToken = jsonDecode(response.body)['access_token'].toString();
      refreshToken = jsonDecode(response.body)['refresh_token'].toString();
      saveTokens(accessToken: accessToken, refreshToken: refreshToken);
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> logoutRepo() async {
    try {
      await getTokens(readAccessToken: true, readRefreshToken: false);

      response = await http.post(
        Uri.parse('${authBaseURL}logout'),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
          'Authorization': 'Bearer $accessToken',
        },
      );
      deleteTokens();
      accessToken = '';
      refreshToken = '';
      toDosDataList.clear();
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> refreshTokenRepo() async {
    try {
      await getTokens(readAccessToken: false, readRefreshToken: true);
      response = await http.get(
        Uri.parse('${authBaseURL}refresh-token?token=$refreshToken'),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
      );
      accessToken = jsonDecode(response.body)['access_token'].toString();
      saveTokens(accessToken: accessToken, refreshToken: '');
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> profileDataRepo() async {
    try {
      await getTokens(readAccessToken: true, readRefreshToken: false);
      response = await http.get(
        Uri.parse('${authBaseURL}profile'),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        profileData = ProfileDataModel.fromJson(jsonDecode(response.body));
      }
      return response;
    } catch (error) {
      return null;
    }
  }
}
