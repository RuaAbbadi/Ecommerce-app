import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login/screens/login.dart';
import 'package:login/screens/more_page.dart';
import 'package:login/utl/ConstantValue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  bool _validateEmail = false;
  bool _validateName = false;
  bool _validatePhone = false;

  bool showPassword = false;
  String name = "";
  String email = "";
  String phone = "";
  String Id="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"))),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "$name",
                    errorText: _validateName ? 'Enter a vaild Name' : null,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: '$email',
                    errorText:
                    _validateEmail ? 'Enter a vaild Email' : null,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1))),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    hintText: '$phone',
                    errorText:
                    _validatePhone ? 'Enter a vaild Phone' : null,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1))),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ) {
                           _validateName = true;
                       }else if (!isEmail(emailController.text)) {
                          _validateEmail = true;
                        } else if (phoneController.text.isEmpty) {
                           _validatePhone = true;
                           }
                        else {
                          UpdateProfile(Id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()),
                          );
                        }
                        setState(() {
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF2596be)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),

                          ),
                        ),
                      ),
                      child: Text(
                        "SAVE", style: TextStyle(color: Colors.white),
                      )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future GetUser() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    String userName = prefs.getString(ConstantValue.Name) ?? "";
    String userEmail = prefs.getString(ConstantValue.Email) ?? "";
    String userPhone = prefs.getString(ConstantValue.Phone) ?? "";

    setState(() {
      name = userName;
      email = userEmail;
      phone = userPhone;
      Id=userId;
    });
  }
  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  Future UpdateProfile(String Id) async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    if (userId == "") {
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) =>Login())));
    }
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}UpdateProfile.php"),
        body: {
          "Id":Id,
          "Name":nameController.text,
          "Email":emailController.text,
          "Phone":phoneController.text
        });

    if (response.statusCode == 200) {
      return (jsonDecode(response.body));

    }
  }
}