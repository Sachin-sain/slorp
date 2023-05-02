import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class forgotpassword extends StatefulWidget {
  const forgotpassword({super.key});

  @override
  State<forgotpassword> createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  @override
  Future<void> Forgotpassword(
    String email,
  ) async {
    var response = await http.post(
      Uri.parse('https://bk.tradehit.io/api/forgotpassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      print("hello");
      print(data);

      print(email);

      await Fluttertoast.showToast(
          msg: 'Forgot Password Successfully',
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

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "forgotpassword",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: GestureDetector(
        onTap: () async {
          var pref = await SharedPreferences.getInstance();
          var email_ = pref.getString("email");
          Forgotpassword(email_!);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(10)),
          height: 50,
          child: Center(
            child: Text(
              "forgotpassword",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
