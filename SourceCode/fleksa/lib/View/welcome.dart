import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleksa/SharedPreferences/sharedpreferences.dart';
import 'package:fleksa/View/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: HexColor("#fed701"),
              statusBarIconBrightness: Brightness.dark),
          backgroundColor: HexColor("#fed701"),
          elevation: 0,
        ),
        body: Center(child: IconButton(onPressed: () => signout(), icon: Icon(Icons.logout,size: 30)),),
      ),
    );
  }

  Future signout() async
  {
    await ShareP.removeToken();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LogIn()));

  }
}
