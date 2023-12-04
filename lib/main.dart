
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kid_sec/screens/app_list.dart';
import 'package:kid_sec/screens/child_location.dart';
import 'package:kid_sec/screens/child_profile.dart';
import 'package:kid_sec/screens/home_page_parent.dart';
import 'package:kid_sec/screens/homepage_child.dart';
import 'package:kid_sec/screens/kids_list.dart';
import 'package:kid_sec/screens/landing_page.dart';
import 'package:kid_sec/screens/location.dart';
import 'package:kid_sec/screens/login.dart';
import 'package:kid_sec/screens/signup_child.dart';
import 'package:kid_sec/screens/signup_parent.dart';
import 'package:kid_sec/screens/tasks_list.dart';
import 'package:kid_sec/screens/tasks_list_child.dart';
import 'package:kid_sec/screens/ui/splash.dart';
import 'package:kid_sec/utils/essentials.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/colors/kolors.dart';

late SharedPreferences sharedPreferences;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  await dotenv.load(fileName: "assets/config/.env");
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

   const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuth = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
 //for authentication
   void getInfo() {
     var androidInitialize =
     const AndroidInitializationSettings('@mipmap/ic_launcher');
     var initializationsSettings =
     InitializationSettings(android: androidInitialize);
     flutterLocalNotificationsPlugin.initialize(initializationsSettings,
         onDidReceiveNotificationResponse: onNotificationResponse);
     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
       log.i(
           "onmessage:${message.notification?.title}/${message.notification?.body}");
       BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
         message.notification!.body.toString(),
         htmlFormatBigText: true,
         contentTitle: message.notification!.title.toString(),
         htmlFormatContentTitle: true,
       );
       AndroidNotificationDetails androidPlatformChannelSpecifics =
       AndroidNotificationDetails(
         'dbFood',
         'dbFood',
         importance: Importance.high,
         styleInformation: bigTextStyleInformation,
         priority: Priority.high,
         playSound: true,
       );
       NotificationDetails platformChannelSpecifics =
       NotificationDetails(android: androidPlatformChannelSpecifics);
       await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
           message.notification?.body, platformChannelSpecifics,
           payload: message.data['body']);
     });
   }

   void onNotificationResponse(NotificationResponse response) {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text("response.notification.title"),
           content: const Text(""),
           actions: <Widget>[
             ElevatedButton(
               child: const Text('OK'),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             ),
           ],
         );
       },
     );
   }

  initApp() async{
    var futures = [requestPermissionFireBase(), getToken()];
    await Future.wait(futures);
    getInfo();
  }

   @override
  void initState() {
     initApp();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isAuth ? "/home": "/",
      routes: {
        '/':(context) => const LandingPage(),
        '/signup_parent': (context) => const ParentSignUp(),
        '/login':(context) =>  Login(),
        '/home':(context) => HomePage(),
        '/homeChild':(context) => const ChildHomePage(),
        '/signup_child':(context)=> const ChildRegister(),
        '/kids_list': (context) => const ChildrenList(),
        '/app_list': (context) => const AppList(),
        '/child_profile': (context) => const ChildProfile(),
        '/tasks_list': (context) => const TasksList(),
        '/location': (context) => const ChildLocation(),
        '/splash': (context) => const Splash(),
        '/tasks_child': (context) => const TasksListChild(),
        '/location_child': (context) => const ChildLocationPage(),
      },

      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Kolors.mkFuchsia)
            .copyWith(secondary: Kolors.mkFuchsia),
      ),

    );
  }
}

