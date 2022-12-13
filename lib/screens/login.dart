import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kid_sec/screens/home_page_parent.dart';
import 'package:kid_sec/screens/signup_parent.dart';
import 'package:kid_sec/widgets/image_view.dart';
import '../core/constants/colors/kolors.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                          decoration:
                              const InputDecoration(labelText: 'Name or Email'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a username';
                            }
                          },
                          onSaved: (value) => _username = _email = value!,
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
                          child: Text('Login'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // TODO: if credentials were correct redirect to home and save credentials in local phone storage
                              Get.offNamed('/home');

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
                                  style:
                                  TextStyle(fontSize: 15, color: Kolors.kFuchsia)),
                              onTap: () {
                                //TODO: we'll sort out that ting later bruv.
                                Get.toNamed("/signup_parent");
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
