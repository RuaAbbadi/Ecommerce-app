import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/login.dart';
import 'package:login/screens/order_page.dart';
import 'package:login/utl/ConstantValue.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/order.dart';

class OrdersPage extends StatefulWidget {
  var orderId;

  OrdersPage(this.orderId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrdersPageState(orderId);
  }
}

class OrdersPageState extends State<OrdersPage> {
  var orderId;

  OrdersPageState(this.orderId);

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
                      var price = orderList[index].price.toString();
                      var itemsCount= orderList[index].count.toString();
                      var totalPrice= orderList[index].totalprice.toString();

                      return Container(
                          height: 130,
                          margin:
                          EdgeInsets.symmetric(vertical: 10,horizontal: 15),
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
                          child: Row(
                            children: [
                              Container(
                                height: 130,
                                width: 130,
                                margin: EdgeInsets.only(right: 15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    orderList[index].image,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orderList[index].name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2596be),
                                      ),
                                    ),
                                    Text(
                                      '\$$price',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF575E67),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding:EdgeInsets.symmetric(vertical: 5),
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Amount: $itemsCount',
                                      style: TextStyle(
                                          color:Color(0xFF2596be),
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ) ,
                              ),
                            ],
                          )
                      );
                    }
                )
            ),
          ],
        ),
        bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xFF2596be),
            ),
            margin: EdgeInsets.symmetric(horizontal: 23.0, vertical: 10.0),
            child: TextButton(
              onPressed: () async{
                deleteOrders();
                deleteOrder();
                Navigator.pop(context,'refresh');
                Navigator.pop(context,'refresh');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>MyOrderPage()),
                );
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ))
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
        body: {
          "Id_orders":orderId,
          "Id_users": userId
        });

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var order = jsonBody['order'];

      for (Map i in order) {
        orderList.add(
            Order(i["Id"], i["Name"], i["Price"], i["HomeImage"], i["count"],["TotalPrice"]));
      }
      setState(() {});
    }
  }
  Future deleteOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    if (userId == "") {
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}deleteOrders.php"),
        body: {
          "Id_orders":orderId,
          "Id_users": userId

        });
    if (response.statusCode == 200) {
      print(orderId);
      return (jsonDecode(response.body));


    }
  }
  Future deleteOrder() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    if (userId == "") {
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}deleteOrder.php"),
        body: {
          "Id":orderId,
          "Id_users": userId

        });
    if (response.statusCode == 200) {
      return (jsonDecode(response.body));

    }
  }
}