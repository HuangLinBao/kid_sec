import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:kid_sec/core/constants/colors/kolors.dart';
import 'package:kid_sec/main.dart';
import 'package:kid_sec/utils/logger.dart';
import 'package:kid_sec/utils/essentials.dart';
import 'package:usage_stats/usage_stats.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  dynamic body = Get.arguments[0];
  final bool isParent = Get.arguments[1];
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  final Location _location = Location();
  final log = logger(Splash);
  late Future<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
    initAllData();
  }

  Future<void> storeUsageData() async {
    UsageStats.grantUsagePermission();

   if(!isParent) {
     FirebaseFirestore firestore = FirebaseFirestore.instance;
     String token = sharedPreferences.getString('DeviceToken')??'';
     DateTime endDate = DateTime.now();
     DateTime startDate = endDate.subtract(const Duration(days: 7));
     List<String> systemPackages = [
       "com.android.systemui",
       "com.android.settings"
     ];
     List<UsageInfo> usageInfos = await UsageStats.queryUsageStats(
         startDate, endDate);
     List<UsageInfo> filtered = usageInfos.where((info) =>
     info.packageName != "com.android.systemui").toList();



     int totalTimeInMinutes = 0;
     for (var usageInfo in filtered) {

       totalTimeInMinutes +=
           double.parse(usageInfo.totalTimeInForeground!) / 1000 ~/ 60;
     }
     log.i("total usage : $totalTimeInMinutes");


     sharedPreferences.setInt("totalTimeInWeek", totalTimeInMinutes);

     List<Map<String, dynamic>> dailyScreenTime = <Map<String, dynamic>>[];

     for (var usageInfo in filtered) {
       DateTime date = DateTime.fromMillisecondsSinceEpoch(
           int.parse(usageInfo.lastTimeUsed!));
       int screenTime = double.parse(usageInfo.totalTimeInForeground!) / 1000 ~/
           60;

       Map<String, dynamic> entry = {
         "date": date.toString(),
         "screenTime": screenTime
       };
       dailyScreenTime.add(entry);
     }
     // for (var entry in dailyScreenTime.entries) {
     //   log.i("Date: ${entry.key}, Screen Time: ${entry.value} minutes");
     // }
     log.i("Daily usage time : $dailyScreenTime");

     // Create an empty list with 7 elements, one for each day of the week
     final List<Map<String, dynamic>> weeklyScreenTime = List.generate(7, (_) => { "date": "", "screenTime": 0 });

     for (var usageInfo in filtered) {
       DateTime date = DateTime.fromMillisecondsSinceEpoch(
           int.parse(usageInfo.lastTimeUsed!));
       int screenTime = double.parse(usageInfo.totalTimeInForeground!) / 1000 ~/
           60;

       // Get the day of the week for the current usageInfo
       final dayOfWeek = date.weekday;

       // Add the screen time for the current usageInfo to the appropriate day of the week
       weeklyScreenTime[dayOfWeek - 1]["date"] = date.toString();
       weeklyScreenTime[dayOfWeek - 1]["screenTime"] += screenTime;
     }




     DateTime today = DateTime.now();
     List<UsageInfo> todayUsageInfos = filtered
         .where((info) =>
     info.lastTimeUsed != null &&
         DateTime
             .fromMillisecondsSinceEpoch(int.parse(info.lastTimeUsed!))
             .day ==
             today.day &&
         DateTime
             .fromMillisecondsSinceEpoch(int.parse(info.lastTimeUsed!))
             .month ==
             today.month &&
         DateTime
             .fromMillisecondsSinceEpoch(int.parse(info.lastTimeUsed!))
             .year ==
             today.year)
         .toList();


     DateTime end = DateTime.now();
     DateTime start = endDate.subtract(const Duration(days: 1));
     List<UsageInfo> usageInformation = await UsageStats.queryUsageStats(
         start, end);
     List<UsageInfo> filteredUsageInfos = [];
     for (var i in usageInformation) {
       if (!systemPackages.contains(i.packageName)) {
         filteredUsageInfos.add(i);
       }
     }


    List <Map<String, dynamic>> jsonObject = [

     ];


     for (var i in filteredUsageInfos) {
       if (double.parse(i.totalTimeInForeground!) > 0) {
         jsonObject.add({
           "packageName": i.packageName,
           "Screen Time" : i.totalTimeInForeground!
         });

       }
     }


     final Stream<QuerySnapshot> querySnapshot = FirebaseFirestore.instance
        .collection('userTokens')
        .where('token', isEqualTo: token)
        .snapshots();

    querySnapshot.listen((snapshot) {
    for (var document in snapshot.docs) {
    log.i("Firestore Document ${document.id}");
    final documentReference = FirebaseFirestore.instance
          .collection('userTokens')
          .doc(document.id);
      documentReference.set({
        "token" : token,
        "Today's usage": jsonObject,
        "Daily Screen Time" : weeklyScreenTime,
        "isChild" : true
      });
    }
    });



   }
  }

  void initAllData() async {
    var futures = [initLocation(), storeUsageData(), saveLocation(), fetchDataAndSave()];
    await Future.wait(futures);

    String name = sharedPreferences.getString('DeviceName') ?? '';
    String token = sharedPreferences.getString('DeviceToken') ?? '';
    String id = sharedPreferences.getString('tmp') ?? '';
    var storeDataFuture = [
      saveTokenNetworkCall(token, id),
      saveNameNetworkCall(name, id)
    ];
    await Future.wait(storeDataFuture);

    Get.offAllNamed(isParent ? '/home' : '/homeChild');
  }

  Future<void> saveLocation() async {
    LocationData locationData = await _location.getLocation();
    log.i(locationData);
    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', locationData.latitude!);
    sharedPreferences.setDouble('longitude', locationData.longitude!);
  }

  Future<void> initLocation() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await _location.requestService().then((value) {
        log.i(value);
        return value;
      });
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }
    log.i(_permissionGranted);
    return;
  }

  Future<void> fetchDataAndSave() async {
    data = fetchIdNetworkCall(body).then((data) {
      String id = data.values.elementAt(0);
      String name = data.values.elementAt(1);
      sharedPreferences.setString('tmp', id);
      sharedPreferences.setString("Username",name );
      log.i(id);
      log.i(isParent);
      if (isParent) {
        sharedPreferences.setString('UserID', id);
      } else {
        sharedPreferences.setString('ChildID', id);
      }

      return data;
      // do something with externalString
    });
  }

  Future<void> initFirebase() async {
    data = fetchIdNetworkCall(body).then((data) {
      String id = data.values.elementAt(0);
      log.i(id);
      if (isParent) {
        sharedPreferences.setString('UserID', id);
      } else {
        sharedPreferences.setString('ChildID', id);
      }

      return data;
      // do something with externalString
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kolors.KWhite,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/images/illustration6.png")),
            const SizedBox(
              height: 15,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
