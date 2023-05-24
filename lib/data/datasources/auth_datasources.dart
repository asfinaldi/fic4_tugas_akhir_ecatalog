import 'package:http/http.dart' as http;
import 'package:platzi_fake_store_app/data/models/request/register_model.dart';
import 'package:platzi_fake_store_app/data/models/response/register_response_model.dart';

class AuthDatasource {
  Future<RegisterResponseModel> register(RegisterModel registerModel) async {
    final response = await http.post(
      Uri.parse('https://api.escuelajs.co/api/v1/users/'),
      //headers: {'Content-Type': 'application/json'},
      body: registerModel.toMap(),
    );

    final result = RegisterResponseModel.fromJson(response.body);
    return result;
  }
}
