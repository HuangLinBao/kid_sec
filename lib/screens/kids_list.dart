import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kid_sec/widgets/children_card.dart';

import 'package:kid_sec/widgets/main_page_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChildrenList extends StatefulWidget {
  const ChildrenList({super.key});

  @override
  _ChildrenListState createState() => _ChildrenListState();
}

class _ChildrenListState extends State<ChildrenList> {
  @override
  Widget build(BuildContext context) {
    // to get size
    var size = MediaQuery.of(context).size;
    var children = Get.arguments;
    print(children);
    print("children");

    // style
    const cardTextStyle = TextStyle(
        fontFamily: "Montserrat Regular",
        fontSize: 14,
        color: Color.fromRGBO(63, 63, 63, 1));
      var data = {
                                "email": children,
                              };
                              print(data);
                              // Encode the JSON object as a string
                              var body = jsonEncode(data);
                              print(body);
                              var url = Uri.parse(
                                  "https://kidsec-backend-production.up.railway.app/api/children");
                              http
                                  .post(url,
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                      },
                                      body: body)
                                  .then((response) {
                                // Process the response
                                print(response.body);
                              }).catchError((error) {
                                // Handle any errors that may have occurred
                                print(error);
                              });
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
                            children: const <Widget>[
                              Text(
                                'John Richardo',
                                style: TextStyle(
                                    fontFamily: "Montserrat Medium",
                                    color: Colors.white,
                                    fontSize: 20),
                              ),
                              Text(
                                '4040404040404',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: "Montserrat Regular"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection:Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          ChildrenCard("assets/images/kid.png","Lorem","04/10/2000"),
                          ChildrenCard("assets/images/kid.png","Lorem","04/10/2000"),
                          ChildrenCard("assets/images/kid.png","Lorem","04/10/2000"),
                          ChildrenCard("assets/images/kid.png","Lorem","04/10/2000"),
                        ],
                      ),
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