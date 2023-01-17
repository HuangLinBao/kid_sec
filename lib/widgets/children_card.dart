import 'package:flutter/material.dart';

import '../core/constants/colors/kolors.dart';

class ChildrenCard extends StatelessWidget {
  late TextStyle style;
  late String img;
  late String city;
  late String dates;
  late TextStyle styleSub;
  late VoidCallback onClick;
  late String  childId;
  ChildrenCard(String image, String cityName, String  id, String date, VoidCallback onTap,{Key? key}) : super(key: key) {
    img = image;
    city = cityName;
    childId= id;
    dates = date;
    style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color:Color(0xff222227));
    styleSub = const TextStyle(fontSize: 12,color: Color(0xff455774));
    onClick = onTap;
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:  const BorderSide(
          color:Kolors.KBlack,
          width: 3,
        ),

      ),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
      child:
      SizedBox(
        height: 75,
        child: InkWell(
          onTap: onClick,
          child: Center(
            child: Stack(
              children: [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),//or 15.0
                    child:  SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 1.5, color: Colors.black),
                        ),
                        child: Hero(
                          
                          tag: childId,
                          child: CircleAvatar(
                            backgroundColor: Kolors.KWhite,
                            backgroundImage: AssetImage(
                              img,
                            ),
                          ),
                        ),
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