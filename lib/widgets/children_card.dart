import 'package:flutter/material.dart';

class ChildrenCard extends StatelessWidget {
  late TextStyle style;
  late String img;
  late String city;
  late String dates;
  late TextStyle styleSub;

  ChildrenCard(String image, String cityName,String date, {Key? key}) : super(key: key) {
    img = image;
    city = cityName;
    dates = date;
    style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color:Color(0xff222227));
    styleSub = const TextStyle(fontSize: 12,color: Color(0xff455774));
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      shape:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.transparent, width: 1)
      ),
      shadowColor: const Color(0xff26364b),
      color: const Color(0xffe1ebf1),
      margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),

      child:
      SizedBox(
        height: 75,
        child: InkWell(
          onTap: (){},
          child: Center(
            child: Stack(
              children: [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),//or 15.0
                    child:  SizedBox(
                      height: 60.0,
                      width: 50.0,
                      child: Image.asset(
                        img,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    city,
                    style: style,
                  ),
                  subtitle: Text(
                    dates,
                    style: styleSub,
                  ),

                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}