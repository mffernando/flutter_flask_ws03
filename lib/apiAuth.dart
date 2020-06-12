import 'dart:convert';
import 'dart:io';
import 'user.dart';
import 'package:http/http.dart' show Client;

class ApiAuth {
  final String baseUrl = "http://10.0.0.4:5000";
  Client client = Client();

  Future<bool> loginUser(String email, String password) async {
    Map data = {
      'email': email,
      'password': password,
    };

    String basicAuth = 'Basic ' + base64Encode((utf8.encode('$email:$password')));
    print("Basic Auth " + basicAuth);

    //converter para json (string)
    var body = json.encode(data);

    final response = await client.get("$baseUrl/api/profile",
        headers: {'authorization': basicAuth}
        //headers: {"content-type": "application/json"},
        //body: body
    );
    print(response.statusCode);
    print(response.body);
    Map mapResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      final user = User.fromJson(mapResponse);
      return true;
    } else
      print("DEU RUIMMMMMMMMMMMMMMMMMMMMMM");
      print(mapResponse);
      return false;
  }
}