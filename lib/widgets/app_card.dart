import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../core/constants/colors/kolors.dart';
import '../utils/logger.dart';

class AppCard extends StatefulWidget {
  late TextStyle style;
  late String img;
  late String city;
  AppCard(String image, String cityName, {Key? key }) : super(key: key) {
    img = image;
    city = cityName;
    style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color:Color(0xff222227));
  }




  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard>  with SingleTickerProviderStateMixin{
  final log = logger(AppCard);
  bool _value = false;

  void _onChanged(bool value) {
    setState(() {
      _value = value;
    });
  }



  @override
  void initState(){

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

      color: Kolors.KWhite,
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
                      child: SvgPicture.network(
                        widget.img,
                        height: 128,
                      ),
                    ),
                  ),
                  title: Text(
                    widget.city,
                    style: widget.style,
                  ),

                  trailing: Switch(
                    value: _value,
                    onChanged: _onChanged,
                    activeColor: Kolors.kFuchsia,
                  )
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}