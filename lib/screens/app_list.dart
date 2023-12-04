import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kid_sec/widgets/app_card.dart';
import 'package:kid_sec/widgets/children_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:skeleton_text/skeleton_text.dart';

import '../widgets/profile_banner.dart';
import '../widgets/skeleton_container.dart';


class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  _AppListState createState() => _AppListState();
}



class _AppListState extends State<AppList> {
  var body = Get.arguments;

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
                    height: 100,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection:Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          AppCard("https://www.svgrepo.com/show/262913/youtube.svg","YouTube"),
                          AppCard("https://www.svgrepo.com/show/262914/facebook.svg","Facebook"),
                          AppCard("https://www.svgrepo.com/show/262912/instagram.svg","Instagram"),
                          AppCard("https://www.svgrepo.com/show/271174/chrome.svg","Google Chrome"),
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