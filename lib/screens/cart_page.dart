import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/model/cart.dart';
import 'package:http/http.dart' as http;
import 'package:login/screens/login.dart';
import 'package:login/screens/map_page.dart';
import 'package:login/utl/ConstantValue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  var fromMain;

  CartPage(this.fromMain);

  @override
  State<StatefulWidget> createState() {
    return CartPageState(fromMain);
  }
}

class CartPageState extends State<CartPage> {
  var fromMain;
  double totalPrice = 0;

  CartPageState(this.fromMain);

  List<CartModel> cartList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetCart();
  }

  @override
  Widget build(BuildContext context) {
    totalPrice = 0;
    for (int x = 0; x < cartList.length; x++) {
      totalPrice = totalPrice + (cartList[x].price * cartList[x].count);
    }
    return Scaffold(
        appBar: fromMain ? null : AppBar(backgroundColor: Color(0xFF0B47A9)),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: fromMain
                  ? MediaQuery.of(context).size.height - 250
                  : MediaQuery.of(context).size.height - 200,
              child: ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (context, index) {
                    var price = cartList[index].price.toString();
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
                        child: Row(
                          children: [
                            Container(
                              height: 130,
                              width: 130,
                              margin: EdgeInsets.only(right: 15),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  cartList[index].image,
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
                                    cartList[index].name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF575E67),
                                    ),
                                  ),
                                  Text(
                                    '\$$price',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFB4BBB9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      deleteCart(cartList[index].id);
                                      cartList.removeAt(index);
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.grey,
                                    iconSize: 25,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 5)
                                              ]),
                                          child: IconButton(
                                            onPressed: () {
                                              cartList[index].count =
                                                  cartList[index].count + 1;
                                              UpdateCart(
                                                  cartList[index]
                                                      .count
                                                      .toString(),
                                                  cartList[index].id);
                                              setState(() {});
                                            },
                                            icon: Icon(CupertinoIcons.plus),
                                            iconSize: 17,
                                          )),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            cartList[index].count.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          )),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 5)
                                              ]),
                                          child: IconButton(
                                            onPressed: () {
                                              if (cartList[index].count != 1) {
                                                cartList[index].count =
                                                    cartList[index].count - 1;
                                                UpdateCart(
                                                    cartList[index]
                                                        .count
                                                        .toString(),
                                                    cartList[index].id);
                                              } else {
                                                deleteCart(cartList[index].id);
                                                cartList.removeAt(index);
                                              }
                                              setState(() {});
                                            },
                                            icon: Icon(CupertinoIcons.minus),
                                            iconSize: 17,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ));
                  }),
            ),
            Container(
              margin: EdgeInsets.all(15.0),
              child: Row(children: [
                Text("Total Price",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                Text('$totalPrice',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF575E67)))
              ], mainAxisAlignment: MainAxisAlignment.spaceAround),
            ),
          ],
        ),
        bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xFF0B47A9),
            ),
            margin: EdgeInsets.symmetric(horizontal: 23.0, vertical: 10.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapScreen(totalPrice)),
                );
              },
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
            )));
  }

  Future GetCart() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    if (userId == "") {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}GetCart.php"),
        body: {"Id_users": userId});

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var cart = jsonBody['cart'];

      for (Map i in cart) {
        cartList.add(CartModel(
            i["Id"], i["Name"], i["HomeImage"], i["count"], i["Price"]));
      }
      setState(() {});
    }
  }

  Future deleteCart(String id) async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    if (userId == "") {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}deleteCart.php"),
        body: {"Id": id, "Id_users": userId});
    if (response.statusCode == 200) {
      return (jsonDecode(response.body));
    }
  }

  Future UpdateCart(String Count, String Id) async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    if (userId == "") {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}UpdateCart.php"),
        body: {"Count": Count, "Id": Id, "Id_users": userId});

    if (response.statusCode == 200) {
      return (jsonDecode(response.body));
    }
  }
}
