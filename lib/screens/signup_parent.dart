import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:kid_sec/screens/login.dart';
import 'package:kid_sec/widgets/image_view.dart';
import 'package:kid_sec/widgets/welcome.dart';
import '../core/constants/colors/kolors.dart';
import '../widgets/choice_card.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParentSignUp extends StatelessWidget {
  const ParentSignUp({super.key});

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
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _password;
  late String _email;
  late VoidCallback moveToParentPage;
  late VoidCallback moveToChildPage;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    SizedBox box = SizedBox(
      height: h * 0.02,
    );
    moveToParentPage = () {
      print('Parent');
    };
    moveToChildPage = () {
      print('Child');
    };
    const Radius rad = Radius.circular(25);
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Kolors.KWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageView(),
              box,
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                          },
                          onSaved: (value) => _username = value!,
                        ),
                        box,
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                          },
                          onSaved: (value) => _email = value!,
                        ),
                        box,
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                          },
                          onSaved: (value) => _password = value!,
                        ),
                        box,
                        ElevatedButton(
                          child: Text('Sign up'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // TODO: Perform login using the _username and _password
                               var data = {
                                "name": _username,
                                "email": _email,
                                "parent_email":"",
                                "password": _password,
                                "tag": "parent"
                              };
                              print(data);
                              // Encode the JSON object as a string
                              var body = jsonEncode(data);
                              print(body);
                              var url = Uri.parse(
                                  "https://kidsec-backend-production.up.railway.app/api/users");
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

                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.25 * h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  InkWell(
                    child: const Text(" Login",
                        style:
                            TextStyle(fontSize: 15, color: Kolors.kFuchsia)),
                    onTap: () {
                      Get.to(const Login());
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
