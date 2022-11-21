import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/constants/colors/kolors.dart';



class Fieldi extends StatefulWidget {

  late String text;
  late String placeholder;


  Fieldi(String txt, String pholder,{Key? key}) : super(key: key) {
    text = txt;
    placeholder = pholder;

  }


  @override
  State<Fieldi> createState() => _FieldiState();
}

class _FieldiState extends State<Fieldi> {


  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: h*0.03),
      child: TextField(
        cursorHeight: 20,
        autofocus: false,
        controller: TextEditingController(),
        decoration: InputDecoration(
          labelText: widget.text,
          hintText: widget.placeholder,
          contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            gapPadding: 0.0,
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.pink, width: 1.5),
          ),
        ),
      ),
    );
  }

}

