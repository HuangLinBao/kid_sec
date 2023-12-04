import 'package:kid_sec/widgets/profile_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kid_sec/widgets/main_page_card.dart';
import 'package:kid_sec/widgets/skeleton_container.dart';

import '../utils/essentials.dart';
import '../utils/logger.dart';
import '../widgets/bar_chart.dart';


class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
dynamic body = Get.arguments;
final log = logger(HomePage);
String? userId = getIdFromSharedPrefs();
late Future<List<dynamic>> _randomChild;
@override
void initState() {
  super.initState();
  WidgetsFlutterBinding.ensureInitialized();
  _randomChild = fetchRandomChild();
}

 @override
  Widget build(BuildContext context) {
    log.i(userId);
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
                  ProfileBanner(userId!),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      primary: false,
                      crossAxisCount: 1,
                      children: <Widget>[
                        FutureBuilder<List<dynamic>>(
                        future: _randomChild, // async work
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
                    final list  = snapshot.data as List<dynamic>;
                    return  BarChartSample("Lorem",list,(){});

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
                            MainCard('https://www.svgrepo.com/show/152056/group.svg', "Kids List", () { WidgetsBinding.instance.addPostFrameCallback((_) {
                              Get.toNamed('/kids_list',arguments:userId! );
                            }); }),
                            MainCard('https://www.svgrepo.com/show/262742/clipboard.svg', "Task Board", () { WidgetsBinding.instance.addPostFrameCallback((_) {
                              Get.toNamed('/kids_list',arguments:userId! );
                            });}),
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