import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:platzi_fake_store_app/data/localsources/auth_local_storage.dart';
import 'package:platzi_fake_store_app/data/models/request/login_model.dart';
import 'package:platzi_fake_store_app/data/models/response/login_response_model.dart';
import 'package:platzi_fake_store_app/data/models/response/profile_response_model.dart';
import 'package:platzi_fake_store_app/data/models/response/register_response_model.dart';

import '../models/request/register_model.dart';

enum LoginFailure { invalidCredentials, error }

class AuthDatasource {
  Future<RegisterResponseModel> register(RegisterModel registerModel) async {
    final response = await http.post(
      Uri.parse('https://api.escuelajs.co/api/v1/users/'),
      body: registerModel.toMap(),
    );

    final result = RegisterResponseModel.fromJson(response.body);
    return result;
  }

  Future<Either<String, LoginResponseModel>> login(
      LoginModel loginModel) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.escuelajs.co/api/v1/auth/login'),
        body: loginModel.toMap(),
      );

      if (response.statusCode == 201) {
        return Right(LoginResponseModel.fromJson(response.body));
      } else if (response.statusCode == 401) {
        return Left(LoginFailure.invalidCredentials.name);
      } else {
        return Left(LoginFailure.error.name);
      }
    } catch (e) {
      return Left(LoginFailure.error.name);
    }
  }

  Future<ProfileResponseModel> getProfile() async {
    final token = await AuthLocalStorage().getToken();
    var headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(
      Uri.parse('https://api.escuelajs.co/api/v1/auth/profile'),
      headers: headers,
    );

    final result = ProfileResponseModel.fromJson(response.body);
    return result;
  }
}
