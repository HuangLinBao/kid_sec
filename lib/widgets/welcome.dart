import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../core/constants/colors/kolors.dart';


class Welcome extends StatefulWidget {

  late TextStyle welcomeStyle;

  Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery
        .of(context)
        .size
        .height;
    double w = MediaQuery
        .of(context)
        .size
        .width;
    const Radius rad = Radius.circular(15);
    TextStyle welcomeStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: w * 0.5, color: Kolors.KWhite);
    TextStyle welcomeStyle2 = TextStyle(
        fontWeight: FontWeight.bold, fontSize: w * 0.08, color: Kolors.KBlack);
    SizedBox box = SizedBox(
      height: h*0.07,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              color: Kolors.kSuperLightFuchsia,
              borderRadius: const BorderRadius.only(
                  topRight: rad, bottomRight: rad),
              border: Border.all(
                width: 3,
                color: Colors.black,
              ),
            ),
            width: w * 0.85,
            height: h * 0.13,
            child: Padding(
              padding:  EdgeInsets.all(w*0.019),
              child: Center(
                child: AutoSizeText(
                  "It is easier to build up a child than it is to repair an adult.",
                  style: welcomeStyle,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                ),
              ),
            ),
          ),
        ),
        box,
        AutoSizeText(
          "Who's using this phone?",
          style: welcomeStyle2,
          textAlign: TextAlign.left,
          maxLines: 2,
        ),


      ],
    );
  }
}
