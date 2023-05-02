import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class otpvalidate extends StatefulWidget {
  const otpvalidate({super.key});

  @override
  State<otpvalidate> createState() => _otpvalidateState();
}

class _otpvalidateState extends State<otpvalidate> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  Future<void> validateotp(String otp, email) async {
    var response = await http.post(
      Uri.parse('https://bk.tradehit.io/api/validateotp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"otp": otp, "email": email}),
    );

    if (response.statusCode == 200) {
      var data = (jsonDecode(response.body));
      print(otp);
      print(email);

      await Fluttertoast.showToast(
          msg: 'Otp Validate Successfully',
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
        title: Text("Validate Otp"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please enter 6 digit otp";
                  }
                },
                controller: otpController,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(6),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: "000000",
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async {
                  var pref = await SharedPreferences.getInstance();
                  validateotp(
                      otpController.text.toString(), pref.getString("email"));

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
                      "Verify Otp",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Container(
// height: 60,
// width: 60,
// child: TextFormField(
// controller: otpController,
// onChanged: (value) {
// if (value.length == 1) {
// FocusScope.of(context).nextFocus();
// }
// },
// onSaved: (pin1) {},
// style: TextStyle(color: Colors.white),
// keyboardType: TextInputType.number,
// textAlign: TextAlign.center,
// inputFormatters: [
// LengthLimitingTextInputFormatter(1),
// FilteringTextInputFormatter.digitsOnly,
// ],
// decoration: InputDecoration(
// hintText: "0",
// hintStyle: TextStyle(color: Colors.white),
// filled: true,
// fillColor: Colors.black,
// ),
// ),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(5),
// border: Border.all(
// color: Colors.blue,
// )),
// ),
// Container(
// height: 60,
// width: 60,
// child: TextFormField(
// controller: otpController,
// onChanged: (value) {
// if (value.length == 1) {
// FocusScope.of(context).nextFocus();
// }
// },
// onSaved: (pin1) {},
// style: TextStyle(color: Colors.white),
// keyboardType: TextInputType.number,
// textAlign: TextAlign.center,
// inputFormatters: [
// LengthLimitingTextInputFormatter(1),
// FilteringTextInputFormatter.digitsOnly,
// ],
// decoration: InputDecoration(
// hintText: "0",
// hintStyle: TextStyle(color: Colors.white),
// filled: true,
// fillColor: Colors.black,
// ),
// ),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(5),
// border: Border.all(
// color: Colors.blue,
// )),
// ),
// Container(
// height: 60,
// width: 60,
// child: TextFormField(
// controller: otpController,
// onChanged: (value) {
// if (value.length == 1) {
// FocusScope.of(context).nextFocus();
// }
// },
// onSaved: (pin1) {},
// style: TextStyle(color: Colors.white),
// keyboardType: TextInputType.number,
// textAlign: TextAlign.center,
// inputFormatters: [
// LengthLimitingTextInputFormatter(1),
// FilteringTextInputFormatter.digitsOnly,
// ],
// decoration: InputDecoration(
// hintText: "0",
// hintStyle: TextStyle(color: Colors.white),
// filled: true,
// fillColor: Colors.black,
// ),
// ),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(5),
// border: Border.all(
// color: Colors.blue,
// )),
// ),
// Container(
// height: 60,
// width: 60,
// child: TextFormField(
// controller: otpController,
// onChanged: (value) {
// if (value.length == 1) {
// FocusScope.of(context).nextFocus();
// }
// },
// onSaved: (pin1) {},
// style: TextStyle(color: Colors.white),
// keyboardType: TextInputType.number,
// textAlign: TextAlign.center,
// inputFormatters: [
// LengthLimitingTextInputFormatter(1),
// FilteringTextInputFormatter.digitsOnly,
// ],
// decoration: InputDecoration(
// hintText: "0",
// hintStyle: TextStyle(color: Colors.white),
// filled: true,
// fillColor: Colors.black,
// ),
// ),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(5),
// border: Border.all(
// color: Colors.blue,
// )),
// ),
// Container(
// height: 60,
// width: 60,
// child: TextFormField(
// controller: otpController,
// onChanged: (value) {
// if (value.length == 1) {
// FocusScope.of(context).nextFocus();
// }
// },
// onSaved: (pin1) {},
// style: TextStyle(color: Colors.white),
// keyboardType: TextInputType.number,
// textAlign: TextAlign.center,
// inputFormatters: [
// LengthLimitingTextInputFormatter(1),
// FilteringTextInputFormatter.digitsOnly,
// ],
// decoration: InputDecoration(
// hintText: "0",
// hintStyle: TextStyle(color: Colors.white),
// filled: true,
// fillColor: Colors.black,
// ),
// ),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(5),
// border: Border.all(
// color: Colors.blue,
// )),
// ),
// Container(
// height: 60,
// width: 60,
// child: TextFormField(
// controller: otpController,
// onChanged: (value) {
// if (value.length == 1) {
// FocusScope.of(context).nextFocus();
// }
// },
// onSaved: (pin1) {},
// style: TextStyle(color: Colors.white),
// keyboardType: TextInputType.number,
// textAlign: TextAlign.center,
// inputFormatters: [
// LengthLimitingTextInputFormatter(1),
// FilteringTextInputFormatter.digitsOnly,
// ],
// decoration: InputDecoration(
// hintText: "0",
// hintStyle: TextStyle(color: Colors.white),
// filled: true,
// fillColor: Colors.black,
// ),
// ),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(5),
// border: Border.all(
// color: Colors.blue,
// )),
// ),
// ],
// ),
//
//
//
