import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kid_sec/main.dart';
import 'package:kid_sec/widgets/profile_banner.dart';
import 'package:kid_sec/widgets/tasks_card.dart';
import '../core/constants/colors/kolors.dart';
import '../utils/logger.dart';
import '../widgets/skeleton_container.dart';
import 'package:kid_sec/utils/essentials.dart';

import '../widgets/task_card_child.dart';

class TasksListChild extends StatefulWidget {
  const TasksListChild({super.key});

  @override
  _TasksListChildState createState() => _TasksListChildState();
}

class _TasksListChildState extends State<TasksListChild> {
  String body = Get.arguments;
  final log = logger(TasksListChild);
  late Future<Map<String, dynamic>> _kidData;
  late Future<List> _tasksList;
  late TextEditingController controller;
  late Future <String> _token;
  late Future <String> _name;

  void initData() async{

    _kidData = fetchNetworkCall(body);
    _tasksList = fetchTasksList(body);
    var storeDataFuture = [fetchTokenNetworkCall(body),fetchDeviceNetworkCall(body)];
    await Future.wait(storeDataFuture);
  }

  @override
  void initState() {
    super.initState();
    initData();
    controller = TextEditingController();

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void cancel() {
    Navigator.of(context).pop();
    controller.clear();
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
                    height: 150,
                  ),

                  Expanded(
                    child: FutureBuilder<List>(
                      future: _tasksList, // async work
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
                            final data = snapshot.data as List;
                            List<Widget> cardsList = [];
                            if (data.isNotEmpty) {
                              for (int i = 0; i < data.length; i++) {
                                cardsList.add(TaskCardChild(data[i]['description'],
                                    data[i]['_id'].toString()));
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: cardsList,
                                ),
                              );
                            } else {
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
                            const SizedBox(
                              height: 10,
                            ),
                            SkeletonContainer.rounded(
                              width: size.width * 0.8,
                              height: 75,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SkeletonContainer.rounded(
                              width: size.width * 0.8,
                              height: 75,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SkeletonContainer.rounded(
                              width: size.width * 0.8,
                              height: 75,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
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
