import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kid_sec/widgets/children_card.dart';
import 'package:kid_sec/widgets/profile_banner.dart';
import '../utils/logger.dart';
import '../widgets/skeleton_container.dart';

class ChildrenList extends StatefulWidget {
  const ChildrenList({super.key});

  @override
  _ChildrenListState createState() => _ChildrenListState();
}

class _ChildrenListState extends State<ChildrenList> {
  var body = Get.arguments;
  late Future<List> _kidsData;
  final log = logger(ChildrenList);

  Future<List> _fetchNetworkCall() async {
    late var res;
    late List user;
    final data = body;
    String param = data.values.elementAt(0);
    var url = Uri.parse(
        "https://zesty-skate-production.up.railway.app/api/children/list/$param");
    await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      // Process the response
      res = response.body;
      user = jsonDecode(res);
      return user;
    }).catchError((error) {
      log.e("from fetchNetworkCall => $error");
      return Future.value([error]);
    });
    return user;
  }

  @override
  void initState() {
    super.initState();
    _kidsData = _fetchNetworkCall();
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
                  SizedBox(
                    height: size.height * 0.16,
                  ),
                  Expanded(
                    child: FutureBuilder<List>(
                      future: _kidsData, // async work
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
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
                          }
                          else if (snapshot.hasData) {
                            // Extracting data from snapshot object
                            final data =
                            snapshot.data as List;
                            List<Widget> cardsList = [];
                            if(data.isNotEmpty){
                              for (int i = 0; i < data.length; i++) {
                                cardsList.add(ChildrenCard(
                                    "assets/images/kid.png",
                                    data[i]['name'],
                                    data[i]['id'],
                                    data[i]['email'], () {
                                  Get.toNamed('/child_profile',
                                      arguments:[ body, data[i]['id']]);
                                }));
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: cardsList,
                                ),
                              );
                            }else{
                              return Container();
                            }
                          }
                        }

                        return Column(
                          children: [
                            SkeletonContainer.rounded(
                              width: size.width * 0.8,
                              height: 75,
                            ),
                            const SizedBox(height: 10,),
                            SkeletonContainer.rounded(
                              width: size.width * 0.8,
                              height: 75,
                            ),
                            const SizedBox(height: 10,),
                            SkeletonContainer.rounded(
                              width: size.width * 0.8,
                              height: 75,
                            ),
                            const SizedBox(height: 10,),
                            SkeletonContainer.rounded(
                              width: size.width * 0.8,
                              height: 75,
                            ),
                            const SizedBox(height: 10,),
                            SkeletonContainer.rounded(
                              width: size.width * 0.8,
                              height: 75,
                            ),
                            const SizedBox(height: 10,),
                            SkeletonContainer.rounded(
                              width: size.width * 0.8,
                              height: 75,
                            ),

                          ],
                        );
                      },
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
