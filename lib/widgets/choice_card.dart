import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/constants/colors/kolors.dart';



class ChoiceCard extends StatefulWidget {

  late String img;
  late String choices;
  late TextStyle styleChoice;
  late VoidCallback onClick;

  ChoiceCard(String image, String choice,VoidCallback onTap, {Key? key}) : super(key: key) {
    img = image;
    choices = choice;
    styleChoice = const TextStyle(
        fontWeight: FontWeight.bold, fontSize: 17, color: Kolors.KBlack);
    onClick = onTap;

  }


  @override
  State<ChoiceCard> createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 170,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 3,
            color:Colors.black,
          ),
        ),
        child: InkWell(
          onTap:
            widget.onClick,
          focusColor: Kolors.KBlack,
          child: Stack(
            children: [
              Center(
                child: Card(
                  shape:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.transparent, width: 1)
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)) ,
                    child: Image.asset(
                      widget.img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    widget.choices,
                    textAlign: TextAlign.left,
                    style: widget.styleChoice,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('style_city', widget.styleChoice));
  }
}

