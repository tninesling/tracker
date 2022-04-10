import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ui/client.dart';
import 'package:ui/screens/trends.dart';
import 'package:ui/state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await openDatabase(
      // TODO: More upscripts
      join(await getDatabasesPath(), 'heath.db'), onCreate: (db, version) {
    return db.execute("""CREATE TABLE IF NOT EXISTS ingredients(
                id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
                name VARCHAR(200) NOT NULL,
                calories REAL NOT NULL,
                carb_grams REAL NOT NULL,
                fat_grams REAL NOT NULL,
                protein_grams REAL NOT NULL
              );""");
  }, version: 1);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => DietState()),
    Provider<Storage>(create: (_) => LocalStorage(db: database)),
    /* 
      RemoteStorage(
        openapiClient:
            openapi.DefaultApi(openapi.ApiClient(basePath: 'http://192.168.49.2')));
      */
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Heath',
      themeMode: ThemeMode.light,
      // Color palettes: https://api.flutter.dev/flutter/material/Colors-class.html
      theme: const NeumorphicThemeData(
          baseColor: Color(0xFFEEEEEE),
          depth: 2,
          lightSource: LightSource.topLeft,
          intensity: 4,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          textTheme: TextTheme(
              headline1: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              headline2: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
              bodyText1: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ))),
      darkTheme: NeumorphicThemeData(
          baseColor: Colors.indigo.shade300,
          depth: 1,
          lightSource: LightSource.topLeft,
          defaultTextColor: Colors.white,
          intensity: 4,
          iconTheme: IconThemeData(
            color: Colors.indigo.shade100,
          ),
          textTheme: TextTheme(
              headline1: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              headline2: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
              bodyText1: TextStyle(
                color: Colors.indigo.shade100,
                fontSize: 16,
              ))),
      home: const TrendsScreen(),
    );
  }
}
