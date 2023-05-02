import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: SignUp(),
  ));
}

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Myapp());
  }
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  final _formKey = GlobalKey<FormState>();

  String terms = "1";
  bool agree = false;

  //Conttoller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirm_passwordController = TextEditingController();

// get value using shared preference
  void initState() {
    super.initState();
    getvalue();
  }

//get the data using shared preference of register
  getvalue() async {
    var prefs = await SharedPreferences.getInstance();

    var email = prefs.getString("email");

    var password = prefs.getString("password");
  }

//Register Api
  Future<void> register(
      String name, email, password, confirm_password, terms) async {
    var response = await http.post(
      Uri.parse('https://bk.tradehit.io/api/register/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "name": name,
        "email": email,
        "password": password,
        "confirm_password": confirm_password,
        "terms": terms,
      }),
    );

    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      print(data);
      print("name:$name");
      print("email:$email");
      print("password:$password");
      print("confirmpassword:$confirm_password");
      print("terms:$terms");

      await Fluttertoast.showToast(
          msg: 'Registered Successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.yellow);
    } else {
      await Fluttertoast.showToast(
          msg: 'Something Went Wrong',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.yellow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("Register Page", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter UserName";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    controller: nameController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue)),
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Name"),
                  ),

                  //Email Field
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Email";
                      } // else if (!value.contains("@")) {
                      //   return "Please enter valid email";
                      // }
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

                  //password
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
                  SizedBox(height: 10),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Confirm Password";
                      } else if (value != passwordController.text) {
                        return "Confirm password is not matched.";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    controller: confirm_passwordController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.blue)),
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: "Confirm Password"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),

            Row(
              children: [
                Material(
                  child: Checkbox(
                    value: agree,
                    onChanged: (value) {
                      setState(() {
                        agree = value ?? false;
                      });
                    },
                  ),
                ),
                const Text('I have read and accept terms and conditions',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white))
              ],
            ),
            SizedBox(
              height: 20,
            ),
            //Registerationbutton
            GestureDetector(
                onTap: () async {
                  register(
                    nameController.text.toString(),
                    emailController.text.toString(),
                    passwordController.text.toString(),
                    confirm_passwordController.text.toString(),
                    terms,
                  );

                  //sharedpreference
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setString(
                    "email",
                    emailController.text.toString(),
                  );
                  prefs.setString(
                      "password", passwordController.text.toString());

                  //validate condition

                  if (_formKey.currentState!.validate()) {
                    if (confirm_passwordController.text ==
                        passwordController.text) {}
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  height: 50,
                  child: Center(
                    child: Text("Register",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

//
//
// resendOtp("email");
// var pref = await SharedPreferences.getInstance();
// var email = pref.getString("email");
