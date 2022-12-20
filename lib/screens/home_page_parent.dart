import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:skeleton_text/skeleton_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:kid_sec/widgets/main_page_card.dart';

import '../widgets/skeleton_container.dart';


class HomePage extends StatefulWidget {
   HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  var body = Get.arguments;
  Future<Map<String,dynamic>> _fetchNetworkCall()async{
    late var res;
    late Map<String, dynamic> user;
    var data = json.encode(body);
    var url =  Uri.parse(
        "https://kidsec-backend-production.up.railway.app/api/names");
    await http
        .post(url,
        headers: <String, String>{
          'Content-Type':
          'application/json; charset=UTF-8',
        },
        body: data)
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

  Widget buildSkeleton(BuildContext context) => Row(
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SkeletonContainer.rounded(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 25,
          ),
          const SizedBox(height: 8),
          const SkeletonContainer.rounded(
            width: 60,
            height: 13,
          ),
        ],
      ),
    ],
  );



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
                  Container(
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: (){},
                          child: const CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(
                                'https://i.pinimg.com/originals/78/07/03/78070395106fcd1c3e66e3b3810568bb.jpg'),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: (){},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  <Widget>[
                              FutureBuilder<Map<String,dynamic>>(
                                future: _fetchNetworkCall(), // async work
                                builder: (ctx,snapshot){
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    // If we got an error
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          '${snapshot.error} occurred',
                                          style: TextStyle(fontSize: 18),
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
                                            color: Colors.white,
                                            fontSize: 20),
                                      );
                                    }
                                  }



                                  return const SkeletonContainer.rounded(
                                    width: 60,
                                    height: 13,
                                  );
                                },




                              ),
                              FutureBuilder<Map<String,dynamic>>(
                                future: _fetchNetworkCall(), // async work
                                builder: (ctx,snapshot){
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    // If we got an error
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(
                                          '${snapshot.error} occurred',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      );

                                      // if we got our data
                                    } else if (snapshot.hasData) {
                                      // Extracting data from snapshot object
                                      final data = snapshot.data as Map<String,dynamic>;
                                      return  Text(
                                        data.values.elementAt(0),
                                        style: const TextStyle(
                                            fontFamily: "Montserrat Medium",
                                            color: Colors.white,
                                            fontSize: 20),
                                      );
                                    }
                                  }



                                  return  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: SkeletonContainer.rounded(
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      height: 15,

                                    ),
                                  );
                                },




                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      primary: false,
                      crossAxisCount: 2,
                      children: <Widget>[
                        MainCard('https://www.svgrepo.com/show/152056/group.svg', "Kids List", () {Get.toNamed('/kids_list',arguments:body ); }),

                        MainCard('https://www.svgrepo.com/show/177469/browser-web.svg', 'App List', () {Get.toNamed('/app_list',arguments:body ); }),

                       MainCard('https://www.svgrepo.com/show/262742/clipboard.svg', 'Tasks List', () { }),

                       MainCard('https://www.svgrepo.com/show/279455/certificate-contract.svg', 'Academic Overview', () { }),

                        MainCard('https://www.svgrepo.com/show/288153/location.svg', 'Location', () { }),

                        MainCard('https://www.svgrepo.com/show/3907/search.svg', 'Search Restrictions', () { }),
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