import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/model/categories.dart';
import 'package:login/model/item.dart';
import 'package:login/screens/items_details_page.dart';
import 'package:http/http.dart' as http;

import '../utl/ConstantValue.dart';

class Items extends StatefulWidget {
  var catId;
  var catName;

  Items(this.catId, this.catName);

  @override
  State<StatefulWidget> createState() {
    return ItemsState(catId, catName);
  }
}

class ItemsState extends State<Items> {
  var catId;
  var catName;

  ItemsState(this.catId, this.catName);

  List<ItemsModel> itemsList = [
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(catName)),
        body: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              var price = itemsList[index].price.toString();
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Details(
                                itemsList[index].id,
                                itemsList[index].name,
                                itemsList[index].price,
                                itemsList[index].description)),
                  );
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        itemsList[index].Image,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                itemsList[index].name,
                                style: TextStyle(
                                    fontSize: 22.0,
                                    color: Color(0xFF2596be),
                                    fontWeight: FontWeight.bold
                                ),
                              )),
                          Text('\$$price',
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0xFF575E67),
                                fontWeight: FontWeight.bold
                            ),)
                        ],
                      ),
                    )
                  ],
                ),
              );
            }));
  }
  Future GetItems() async {
      final response = await http.post(
        Uri.parse("${ConstantValue.URL}GetItems.php"),
        body: {
          "Id_categories":catId
        }
      );
      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body);
        var items = jsonBody['items'];

        for (Map i in items) {
          itemsList.add(ItemsModel(
              i["Id"], i["Name"], i["HomeImage"], i["Price"], i["Des"]
          ));
        }
        setState(() {
        });
      }




  }

}

