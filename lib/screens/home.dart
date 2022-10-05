import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/model/Image.dart';
import 'package:login/model/categories.dart';
import 'package:login/screens/items_page.dart';
import 'package:http/http.dart' as http;

import '../utl/ConstantValue.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {

  List<Categories> catList = [

  ];

  List<ImagesModel> ImageList = [

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetGategories();
    GetBannerImages();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          body: Column(
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .25,
                child: ListView.builder(
                    itemCount: ImageList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            padding: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                ConstantValue.URL+ ImageList[index].image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30, left: 20.0, right: 20.0),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 15.0,
                        ),
                        itemCount: catList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Items(catList[index].id,
                                              catList[index].name)),
                                );
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                     ConstantValue.URL+ catList[index].image,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      catList[index].name,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    margin: EdgeInsets.only(top: 10.0),
                                  )
                                ],
                              ));
                        }),
                  )),
            ],
          ));

  }

  Future GetGategories() async {
    final response = await http.post(
      Uri.parse("${ConstantValue.URL}GetCategories.php"),
    );
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var categories = jsonBody['categories'];

      for(Map i in categories){
        catList.add(Categories(i["Id"], i["Name"], i["Image"]));
      }
      setState(() {

      });

    }
  }
  Future GetBannerImages() async {
    final response = await http.post(
      Uri.parse("${ConstantValue.URL}GetBannerImages.php"),
    );
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      var images = jsonBody['images'];

      for(Map i in images){
        ImageList.add(ImagesModel(i["Id"], i["Image"]));
      }
      setState(() {

      });
    }
  }

}