import 'package:http/http.dart' as http;
import 'dart:convert';

class KakeiboServerClient {
  static String baseUri = 'http://192.168.0.21:3000';

  static Future<Map<String, dynamic>> signUp(token, name, email) async {
    final headers = {'authorization': "Bearer $token"};
    final Map<String, String> body = {
      'name': name,
      'email': email
    };
    final res = await http.post(
      Uri.parse("$baseUri/users"),
      headers: headers,
      body: body
    );
    if(res.statusCode == 200){
      var decodedRes = await json.decode(res.body);
      decodedRes['status'] = res.statusCode;
      return decodedRes;
    }
    return {
      'status': res.statusCode,
      'message': res.body
    };
  }

  static Future<Map<String, dynamic>> getUser(token) async {
    final headers = {'authorization': "Bearer $token"};
    final res = await http.get(
      Uri.parse("$baseUri/users"),
      headers: headers
    );
    if(res.statusCode == 200){
      var decodedRes = await json.decode(res.body);
      decodedRes['status'] = res.statusCode;
      return decodedRes;
    } else if(res.statusCode == 401) {
      return {
        'status': res.statusCode,
        'message': 'ユーザーが認証できませんでした。初めての場合は新規登録をお願いします。'
      };
    }
    return {
      'status': res.statusCode,
      'message': res.body
    };
  }

  static Future<http.Response> signOut(token) async{
    final headers = {'authorization': "Bearer $token"};
    final res = await http.delete(
      Uri.parse("$baseUri/logout"),
      headers: headers
    );
    return res;
  }

  static Future<Map<String, dynamic>> createPayment(token, price, isIncome) async {
    final headers = {
      "Content-Type": "application/json",
      'authorization': "Bearer $token"
    };
    final Map<String, dynamic> body = {
      'price': price,
      'is_income': isIncome
    };
    final encodedBody = json.encode(body);
    final res = await http.post(
      Uri.parse("$baseUri/payments"),
      headers: headers,
      body: encodedBody
    );
    var decodedRes = await json.decode(res.body);
    decodedRes['status'] = res.statusCode;
    return decodedRes;
  }

  static Future<Map<String, dynamic>> getPayments(token) async {
    Map<String, dynamic> result = {};
    final headers = {
      "Content-Type": "application/json",
      'authorization': "Bearer $token"
    };
    final res = await http.get(
      Uri.parse("$baseUri/payments"),
      headers: headers
    );
    result['data'] = await json.decode(res.body);
    result['status'] = res.statusCode;
    return result;
  }
}
