import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradebit/forgotpassword.dart';
import 'package:tradebit/otpvalidate.dart';
import 'package:tradebit/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    bool ready = await GRecaptchaV3.ready(
        "6LeQjq8kAAAAAOZngqRBk0d4SufpdxzmdwKr3iqS",
        showBadge: true); //--2
    // ignore: avoid_print
    print("Is Recaptcha ready? $ready");
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: loginpage(),
  ));
}

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final _formKey = GlobalKey<FormState>();
  String? Email;
  String? Password;

  var _token;
  var loginType = "email";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController tokenController = TextEditingController();
  bool badgeVisible = true;

  getToken() async {
    String Token = await GRecaptchaV3.execute('submit') ?? 'null returned';

    setState(() {
      _token = Token;
    });
    // print(_token);
  }

  // get value using shared preference
  void initState() {
    super.initState();
    getdata();
  }

//get the data using shared preference of login
  getdata() async {
    var pref = await SharedPreferences.getInstance();
    var email = pref.getString("email");
    var password = pref.getString("password");
    var Token = pref.getString(_token);
  }

//Login Api
  Future<void> login(String email, password) async {
    await getToken();
    var response = await http.post(
      Uri.parse('https://bk.tradehit.io/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "password": password,
        "captcha_response": _token,
        "loginType": loginType
      }),
    );
    var data = (jsonDecode(response.body));
    if (response.statusCode == 200) {
      print(data);
      print(email);
    }
    await Fluttertoast.showToast(
        msg: 'Login Sucessfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.yellow);
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => otpvalidate()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("Login Page", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Email";
                      } else if (!value.contains("@")) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    controller: emailController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue)),
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Email"),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter password";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    controller: passwordController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue)),
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Password"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),

            //Recaptcha
            // Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       SelectableText(
            //         'Token: $_token\n',
            //         style: TextStyle(color: Colors.green),
            //       ),
            //       ElevatedButton(
            //         onPressed: getToken,
            //         child: const Text('Get new token'),
            //       ),
            //     ],
            //   ),
            // ),

            GestureDetector(
              onTap: () async {
                login(
                  emailController.text.toString(),
                  passwordController.text.toString(),
                  // tokenController.text.toString());
                );

                //sharedpreference
                var prefs = await SharedPreferences.getInstance();
                prefs.setString("email", emailController.text.toString());
                prefs.setString("password", passwordController.text.toString());
                prefs.setString(
                    "captcha_response", tokenController.text.toString());

                setState(() {
                  Email = emailController.text.toString();
                  Password = passwordController.text.toString();
                  _token = tokenController.text.toString();
                });
                //validate condition
                if (_formKey.currentState!.validate()) {}
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),

            //Navigate signup page
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Myapp()));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                height: 50,
                child: Center(
                  child: Text(
                    "SignUp",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
