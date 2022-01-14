import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ui/dtos/trend.dart';
import 'package:ui/models/trend.dart';

const localhostIP = '10.0.2.2'; // Points to localhost when inside Android emulator
const minikubeIP = '192.168.49.2';
const host = 'http://$minikubeIP';

// TODO handle errors and return Result instead of throwing
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

Future<Map<String, Trend>> getMacroTrends() async {
  final response = await http.get(Uri.parse('$host/trends/macros?date=2022-01-01T07:42:44.811Z'));

  if (response.statusCode == 200) {
    Map<String, dynamic> map = jsonDecode(response.body);
    Map<String, Trend> ret = HashMap();
    for (var entry in map.entries) {
      ret[entry.key] = Trend.fromDto(TrendDto.fromJson(entry.value));
    }
    return ret;
  } else {
    throw Exception("Well, that wasn't fun...");
  }
}
