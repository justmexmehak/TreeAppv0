
import 'package:http/http.dart' as http;
// import 'package:test/main.dart';

main() async {
  print("Hello");
  try {
    // Test Connection
    // var response = await http.get(Uri.parse("https://c3ec-39-39-65-18.ngrok-free.app/test_flutter/"));
    // LOG IN
    // var response = await http.post(Uri.parse("https://a314-39-39-65-18.ngrok-free.app/dj-rest-auth/login/"), body: {
    //   'username': 'test',
    //   'password': 'restauth'
    // });
    // LOGGED IN
    // var response = await http.get(Uri.parse("https://a314-39-39-65-18.ngrok-free.app/dj-rest-auth/logged-in/"), headers: {
    //   'Authorization': 'TOKEN 52d467027fca139a9a40e335d464cebdfa23158d',
    // });
    // USER
    // var response = await http.get(Uri.parse("https://31b6-39-39-65-18.ngrok-free.app/dj-rest-auth/user/"), headers: {
    //   'Authorization': 'TOKEN e21508f93c5486dd2a2a4bf61e2efeccd677f9e1',
    // });
    // LOG OUT 
    // var response = await http.post(Uri.parse("https://a314-39-39-65-18.ngrok-free.app/dj-rest-auth/logout/"), headers: {
    //   'Authorization': 'TOKEN 4118ae5923b133cc3567cd234533f213e1a3c8ad',
    // });
    // REGISTRATION
    // var response = await http.post(Uri.parse("https://c3ec-39-39-65-18.ngrok-free.app/dj-rest-auth/registration/"), body: {
    //   'username': 'newuser2',
    //   'email': 'newuser@gmail.com',
    //   'password1': 'heymustard',
    //   'password2': 'heymustard'
    // });

    // const baseUrl = "http://127.0.0.1:8000/dj-rest-auth/";
    const baseUrl = "https://mehaknauman.pythonanywhere.com/dj-rest-auth/";

    // const baseUrl = "https://c647-39-39-65-18.ngrok-free.app/dj-rest-auth/";

    String? result = 'e21508f93c5486dd2a2a4bf61e2efeccd677f9e1';
    print(result);


    var response = await http.get(Uri.parse("${baseUrl}user/"), headers: {
        'Authorization': 'TOKEN $result',
      });

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    print('Headers: ${response.headers}');

  } catch(e) {
    print(e);
  }
  
}