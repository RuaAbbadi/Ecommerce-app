import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/login.dart';
import 'package:login/utl/ConstantValue.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/order.dart';

class OrdersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrdersPageState();
  }
}

class OrdersPageState extends State<OrdersPage> {
  List<Order> orderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetOrders();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 250,
              child: ListView.builder(
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    return Container(
                        height: 130,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                        ),
                        );
                  }),
            ),
          ],
        ),
      );
  }

  Future GetOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    if (userId == "") {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}GetOrders.php"),
        body: {"Id_users": userId});

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var order = jsonBody['order'];

      for (Map i in order) {
        orderList.add(
            Order(i["Id"], i["Name"], i["Price"], i["HomeImage"], i["TotalPrice"],["count"]));
      }
      setState(() {});
    }
  }
}
