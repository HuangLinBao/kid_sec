import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kid_sec/screens/app_list.dart';
import 'package:kid_sec/screens/home_page_parent.dart';
import 'package:kid_sec/screens/kids_list.dart';
import 'package:kid_sec/screens/landing_page.dart';
import 'package:kid_sec/screens/login.dart';
import 'package:kid_sec/screens/signup_child.dart';
import 'package:kid_sec/screens/signup_parent.dart';
import 'core/constants/colors/kolors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

   MyApp({super.key});
  bool isAuth = false; //for authentication

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isAuth ? "/home": "/",
      routes: {
        '/':(context) => LandingPage(),
        '/signup_parent': (context) => ParentSignUp(),
        '/login':(context) => Login(),
        '/home':(context) => HomePage(),
        '/signup_child':(context)=> ChildSignUp(),
        '/kids_list': (context) => ChildrenList(),
        '/app_list': (context) => AppList(),
      },

      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Kolors.mkFuchsia)
            .copyWith(secondary: Kolors.mkFuchsia),
      ),

    );
  }
}

