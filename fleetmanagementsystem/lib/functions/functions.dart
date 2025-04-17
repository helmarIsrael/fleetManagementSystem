import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fleetmanagementsystem/services/apiUrl.dart';
import 'dart:math';
import 'package:flutter/material.dart';


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
    return [];
  }
}

Future<List> fetchClientLocation() async {
  try {
    final Uri url = Uri.http(apiUrl, '/client_location');

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
    return [];
  }
}

Future<List<dynamic>> fetchClientAndWorkerDistance(
  Map<String, dynamic> data,
) async {
  try {
    final Uri url = Uri.http(apiUrl, '/client_worker_distance');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      print("The response data is: ${responseData['data']}");
      return responseData['data'];
    } else {
      throw Exception('Failed to load: ${response.statusCode}');
    }
  } catch (e) {
    print(e);
    return [{}];
  }
}

Color getRandomColor() {
  final random = Random();
  return Color.fromARGB(
    255,                         // Full opacity
    random.nextInt(256),         // Red: 0–255
    random.nextInt(256),         // Green: 0–255
    random.nextInt(256),         // Blue: 0–255
  );
}

