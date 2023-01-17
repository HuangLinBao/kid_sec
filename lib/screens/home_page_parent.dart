import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kid_sec/widgets/profile_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kid_sec/widgets/main_page_card.dart';

import '../utils/logger.dart';
import '../widgets/bar_chart.dart';


class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
dynamic body = Get.arguments;
late Future<Map<String,dynamic>>  _data;
late SharedPreferences _prefs;
final String _storageKey = "my_data";
final log = logger(HomePage);
Future<Map<String,dynamic>> _fetchNetworkCall()async{
  late var res;
  late Map<String, dynamic> user;
  String param = body['email'] == "fj7am8q@gfj7.com" ? body['name'] : body['email'];

  var url =  Uri.parse(
      "https://zesty-skate-production.up.railway.app/api/names/"+ param);
  await http
      .get(url,
    headers: <String, String>{
      'Content-Type':
      'application/json; charset=UTF-8',
    },
  )
      .then((response) {

    // Process the response
    res =response.body;
    user = jsonDecode(res);

  }).catchError((error) {
    // Handle any errors that may have occurred
    return(error);
  });
  return user;

}

Future<void> _fetchData() async {
  _prefs = await SharedPreferences.getInstance();
  final data = _prefs.getString(_storageKey);
  if (data != null) {
    _data = Future.value(jsonDecode(data));
  } else {
    _data = _fetchNetworkCall();
  }
}

@override
void initState() {
  super.initState();
  _fetchData();
}



  @override
  Widget build(BuildContext context) {

    // to get size
    var size = MediaQuery.of(context).size;


    return
      FutureBuilder<Map<String,dynamic>>(
          future: _data,
          builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>> snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                body: Stack(
                  children: <Widget>[
                    Container(
                      height: size.height * .3,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage('assets/images/header.png')),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            ProfileBanner(snapshot.data!),
                            Expanded(
                              child: GridView.count(
                                mainAxisSpacing: 3,
                                crossAxisSpacing: 3,
                                primary: false,
                                crossAxisCount: 1,
                                children: <Widget>[
                                  const BarChartSample(),
                                  GridView.count(
                                    mainAxisSpacing: 0,
                                    crossAxisSpacing: 0,
                                    primary: false,
                                    crossAxisCount: 2,
                                    children: <Widget>[
                                      MainCard('https://www.svgrepo.com/show/152056/group.svg', "Kids List", () {Get.toNamed('/kids_list',arguments:snapshot.data ); }),
                                      MainCard('https://www.svgrepo.com/show/262742/clipboard.svg', "Task Board", () {Get.toNamed('/kids_list',arguments:snapshot.data ); }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              log.e(snapshot.error);
              return Text("Error: ${snapshot.error}");

            }
            return
              Scaffold(
                body: Stack(
                  children: <Widget>[
                    Container(
                      height: size.height * .3,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage('assets/images/header.png')),
                      ),
                    ),
                    const SafeArea(
                      child:
                      Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              );

          });


  }
}

class ToNamed {
}