import 'package:http/http.dart' as http;
import 'package:myexpense/exceptions/http_exception.dart';
import 'dart:convert';
import 'dart:async';
import '../jsonmodels/registration.dart';
import 'config.dart';
import 'dart:io'; //HttpHeaders

Future<Registration> register(var data) async {
  var res = await http.post('$API_URL/registration', body: data);
  if (res.statusCode == 201) {
    return Registration.fromJson(jsonDecode(res.body));
  } else if (res.statusCode == 422) {
    final resData = json.decode(res.body);
    if (resData['errors']['email'] != "") {
      throw HttpExceptionModel(resData['errors']['email']);
    }
  } else {
    throw Exception('Error Registration Error');
  }
}
