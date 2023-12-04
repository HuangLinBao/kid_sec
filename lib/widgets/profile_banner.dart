import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kid_sec/widgets/skeleton_container.dart';

import '../utils/logger.dart';

class ProfileBanner extends StatefulWidget {
  late String body;
  ProfileBanner(  String  b, {Key? key}) : super(key: key) {
    body = b;
  }

  @override
  State<ProfileBanner> createState() => _ProfileBannerState();
}

class _ProfileBannerState extends State<ProfileBanner> {
  final log = logger(ProfileBanner);
  late Future<Map<String,dynamic>>  _data;
  Future<Map<String,dynamic>> _fetchNetworkCall()async{
    late var res;
    late Map<String, dynamic> user;
    final data = widget.body;
    String param = data;
    var url =  Uri.parse(
        "https://zesty-skate-production.up.railway.app/api/names/byID/"+ param);
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

  @override
  void initState() {
    super.initState();
    _data = _fetchNetworkCall();
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

    return Container(
      height: 54,
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: (){},
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2.0, color: Colors.black),
              ),
              child: const CircleAvatar(

                radius: 32,
                backgroundImage: NetworkImage(
                    'https://i.pinimg.com/originals/78/07/03/78070395106fcd1c3e66e3b3810568bb.jpg'),
              ),
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
                  future: _data, // async work
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
                              color: Colors.white,
                              fontSize: 18),
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
                        log.e( "${snapshot.error}");
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: const TextStyle(fontSize: 18),
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
                              fontSize: 18),
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
    );
  }
}