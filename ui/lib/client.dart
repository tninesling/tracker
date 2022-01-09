import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ui/dtos/trend.dart';
import 'package:ui/models/trend.dart';

const localhostIP = '10.0.2.2'; // Points to localhost when inside Android emulator
const minikubeIP = '192.168.49.2';
const host = 'http://$minikubeIP';

Future<Trend> getCalorieTrend() async {
  final response = await http.get(Uri.parse('$host/trends/calories'));

  if (response.statusCode == 200) {
    return Trend.fromDto(TrendDto.fromJson(jsonDecode(response.body)));
  } else {
    throw Exception("Well, that wasn't fun...");
  }
}

Future<Trend> getCarbsTrend() async {
  final response = await http.get(Uri.parse('$host/trends/carbs'));

  if (response.statusCode == 200) {
    return Trend.fromDto(TrendDto.fromJson(jsonDecode(response.body)));
  } else {
    throw Exception("Well, that wasn't fun...");
  }
}

Future<Trend> getFatTrend() async {
  final response = await http.get(Uri.parse('$host/trends/fat'));

  if (response.statusCode == 200) {
    return Trend.fromDto(TrendDto.fromJson(jsonDecode(response.body)));
  } else {
    throw Exception("Well, that wasn't fun...");
  }
}

Future<Trend> getProteinTrend() async {
  final response = await http.get(Uri.parse('$host/trends/protein'));

  if (response.statusCode == 200) {
    return Trend.fromDto(TrendDto.fromJson(jsonDecode(response.body)));
  } else {
    throw Exception("Well, that wasn't fun...");
  }
}
