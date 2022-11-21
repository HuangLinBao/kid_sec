import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kid_sec/widgets/fieldi.dart';
import 'package:kid_sec/widgets/image_view.dart';
import 'package:kid_sec/widgets/welcome.dart';
import 'core/constants/colors/kolors.dart';
import 'widgets/choice_card.dart';
import 'package:auto_size_text/auto_size_text.dart';


class Parent extends StatelessWidget {
  const Parent({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
            .copyWith(secondary: Colors.pinkAccent),
      ),
      home: const ParentPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class ParentPage extends StatefulWidget {
  const ParentPage({super.key, required this.title});

  final String title;

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  late VoidCallback moveToParentPage;
  late VoidCallback moveToChildPage;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    SizedBox box = SizedBox(
      height: h * 0.08,
    );
    moveToParentPage = () {
      print('Parent');
    };
    moveToChildPage = () {
      print('Child');
    };
    const Radius rad = Radius.circular(15);
    return Scaffold(
      backgroundColor: Kolors.KWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ImageView(),
            box,
            Center(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Fieldi('Name', 'Name'),
                    Fieldi('Email', 'Email'),
                    Fieldi('Password', 'Password'),
                    ElevatedButton(
                        style: ButtonStyle(
                           padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: h*0.02, horizontal: w*0.3)),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(rad),
                                    side: BorderSide(color: Colors.red)
                                )
                            )
                        ),
                        onPressed: () => null,
                        child: Text(
                            "Sign Up".toUpperCase(),
                            style: const TextStyle(fontSize: 25)
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
