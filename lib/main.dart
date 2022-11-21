import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kid_sec/parent.dart';
import 'package:kid_sec/widgets/welcome.dart';
import 'core/constants/colors/kolors.dart';
import 'widgets/choice_card.dart';
import 'package:auto_size_text/auto_size_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
            .copyWith(secondary: Colors.pinkAccent),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VoidCallback moveToParentPage;
  late VoidCallback moveToChildPage;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    SizedBox box = SizedBox(
      height: h * 0.08,
    );
    moveToParentPage = () {
      Get.to(Parent());
    };
    moveToChildPage = () {
      print('Child');
    };
    return Scaffold(
      backgroundColor: Kolors.KWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Welcome(),
            box,
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ChoiceCard(
                      'assets/images/kid.png', 'The Child', moveToChildPage),
                  ChoiceCard('assets/images/parent.png', 'The Guardian',
                      moveToParentPage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
