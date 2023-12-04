import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kid_sec/screens/home_page_parent.dart';
import 'package:kid_sec/screens/signup_parent.dart';
import 'package:kid_sec/widgets/image_view.dart';
import '../core/constants/colors/kolors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/logger.dart';

abstract class ValidatorMixin {
  String validate();
}
class EitherOrValidator extends ValidatorMixin {
  final String errorText;
  final List<String> fields;

  EitherOrValidator({
    required this.errorText,
    required this.fields,
  });

  @override
  String validate() {
    int filledFields = 0;
    for (var i = 0; i < fields.length; i++) {
      if (fields[i].isNotEmpty) {
        filledFields++;
      }
    }
    if (filledFields == 0) return errorText;
    return "";
  }
}

class MyEitherOrValidator extends EitherOrValidator {
  final int minLength;

  MyEitherOrValidator({
    this.minLength = 3,
    required String errorText,
    required List<String> fields,
  }) : super(errorText: errorText, fields: fields);

  @override
  String validate() {
    for (var i = 0; i < fields.length; i++) {
      if (fields[i].isNotEmpty) {
        if(fields[i].length < minLength)
          return 'Field should have at least $minLength characters';
        if(fields[i].contains("@")){
          final emailRegExp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
          if(!emailRegExp.hasMatch(fields[i]))
            return 'Invalid email address';
        }
      }
    }
    return errorText;
  }

  bool isValid() {
    final values = fields.map((field) => field).toList();
    if (values.where((val) => val != null && val.toString().length >= minLength).isEmpty) {
      return false;
    }
    return true;
  }
}






class Login extends StatelessWidget {
   Login({super.key});

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
      home: const LoginPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final log = logger(LoginPage);
  final _formKey = GlobalKey<FormState>();
  final usernameEmailController = TextEditingController();
  final bool isParent = Get.arguments;
  final emailController = TextEditingController();

  final emailRegExp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");


  late String _password;
  late VoidCallback moveToParentPage;
  late VoidCallback moveToChildPage;




  @override
  Widget build(BuildContext context) {
    late String username = '';
    late String email = '';

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
            mainAxisAlignment: MainAxisAlignment.start,
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
                          onChanged: (value) {
                            if(!emailRegExp.hasMatch(value??'')) {
                              username = value??'';
                              email = "fj7am8q@gfj7.com";
                            } else {
                              email= value??'';
                              username = 'randy1';
                            }
                          },
                          controller: usernameEmailController,
                          validator: (value) {
                           int minLength =3;
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            else{
                                if(value.length < minLength) {
                                  return 'Field should have at least $minLength characters';
                                }
                                  if(value.contains("@")) {
                                    if (!emailRegExp.hasMatch(value)) {
                                      return 'Invalid email address';
                                    }
                                  }
                            }
                          },
                          decoration:
                              const InputDecoration(labelText: 'Name or Email'),

                        ),
                        box,
                        box,
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Password'),
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
                          child: const Text('Login'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // TODO: if credentials were correct redirect to home and save credentials in local phone storage
                              var data = {
                                "email": email,
                                "name": username,
                                "password": _password,
                              };
                              // Encode the JSON object as a string
                              var body = jsonEncode(data);
                              var url = Uri.parse(
                                  "https://zesty-skate-production.up.railway.app/api/auth");
                              http
                                  .post(url,
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                      },
                                      body: body)
                                  .then((response) {
                                // Process the response

                                Map<String, dynamic> user = jsonDecode(body);
                                if(response.body == 'true'){
                                  log.i("heading towards Splash isParent = $isParent");
                                  log.i("Credentials = $body");
                                    Get.offAllNamed('/splash', arguments: [user,isParent]);

                                }
                                else{
                                  log.e("Wrong Credentials");
                                }

                              }).catchError((error) {
                                // Handle any errors that may have occurred
                                log.i(error);
                              });

                            }
                          },
                        ),
                        box,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            InkWell(
                              child: const Text(" Signup",
                                  style: TextStyle(
                                      fontSize: 15, color: Kolors.kFuchsia)),
                              onTap: () {
                                //TODO: we'll sort out that ting later bruv.
                                if(isParent){
                                  Get.offNamed("/signup_parent");
                                }else{
                                  Get.offNamed("/signup_child");
                                }

                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
