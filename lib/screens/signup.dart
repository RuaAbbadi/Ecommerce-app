import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:login/screens/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:login/utl/ConstantValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupState();
  }
}

class SignupState extends State<Signup> {
  final email = TextEditingController();
  final name = TextEditingController();
  final password = TextEditingController();
  final confpassword = TextEditingController();
  final phone = TextEditingController();
  bool notShowPassword=true;

  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _validateName = false;

  bool _validatePhone = false;
  bool _validateConPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: (Image.asset(
            "images/login.png",
            width: 200,
            height: 200,
          ))),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: "Enter Your Name ",
                        errorText: _validateName ? 'Enter a vaild Name' : null,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Enter Your Email ",
                        errorText:
                            _validateEmail ? 'Enter a vaild Email' : null,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: phone,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Enter Your Phone ",
                        errorText:
                            _validatePhone ? 'Enter a vaild Phone' : null,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: password,
                    obscureText: notShowPassword,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            notShowPassword=!notShowPassword;
                            setState(() {
                            });
                          },
                          child: Icon(notShowPassword? Icons.visibility:Icons.visibility_off),
                        ),
                        hintText: "Enter Password ",
                        errorText:
                            _validatePassword ? 'Enter Your Password' : null,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: confpassword,
                    obscureText: notShowPassword,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.check),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            notShowPassword=!notShowPassword;
                            setState(() {
                            });
                          },
                          child: Icon(notShowPassword? Icons.visibility:Icons.visibility_off),
                        ),
                        hintText: "Enter Password ",
                        errorText:
                            _validateConPassword ? 'Confirm Password' : null,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: TextButton(
                        onPressed: () {
                          _validateName=false;
                          _validateEmail=false;
                          _validatePhone=false;
                          _validatePassword=false;
                          _validateConPassword=false;

                          if (name.text.isEmpty) {
                            _validateName = true;
                          } else if (!isEmail(email.text)) {
                            _validateEmail = true;
                          } else if (phone.text.isEmpty) {
                            _validatePhone = true;
                          } else if (!validatePassword(
                              password.text)) {
                            _validatePassword = true;
                          } else if (password.text !=
                              confpassword.text) {
                            _validateConPassword = true;
                          }
                          else {
                            signup();
                          }
                          setState(() {});
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF2596be)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        )),
                    width: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future signup() async {
    final response = await http.post(
      Uri.parse("${ConstantValue.URL}SignUp.php"),
      body: {
        'Email': email.text, // parm1
        'Password': password.text, // parm2
        'Name': name.text, // parm2
        'Phone':phone.text,

      },
    );

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);

      var result = jsonBody['result']; // get data from json
      if (result) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(ConstantValue.ID, jsonBody["Id"]);
        await prefs.setString(ConstantValue.Name, jsonBody["Name"]);
        await prefs.setString(ConstantValue.Email, jsonBody['Email']);
        await prefs.setString(ConstantValue.Phone, jsonBody['Phone']);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Warning"),
                content: Text(jsonBody['msg']),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  )
                ],
              );
            }
        );
      }
    }
    }
}
