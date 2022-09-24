import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login/model/Image.dart';
import 'package:login/screens/cart_page.dart';
import 'package:http/http.dart' as http;
import 'package:login/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utl/ConstantValue.dart';

class Details extends StatefulWidget {
  var id;
  var name;
  var price;
  var decription;


  Details(this.id, this.name, this.price, this.decription);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailsState(id, name, price, decription);
  }
}

class DetailsState extends State<Details> {
  var id;
  var name;
  var price;
  var decription;

  DetailsState(this.id, this.name, this.price, this.decription);

  List<ImagesModel> ImageList = [

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFFF7941F)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ImageList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 40.0),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 30.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          ImageList[index].image,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }),
            ),
            Text(
              '\$$price',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Varela',
                color: Color(0xFFF7941F),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Color(0xFF575E67),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 50.0,
                  child: Text(
                    decription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFFB4BBB9),
                    ),
                  ),
                ))
          ],
        ),
      ),
      bottomNavigationBar: TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Amazing",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFFB4BBB9),
                    ),
                  ),
                  content: Text(
                    "All Done?",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF575E67),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  actions: [
                    TextButton(
                      onPressed: () {
                        AddToCart(id);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartPage(false)),
                        );
                      },
                      child: Text("View Cart" ,style: TextStyle(color: Color(0xFFF7941F)),),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text("Continue Shopping",style: TextStyle(color:Color(0xFFF7941F)),))
                  ],
                );
              });
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xFFF7941F),
            ),
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text("Add to Cart",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            )),
      ),
    );
  }

  Future getItemImages() async {
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}getItemImages.php"),
        body: {"Id_items": id});

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var images = jsonBody["Images"];
      for (Map i in images) {
        ImageList.add(ImagesModel(i["Id"], i["Image"]));
      }
    }
    setState(() {});
  }

  Future AddToCart(String id) async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(ConstantValue.ID) ?? "";
    if (userId == "") {
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
    final response = await http.post(
        Uri.parse("${ConstantValue.URL}AddToCart.php"),
        body: {
          "Id_items": id,
          "Id_users": userId
        });

    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
    }
  }
}