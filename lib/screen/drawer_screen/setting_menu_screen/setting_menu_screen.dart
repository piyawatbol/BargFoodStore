import 'dart:convert';
import 'package:barg_store_app/screen/drawer_screen/setting_menu_screen/add_menu_screen.dart';
import 'package:barg_store_app/screen/drawer_screen/setting_menu_screen/edit_menu_screen.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/back_button.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class SettingMenuScreen extends StatefulWidget {
  SettingMenuScreen({Key? key}) : super(key: key);

  @override
  State<SettingMenuScreen> createState() => _SettingMenuScreenState();
}

class _SettingMenuScreenState extends State<SettingMenuScreen> {
  String? store_id;
  List foodList = [];

  get_menu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString('store_id');
    });
    final response = await http.get(Uri.parse("$ipcon/get_menu/$store_id"));
    var data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        foodList = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF73AEF5),
              Color(0xFF61A4F1),
              Color(0xFF478De0),
              Color(0xFF398AE5)
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              BackArrowButton(text: "Menu", width2: 0.14),
              buildMenu()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        hoverElevation: 50,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddMenuScreen();
          }));
        },
      ),
    );
  }

  Widget buildMenu() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: get_menu(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return foodList.isEmpty
            ? Expanded(
                child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return BuildLoading();
                },
              ))
            : foodList[0]['food_id'] == null
                ? Container()
                : Expanded(
                    child: ListView.builder(
                      itemCount: foodList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return EditMenuScreen(
                                food_id: foodList[index]['food_id'].toString(),
                                img: foodList[index]['food_image'],
                                food_name: foodList[index]['food_name'],
                                price: foodList[index]['price'],
                                detail: foodList[index]['detail'],
                                status: foodList[index]['food_status'],
                              );
                            }));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: width * 0.07,
                                vertical: height * 0.005),
                            padding: EdgeInsets.all(10),
                            height: height * 0.13,
                            decoration: BoxDecoration(
                              color: foodList[index]['food_status'] == 1
                                  ? Colors.white
                                  : Colors.white38,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 2,
                                  blurRadius: 1,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: width * 0.35,
                                  height: height * 0.15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter:
                                          foodList[index]['food_status'] == 1
                                              ? null
                                              : new ColorFilter.mode(
                                                  Colors.black.withOpacity(0.5),
                                                  BlendMode.dstATop),
                                      image: new NetworkImage(
                                        '$path_img/food/${foodList[index]['food_image']}',
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.44,
                                  height: height * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.05,
                                        vertical: height * 0.002),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoText3(
                                          width: width * 0.5,
                                          text:
                                              "${foodList[index]['food_name']}",
                                          fontSize: 16,
                                          color: foodList[index]
                                                      ['food_status'] ==
                                                  1
                                              ? Colors.black
                                              : Colors.black38,
                                          text_align: TextAlign.left,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        AutoText3(
                                          width: width * 0.5,
                                          text: "${foodList[index]['detail']}",
                                          fontSize: 14,
                                          color: Colors.grey,
                                          text_align: TextAlign.left,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        AutoText3(
                                          width: width * 0.5,
                                          text: "฿ ${foodList[index]['price']}",
                                          fontSize: 15,
                                          color: Colors.green,
                                          text_align: TextAlign.left,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
      },
    );
  }

  Widget BuildLoading() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.07, vertical: height * 0.005),
      height: height * 0.13,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.white70,
              highlightColor: Colors.white10,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black38,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.002),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.white70,
                      highlightColor: Colors.white10,
                      child: Container(
                        width: width * 0.25,
                        height: height * 0.023,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.white70,
                      highlightColor: Colors.white10,
                      child: Container(
                        width: width * 0.2,
                        height: height * 0.023,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.white70,
                      highlightColor: Colors.white10,
                      child: Container(
                        width: width * 0.12,
                        height: height * 0.023,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
