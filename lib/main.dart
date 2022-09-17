import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoapp/database/dbHelper.dart';
import 'package:todoapp/screens/homeScreen.dart';
import 'package:todoapp/services/themeServices.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todoapp/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await DBHelper.query();
  await GetStorage.init;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: HomeScreen(),
    );
  }
}
