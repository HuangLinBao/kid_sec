import 'dart:math';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../core/constants/colors/kolors.dart';


class ImageView extends StatefulWidget {


  const ImageView({Key? key}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late TextStyle welcomeStyle;

  var ImageList = ['illustration1.png', 'illustration2.png','illustration3.png', 'illustration4.png'];
  @override
  initState() {
    super.initState();
    ImageList.shuffle();
  }

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
    String element = ImageList[0];
    String img = 'assets/images/$element';
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Center(
          child: ClipRRect(
            child: Image.asset(
              img,
              width: w*0.9,
              height: h*0.15,
              fit: BoxFit.contain,
            ),
          ),
        ),

      ],
    );
  }
}
