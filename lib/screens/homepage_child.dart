import 'package:kid_sec/main.dart';
import 'package:kid_sec/widgets/profile_banner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kid_sec/widgets/main_page_card.dart';

import '../utils/essentials.dart';
import '../utils/logger.dart';
import '../widgets/bar_chart.dart';
import '../widgets/skeleton_container.dart';


class ChildHomePage extends StatefulWidget {
  const ChildHomePage({super.key});

  @override
  _ChildHomePageState createState() => _ChildHomePageState();
}



class _ChildHomePageState extends State<ChildHomePage> {
  dynamic body = Get.arguments;
  final log = logger(ChildHomePage);


  final String userId = getChildIdFromSharedPrefs();
  final String username = sharedPreferences.getString("Username")??'';
  final String token = sharedPreferences.getString("DeviceToken")??'';
  late Future <List<dynamic>> _dailyUsage;

  _fetchData() async{
    _dailyUsage = fetchDailyUsage(token);
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
                  ProfileBanner(userId),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      primary: false,
                      crossAxisCount: 1,
                      children: <Widget>[
                        FutureBuilder<List<dynamic>>(
                          future: _dailyUsage, // async work
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
                                return  BarChartSample(username,data,(){});

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
                            MainCard('https://www.svgrepo.com/show/288153/location.svg', "My location", () {Get.toNamed('/location_child',arguments:userId ); }),
                            MainCard('https://www.svgrepo.com/show/262742/clipboard.svg', "My Tasks", () {Get.toNamed('/tasks_child',arguments:[userId]); }),
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

class ToNamed {
}