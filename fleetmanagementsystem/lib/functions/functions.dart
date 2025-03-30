import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fleetmanagementsystem/services/apiUrl.dart';

Future<List> fetchWorkerLocation() async {
    try {
      final Uri url = Uri.http(apiUrl, '/worker_location');

      final response = await http.get(
        url,
        // headers: {
        //   'Authorization': 'Bearer $accessToken',
        // },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }