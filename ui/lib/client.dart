import 'package:openapi/api.dart' as openapi;
import 'package:ui/models/meal.dart';
import 'package:ui/models/trend.dart';

abstract class ApiClient {
  Future<Iterable<Ingredient>> getIngredients();
  Future<Iterable<Trend>> getMacroTrends(DateTime since);
}

class OpenapiClientAdapter implements ApiClient {
  final openapi.DefaultApi openapiClient;

  OpenapiClientAdapter({required this.openapiClient});

  @override
  Future<Iterable<Ingredient>> getIngredients() async {
    var ingredients = await openapiClient.getAllIngredients();

    return ingredients.map(Ingredient.fromOpenapi);
  }

  @override
  Future<Iterable<Trend>> getMacroTrends(DateTime since) async {
    var trends = await openapiClient.getMacroTrends(since);

    return trends.map(Trend.fromOpenapi);
  }
}

ApiClient apiClient = OpenapiClientAdapter(
    openapiClient:
        openapi.DefaultApi(openapi.ApiClient(basePath: 'http://192.168.49.2')));
/*
const localhostIP =
    '10.0.2.2'; // Points to localhost when inside Android emulator
const minikubeIP = '192.168.49.2';
const host = 'http://$minikubeIP';

// TODO handle errors and return Result instead of throwing
Future<Iterable<Trend>> getWeightTrends() async {
  final response = await http.get(Uri.parse('$host/trends/calories'));

  if (response.statusCode == 200) {
    return [Trend.fromDto(TrendDto.fromJson(jsonDecode(response.body)))];
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

Future<Iterable<Trend>> getMacroTrends() async {
  final response = await http
      .get(Uri.parse('$host/trends/macros?date=2022-01-01T07:42:44.811Z'));

  if (response.statusCode == 200) {
    List<dynamic> list = jsonDecode(response.body);
    return list.map((t) => Trend.fromDto(TrendDto.fromJson(t)));
  } else {
    throw Exception("Well, that wasn't fun...");
  }
}
*/