import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kid_sec/widgets/map.dart';
import 'package:kid_sec/widgets/profile_banner.dart';
import 'package:http/http.dart' as http;
import '../core/constants/colors/kolors.dart';
import '../utils/logger.dart';
import '../widgets/skeleton_container.dart';

class ChildLocation extends StatefulWidget {
  const ChildLocation({super.key});

  @override
  _ChildLocationState createState() => _ChildLocationState();
}

class _ChildLocationState extends State<ChildLocation> {
  List body = Get.arguments;
  final log = logger(ChildLocation);
  late Future<Map<String, dynamic>> _kidData;
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
    _kidData = _fetchNetworkCall();

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
                  ProfileBanner(body[0]),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3.0, color: Colors.black),
                      ),
                      child:  Hero(
                        tag: 'prof$body[1]',
                        child: const CircleAvatar(
                          backgroundColor: Kolors.KWhite,
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/kid.png'),
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _kidData, // async work
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If we got an error
                        if (snapshot.hasError) {
                          log.e("${snapshot.error}");
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: const TextStyle(fontSize: 15),
                            ),
                          );

                          // if we got our data
                        } else if (snapshot.hasData) {
                          // Extracting data from snapshot object
                          final data = snapshot.data as Map<String, dynamic>;
                          return Text(
                            data.values.elementAt(1),
                            style: const TextStyle(
                                fontFamily: "Montserrat Medium",
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          );
                        }
                      }

                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SkeletonContainer.rounded(
                          width: 160,
                          height: 20,
                        ),
                      );
                    },
                  ),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _kidData, // async work
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If we got an error
                        if (snapshot.hasError) {
                          log.e("${snapshot.error}");
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: const TextStyle(fontSize: 15),
                            ),
                          );

                          // if we got our data
                        } else if (snapshot.hasData) {
                          // Extracting data from snapshot object
                          final data = snapshot.data as Map<String, dynamic>;
                          return Text(
                            data.values.elementAt(2),
                            style: const TextStyle(
                                fontFamily: "Montserrat Medium",
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          );
                        }
                      }
                      return const SkeletonContainer.rounded(
                        width: 100,
                        height: 13,
                      );
                    },
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
