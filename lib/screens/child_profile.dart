import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kid_sec/main.dart';
import 'package:kid_sec/widgets/profile_banner.dart';
import 'package:http/http.dart' as http;
import '../core/constants/colors/kolors.dart';
import '../utils/essentials.dart';
import '../utils/logger.dart';
import '../widgets/bar_chart.dart';
import '../widgets/main_page_card.dart';
import '../widgets/skeleton_container.dart';

class ChildProfile extends StatefulWidget {
  const ChildProfile({super.key});

  @override
  _ChildProfileState createState() => _ChildProfileState();
}



class _ChildProfileState extends State<ChildProfile> {
  List body = Get.arguments;
  final log = logger(ChildProfile);
  late Future<Map<String,dynamic>>  _kidData;

  late Future<List<dynamic>> _usage;



  Future<Map<String,dynamic>> _fetchNetworkCall()async{
    late var res;
    late Map<String, dynamic> user;

    String param = body[1];
    var url =  Uri.parse(
        "https://zesty-skate-production.up.railway.app/api/names/byID/$param");
    await http
        .get(url,
      headers: <String, String>{
        'Content-Type':
        'application/json; charset=UTF-8',
      },
    )
        .then((response) {
      res =response.body;
      user = jsonDecode(res);

    }).catchError((error) {
      // Handle any errors that may have occurred
      return(error);
    });
    return user;

  }

  initToken()async{
    var futures = [fetchTokenNetworkCall(body[1])];
    await Future.wait(futures);
    String token = sharedPreferences.getString("tmpToken")??'';
    _usage = fetchDailyUsage(token);


  }
  @override
  void initState() {
    super.initState();
    _kidData = _fetchNetworkCall();
    initToken();
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
                        tag: '$body[1]',
                        child: const CircleAvatar(
                          backgroundColor: Kolors.KWhite,
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/kid.png'),
                        ),
                      ),
                    ),
                  ),

                  FutureBuilder<Map<String,dynamic>>(
                    future: _kidData, // async work
                    builder: (ctx,snapshot){
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
                          final data = snapshot.data as Map<String,dynamic>;
                          return  Text(
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
                        child:  SkeletonContainer.rounded(
                          width: 160,
                          height: 20,
                        ),
                      );
                    },


                  ),
                  FutureBuilder<Map<String,dynamic>>(
                    future: _kidData, // async work
                    builder: (ctx,snapshot){
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
                          final data = snapshot.data as Map<String,dynamic>;
                          return  Text(
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
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      primary: false,
                      crossAxisCount: 1,
                      children: <Widget>[

                        FutureBuilder<Map<String,dynamic>>(
                          future: _kidData, // async work
                          builder: (ctx,snapshot){
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
                                final nameData = snapshot.data as Map<String,dynamic>;
                                return  FutureBuilder<List<dynamic>>(
                                  future: _usage, // async work
                                  builder: (ctx,snapshot){
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
                                        final data = snapshot.data as List<dynamic>;
                                        return  BarChartSample(nameData.values.elementAt(1),data,(){});

                                      }
                                    }



                                    return const SkeletonContainer.card(
                                      width: 160,
                                      height: 160,
                                    );
                                  },


                                );

                              }
                            }



                            return const SkeletonContainer.card(
                              width: 160,
                              height: 160,
                            );
                          },


                        ),
                        GridView.count(
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          primary: false,
                          crossAxisCount: 2,
                          children: <Widget>[
                            MainCard('https://www.svgrepo.com/show/177469/browser-web.svg', 'App List', () {Get.toNamed('/app_list',arguments:body[0] ); }),
                            MainCard('https://www.svgrepo.com/show/189280/tasks-tick.svg', "Task List", () {Get.toNamed('/tasks_list',arguments:[body[0],body[1]] );}),
                            MainCard('https://www.svgrepo.com/show/279455/certificate-contract.svg', 'Academic Overview', () {/*TODO coming soon*/ }),
                            MainCard('https://www.svgrepo.com/show/288153/location.svg', 'Location', () {Get.toNamed('/location',arguments:[body[0],body[1]] );}),
                            MainCard('https://www.svgrepo.com/show/454710/feature-security-seo.svg', 'Search Restrictions', () {}),
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
  }
}