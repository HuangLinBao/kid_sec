import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kid_sec/widgets/map.dart';
import 'package:kid_sec/widgets/profile_banner.dart';
import 'package:http/http.dart' as http;
import '../core/constants/colors/kolors.dart';
import '../utils/logger.dart';

class ChildLocationPage extends StatefulWidget {
  const ChildLocationPage({super.key});

  @override
  _ChildLocationPageState createState() => _ChildLocationPageState();
}

class _ChildLocationPageState extends State<ChildLocationPage> {
  String body = Get.arguments;
  final log = logger(ChildLocationPage);
  late TextEditingController controller;



  Future<Map<String, dynamic>> _fetchNetworkCall() async {
    late String res;
    late Map<String, dynamic> user;

    String param = body[1];
    var url = Uri.parse(
        "https://zesty-skate-production.up.railway.app/api/names/byID/$param");
    await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      res = response.body;
      user = jsonDecode(res);
    }).catchError((error) {
      // Handle any errors that may have occurred
      return (error);
    });
    return user;
  }



  @override
  void initState() {
    super.initState();
    controller = TextEditingController();

  }







  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


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
                  ProfileBanner(body),
                  const SizedBox(
                    height: 30,
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 450,
                    child: MapBoxMapWidget(),
                  )


                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'AddTask$body[i]',
        shape: const CircleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
        elevation: 0,
        backgroundColor: Kolors.KWhite,
        onPressed: () async {

        },
        child: SvgPicture.network(
          'https://www.svgrepo.com/show/225884/plus-add.svg',
          height: 35,
        ),
      ),
    );
  }
}
