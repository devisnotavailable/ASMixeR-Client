import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'network_exception.dart';

class NetworkHandler {
  Future<dynamic> get(String url,
      [Map<String, String> headers = const {}]) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
