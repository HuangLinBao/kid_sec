import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../core/constants/colors/kolors.dart';



class MainCard extends StatefulWidget {

  late String img;
  late String goTo;
  late TextStyle styleGoTo;
  late VoidCallback onClick;

  MainCard(String image, String goto,VoidCallback onTap, {Key? key}) : super(key: key) {
    img = image;
    goTo = goto;
    styleGoTo = const TextStyle(
       fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Kolors.KBlack);
    onClick = onTap;

  }


  @override
  State<MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape:RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      elevation: 4,
      child: InkWell(
        onTap: widget.onClick,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.network(
             widget.img,
              height: 128,
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                widget.goTo,
                style: widget.styleGoTo,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('style_city', widget.styleGoTo));
  }
}

