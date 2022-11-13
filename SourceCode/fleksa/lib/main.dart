import 'package:firebase_core/firebase_core.dart';
import 'package:fleksa/SharedPreferences/sharedpreferences.dart';
import 'package:fleksa/View/login_page.dart';
import 'package:fleksa/View/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await ShareP.init();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String? token;

  @override
  void initState()
  {
    super.initState();
    token = ShareP.getToken() ?? null ;
  }

  @override
  Widget build(BuildContext context) {
    if(token != null)
    {
      return Welcome();
    }
    else
    {
      return LogIn();
    }
  }
}
