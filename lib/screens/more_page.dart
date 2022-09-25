import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/login.dart';
import 'package:login/screens/main_page.dart';
import 'package:login/screens/order_details_page.dart';
import 'package:login/screens/order_page.dart';
import 'package:login/screens/profile.dart';
import 'package:login/screens/splash.dart';
import 'package:http/http.dart' as http;
import 'package:login/utl/ConstantValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MoreScreenState();
  }
}

class MoreScreenState extends State<MoreScreen> {
  String Id="";
  String name ="";
  String email ="";
  String phone="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                          ),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                        '$name',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF575E67)),
                      ),

                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "$email",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            color: Colors.grey.withOpacity(0.8),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextButton(
                      onPressed: ()async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage(Id,name,email,phone)),
                        );
                        setState(() {});
                      },
                      child: Text(
                        "Profile",
                        style:
                        TextStyle(fontSize: 20, color: Color(0xFF575E67)),
                      )),
                ),
                TextButton(
                    onPressed: ()async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyOrderPage()),
                      );
                    },
                    child: Text("Orders",
                        style:
                        TextStyle(fontSize: 20, color: Color(0xFF575E67)))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 25, right: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width-50,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFF0B47A9),
                    ),
                    margin: EdgeInsets.symmetric( vertical: 20.0),
                    child: TextButton(
                        onPressed: () {
                          IsLogedOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Splash()));
                        },
                        child: Text("Logout", style: TextStyle(color: Colors.white))))
              ],
            ),
          )
        ],
      ),
    );
  }

  IsLogedOut() async {
    final prefs = await SharedPreferences.getInstance();
    final Id = await prefs.remove(ConstantValue.ID);
    final Email = await prefs.remove(ConstantValue.Email);
    final Name = await prefs.remove(ConstantValue.Name);
    final Phone = await prefs.remove(ConstantValue.Phone);

    if (Id == "" && Email == ""  && Name == "" && Phone == "") {
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Splash())));
    }
  }

  Future GetUser() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    String userName = prefs.getString(ConstantValue.Name) ?? "";
    String userEmail = prefs.getString(ConstantValue.Email) ?? "";
    String userPhone= prefs.getString(ConstantValue.Phone) ?? "";
    setState(() {
      Id=userId;
      name = userName;
      email=userEmail;
      phone=userPhone;

    });

  }
}