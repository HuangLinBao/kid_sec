import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kid_sec/screens/signup_parent.dart';
import '../core/constants/colors/kolors.dart';
import '../widgets/choice_card.dart';
import '../widgets/welcome.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

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
      Get.toNamed("/signup_parent", arguments: true);
    };
    moveToChildPage = () {
      Get.toNamed("/signup_child",arguments: false);
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