import 'package:flutter/material.dart';

class AppCard extends StatefulWidget {
  late TextStyle style;
  late String img;
  late String city;
  late String dates;
  late TextStyle styleSub;

  AppCard(String image, String cityName,String date, {Key? key}) : super(key: key) {
    img = image;
    city = cityName;
    dates = date;
    style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color:Color(0xff222227));
    styleSub = const TextStyle(fontSize: 12,color: Color(0xff455774));
  }

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = true;

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
                        widget.img,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    widget.city,
                    style: widget.style,
                  ),
                  subtitle: Text(
                    widget.dates,
                    style: widget.styleSub,
                  ),
                  trailing: Switch(
                    onChanged: (isChecked) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    }, value: isChecked,

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