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

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  List body = Get.arguments;
  final log = logger(TasksList);
  late Future<Map<String, dynamic>> _kidData;
  late Future<List> _tasksList;
  late TextEditingController controller;
  late Future <String> _token;
  late Future <String> _name;

  void initData() async{

    _kidData = fetchNetworkCall(body[1]);
    _tasksList = fetchTasksList(body[1]);
    var storeDataFuture = [fetchTokenNetworkCall(body[1]),fetchDeviceNetworkCall(body[1])];
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

    Future<bool?> openDelete() => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  color: Kolors.KBlack,
                  width: 3,
                ),
              ),
              title: const Text('Add a new Task'),
              content: SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.network(
                      "https://www.svgrepo.com/show/206436/delete-exit.svg",
                      height: 90,
                    ),
                    const Text(
                      'Delete This Task?',
                      style: TextStyle(
                          fontFamily: "Montserrat Medium",
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("Yes")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("No")),

              ],
            )
    );

    Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  color: Kolors.KBlack,
                  width: 3,
                ),
              ),
              title: const Text('Add a new Task'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Description'),
                onSubmitted: (_) {
                  Navigator.of(context).pop(controller.text);
                  controller.clear();
                },
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(controller.text);
                      controller.clear();
                    },
                    child: const Text("Add")),
                ElevatedButton(onPressed: cancel, child: const Text("Cancel")),
              ],
            ));

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
                                cardsList.add(TaskCard(data[i]['description'],
                                    data[i]['_id'].toString(),
                                    (String id) async {
                                  bool? delete;
                                  delete = await openDelete();
                                  log.i(delete);
                                  if (delete!) {
                                    setState(
                                      () {
                                        _tasksList = deleteTaskCallBack(id,body[1]);
                                      },
                                    );
                                  }
                                }));
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'AddTask$body[i]',
        shape: const CircleBorder(
          side: BorderSide(color: Colors.black, width: 2),
        ),
        elevation: 0,
        backgroundColor: Kolors.KWhite,
        onPressed: () async {
          late final task;
          task = await openDialog();

          if (task == null) {
            return;
          } else {
            log.wtf(task.toString());
            _tasksList = addTaskCallBack(task.toString(),body[1]).then((value){
              String token = sharedPreferences.getString('tmpToken')??'';
              sendNotification("Task Added",task.toString(),token);
              return value;
            });
          }
        },
        child: SvgPicture.network(
          'https://www.svgrepo.com/show/225884/plus-add.svg',
          height: 35,
        ),
      ),
    );
  }
}
