import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/home.dart';
import 'package:login/screens/main_page.dart';
import 'package:login/screens/signup.dart';
import 'package:http/http.dart' as http;
import 'package:login/utl/ConstantValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool notShowPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: (Image.asset(
            "images/login.png",
            width: 250,
            height: 250,
          ))),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email ",
                        errorText:
                            _validateEmail ? 'Enter a vaild Email' : null,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: password,
                    obscureText: notShowPassword,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            notShowPassword = !notShowPassword;
                            setState(() {});
                          },
                          child: Icon(notShowPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        hintText: "Password ",
                        errorText:
                            _validatePassword ? 'Enter a vaild Password' : null,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 30.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width - 250.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFF2596be),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: TextButton(
                        onPressed: () {
                          if (!isEmail(email.text)) {
                            _validateEmail = true;
                          } else if (!validateStructure(password.text)) {
                            _validatePassword = true;
                          } else {
                            login();
                          }
                          setState(() {});
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF0B47A9)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: Text(
                          "Log In",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: Text("You don't have account? Sign up",
                        style: TextStyle(color: Color(0xFF575E67))),
                  ),
                ],
              ),
            ),
          )
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

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future login() async {
    final response = await http.post(
      Uri.parse("${ConstantValue.URL}login.php"),
      body: {
        'Email': email.text, // parm1
        'Password': password.text, // parm2
      },
    );

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      print("jsonBody  = $jsonBody");

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
            });
      }
    }
  }
}
