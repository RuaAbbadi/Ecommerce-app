import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/model/myoder.dart';
import 'package:login/screens/login.dart';
import 'package:login/screens/order_details_page.dart';
import 'package:login/utl/ConstantValue.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/order.dart';

class MyOrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyOrderPageState();
  }
}

class MyOrderPageState extends State<MyOrderPage> {
  List<MyOrder> ordersList = [];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetOrder();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF7941F),
      ),
      body: SingleChildScrollView(
        child:Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: ordersList.length,
                  itemBuilder: (context, index) {
                    var orderNumber= ordersList[index].Id;
                    var totalPrice=ordersList[index].totalprice;
                    return
                      Container(
                        height: 130,
                        margin:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        padding: EdgeInsets.symmetric(vertical: 15),
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
                        child:  Padding(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 60),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '#$orderNumber',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    ordersList[index].name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFF7941F),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Total Price : \$$totalPrice',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  TextButton(
                                      onPressed: ()async{
                                    String refresh= await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => OrdersPage(ordersList[index].Id)),
                                        );
                                    if(refresh=='refresh'){
                                      GetOrder();
                                    }
                                      },
                                      child:Text("More Details",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),)
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                  }),
            ),
          ],
        ),
      )
    );
  }

  Future GetOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    if (userId == "") {
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}GetOrder.php"),
        body: {"Id_users": userId});

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var order = jsonBody['order'];

      for (Map i in order) {
        ordersList.add(
            MyOrder(i["Id"], i["Name"], i["TotalPrice"]));
      }
      setState(() {});
    }
  }

}
