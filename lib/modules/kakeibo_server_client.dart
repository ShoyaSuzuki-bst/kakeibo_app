import 'package:http/http.dart' as http;
import 'dart:convert';

class KakeiboServerClient {
  static String baseUri = 'http://192.168.0.21:3000';

  // static Future<http.Response> signIn(email, token) async{
  //   Map<String, String> body = {
  //     'id_token': token,
  //     'email': email
  //   };
  //   final res = await http.post(Uri.parse("$baseUri/login"), body: body);
  //   print(res.statusCode);
  //   print(res.body);
  //   return res;
  // }

  static Future<Map<String, dynamic>> signIn(email, token) async {
    Map<String, String> body = {
      'id_token': token,
      'email': email
    };
    final headers = {'authorization': "Bearer $token"};
    print(headers);
    final res = await http.post(Uri.parse("$baseUri/login"), headers: headers, body: body);
    var decode_res = await json.decode(res.body);
    decode_res['status'] = res.statusCode;
    return decode_res;
  }

  static Future<http.Response> signOut(token) async{
    final headers = {'authorization': "Bearer $token"};
    final res = await http.delete(Uri.parse("$baseUri/logout"), headers: headers);
    return res;
  }
}
