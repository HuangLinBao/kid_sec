import 'dart:math';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../core/constants/colors/kolors.dart';


class ImageView extends StatelessWidget {

  late TextStyle welcomeStyle;

  ImageView({Key? key}) : super(key: key);

  var ImageList = ['illustration1.png', 'illustration2.png','illustration3.png', 'illustration4.png'];

  final _random = Random();

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
    SizedBox box = SizedBox(
      height: h*0.07,
    );
    var element = ImageList[_random.nextInt(ImageList.length)];
    String img = 'assets/images/$element';
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)) ,
            child: Image.asset(
              img,
              width: w*0.9,
              height: h*0.2,
              fit: BoxFit.contain,
            ),
          ),
        ),

      ],
    );
  }
}
