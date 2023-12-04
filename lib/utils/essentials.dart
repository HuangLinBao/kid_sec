import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:http/http.dart' as http;
import 'package:kid_sec/utils/global_logger.dart';
import 'package:latlong2/latlong.dart';
import 'package:turf/helpers.dart';
import '../main.dart';

final log = global_logger();


//Helpers
String generateRandomID() {
  var random = Random();
  var code = "";
  for (var i = 0; i < 5; i++) {
    code += random.nextInt(10).toString();
  }
  return code;
}

Position createRandomPosition() {
  var random = Random();
  return Position(random.nextDouble() * -360.0 + 180.0,
      random.nextDouble() * -180.0 + 90.0);
}


Point createRandomPoint() {
  return Point(coordinates: createRandomPosition());
}


//get snapshot of latest location
LatLng getLatLngFromSharedPrefs() {
  return LatLng(sharedPreferences.getDouble('latitude')!,
      sharedPreferences.getDouble('longitude')!);
}


//User API calls
String getIdFromSharedPrefs() {
  return sharedPreferences.getString('UserID') ?? "";
}

String getChildIdFromSharedPrefs() {
  return sharedPreferences.getString('ChildID') ?? "";
}

Future<Map<String,dynamic>> fetchNetworkCall(String id)async{
  late var res;
  late Map<String, dynamic> user;
  String param = id;
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

Future<Map<String,dynamic>> fetchIdNetworkCall(dynamic body)async{
  late dynamic res;
  late Map<String, dynamic> user;

  String param = body['email'] == "fj7am8q@gfj7.com" ? body['name'] : body['email'];

  var url =  Uri.parse(
      "https://zesty-skate-production.up.railway.app/api/names/$param");
  await http
      .get(url,
    headers: <String, String>{
      'Content-Type':
      'application/json; charset=UTF-8',
    },
  )
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

Future<void> fetchTokenNetworkCall(String id)async{
  late dynamic res;
  String param = id;

  var url =  Uri.parse(
      "https://zesty-skate-production.up.railway.app/api/device/fetch_Token/$param");
  await http
      .get(url,
    headers: <String, String>{
      'Content-Type':
      'application/json; charset=UTF-8',
    },
  )
      .then((response) {

    // Process the response
    res =response.body;
    String tokenID = res;
    sharedPreferences.setString('tmpToken', tokenID);

  }).catchError((error) {
    // Handle any errors that may have occurred
    return(error);
  });


}

Future<void> fetchDeviceNetworkCall(String id)async{
  late dynamic res;
  String param = id;

  var url =  Uri.parse(
      "https://zesty-skate-production.up.railway.app/api/device/fetch_Name/$param");
  await http
      .get(url,
    headers: <String, String>{
      'Content-Type':
      'application/json; charset=UTF-8',
    },
  )
      .then((response) {

    // Process the response
    res =response.body;
    String deviceName = res;
    sharedPreferences.setString('tmpName', deviceName);
  }).catchError((error) {
    // Handle any errors that may have occurred
    return(error);
  });


}

Future<void> saveTokenNetworkCall(String token, String id)async{
  late dynamic res;
  late Map<String, dynamic> user;
  String param = id;

  var data = {
    "deviceToken" : token
  };
  var url =  Uri.parse(
      "https://zesty-skate-production.up.railway.app/api/device/addToken/$param");
  var body = jsonEncode(data);
  http
      .post(url,
      headers: <String, String>{
        'Content-Type':
        'application/json; charset=UTF-8',
      },
      body: body)
      .then((response) {

    Map<String, dynamic> user = jsonDecode(body);
    if(response.statusCode == 200){
      log.i("Success");
      log.i(user);
    }

  }).catchError((error) {
    // Handle any errors that may have occurred
    log.i(error);
  });

}

Future<void> saveNameNetworkCall(String name, String id)async{
  late dynamic res;
  late Map<String, dynamic> user;
  String param = id;

  var data = {
    "deviceName" : name
  };
  var url =  Uri.parse(
      "https://zesty-skate-production.up.railway.app/api/device/addDevice/$param");
var body = jsonEncode(data);
  http
      .post(url,
  headers: <String, String>{
  'Content-Type':
  'application/json; charset=UTF-8',
  },
  body: body)
      .then((response) {

  Map<String, dynamic> user = jsonDecode(body);
  if(response.statusCode == 200){
    log.i("Success");
    log.i(user);
  }

  }).catchError((error) {
  // Handle any errors that may have occurred
  log.i(error);
  });

}

//tasks API calls
Future<List> addTaskCallBack(String taskDescription,String childID) async {
  late var res;
  late List user;
  String param = childID;
  final data = {
    "tasks": [
      {"_id": "1", "description": taskDescription}
    ]
  };
  final requestBody = jsonEncode(data);
  log.i(requestBody);
  var url = Uri.parse(
      "https://zesty-skate-production.up.railway.app/api/tasks/task/$param");
  await http
      .post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody)
      .then((response) {
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

Future<List> deleteTaskCallBack(String id, String childID) async {
  late var res;
  late List user;
  String param = childID;
  final data = {
    "tasks": [
      {"_id": id}
    ]
  };
  final requestBody = jsonEncode(data);
  var url = Uri.parse(
      "https://zesty-skate-production.up.railway.app/api/tasks/delete/$param");
  await http
      .post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBody)
      .then((response) {
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

Future<List> fetchTasksList(String id) async {
  late var res;
  late List user;
  String param = id;
  ;
  var url = Uri.parse(
      "https://zesty-skate-production.up.railway.app/api/tasks/fetch/$param");
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

//Firebase related stuff.
Future<void> requestPermissionFireBase() async {
  log.i("I'm in the function (requestPermission) Rn");
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: false,
    sound: true,
  );
  log.i(settings.authorizationStatus);
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log.i('granted');
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.provisional) {
    log.i('provisional');
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.notDetermined) {
    const pragma("not determined");
  } else {
    log.i('denied');
  }
}

Future<void> sendNotification(String title, String message, String deviceToken) async {
  log.i(deviceToken);
  String key = dotenv.env['FIREBASE_SERVER_KEY']!;
  var data = <String, dynamic>{
    "notification": {
      "body": message,
      "title": title,
      "android_channel_id": "dbFood"
    },
    "priority": "high",
    "data": <String, dynamic>{
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done"
    },
    "to": deviceToken
  };

  final headers = <String, String>{
    'content-type': 'application/json',
    'Authorization':
    'key=	$key'
  };

  http
      .post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: headers,
    body: json.encode(data),
  )
      .then((response) {
    if (response.statusCode == 200) {
      log.i("Notification sent successfully");
    } else {
      log.e(
          "Failed to send notification:\n ${response.statusCode} \n ${response.body.toString()}");
    }
  }).catchError((error) {
    log.e("Error sending notification: $error");
  });
}

Future<String> getToken() async {
  await FirebaseMessaging.instance.getToken().then((token) {
    saveToken(token!).then((value) {
      log.i("Success!");
    });

    return token;
  });

  return '';
}

Future<void> saveToken(String token) async {
  var querySnapshot = await FirebaseFirestore.instance
      .collection("userTokens")
      .where("token", isEqualTo: token)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    log.i("Token already exists");
  } else {
    String id = generateRandomID();
    String name = 'User$id';
    sharedPreferences.setString("DeviceName", name);
    sharedPreferences.setString('DeviceToken', token);
    await FirebaseFirestore.instance
        .collection("userTokens")
        .doc("User$id")
        .set({
      'token': token,
    });
  }
}


Future<List<Map<String, dynamic>>> fetchUsageToday(String token) async {
  List<Map<String, dynamic>> specificField = [];
  var querySnapshot = await FirebaseFirestore.instance
  .collection("userTokens")
      .where("token", isEqualTo: token)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    for (var document in querySnapshot.docs) {
      specificField = document.data()["Today's usage"];
    }
  }
  return specificField;
}


Future<List<dynamic>> fetchDailyUsage (String token) async {
  List<dynamic> specificField = [];
  var querySnapshot = await FirebaseFirestore.instance
      .collection("userTokens")
      .where("token", isEqualTo: token)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    for (var document in querySnapshot.docs) {
       return document.data()["Daily Screen Time"];
    }
  }
  return specificField;
}


Future<List<dynamic>> fetchRandomChild () async {
  List<dynamic> specificField = [];
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('userTokens')
      .where('isChild', isEqualTo: true)
      .get();

  final List<DocumentSnapshot> documents = snapshot.docs;
  log.i("documents list $documents");
  final int randomIndex = Random().nextInt(documents.length);
  final DocumentSnapshot randomDocument = documents[randomIndex];
  final data = randomDocument.data();
  log.i("data is $data");
  if(data != null){
    final Map<String, dynamic> mapData = data as Map<String, dynamic>;
    specificField = mapData['Daily Screen Time'];
    return specificField;
  }


  return specificField;
}



Future<void> backgroundHandler(RemoteMessage message) async {
  log.i('backgroundHandler the ${message.messageId}');
}

Future<DocumentReference> addGeoPoint() async {
  GeoFlutterFire geo = GeoFlutterFire();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  LatLng latLng = getLatLngFromSharedPrefs();
  GeoFirePoint point = geo.point(latitude: latLng.latitude, longitude: latLng.longitude);
  return firestore.collection('locations').add({
    'position': point.data,
    'name': 'Yay I can be queried!'
  });
}



