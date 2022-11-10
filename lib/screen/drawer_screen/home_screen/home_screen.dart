// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable, must_be_immutable
import 'dart:convert';
import 'package:barg_store_app/screen/drawer_screen/home_screen/show_bid_slip.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:barg_store_app/screen/drawer_screen/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback openDrawer;

  HomeScreen({required this.openDrawer});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? store_id;
  List requestList = [];
  List orderList = [];
  bool show = false;
  String? order_id;
  String? slip_img;
  String? request_id;
  int sum_price = 0;

  get_request() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString('store_id');
    });
    final response = await http.get(Uri.parse("$ipcon/get_request/$store_id"));
    var data = json.decode(response.body);
    setState(() {
      requestList = data;
    });
  }

  get_order(String? _request_id, String? _order_id, String? _slip_img) async {
    final response = await http.get(Uri.parse("$ipcon/get_order/$_order_id"));
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        request_id = _request_id;
        orderList = data;
        order_id = _order_id;
        slip_img = _slip_img;
        sum_price = 0;
      });
      for (var i = 0; i < orderList.length; i++) {
        if (orderList[i]['price'] != null) {
          sum_price = sum_price + int.parse(orderList[i]['price']);
        }
      }

      buildShow();
    }
  }

  update_request() async {
    final response = await http.post(
      Uri.parse('$ipcon/update_request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "request_id": request_id.toString(),
        "status": "2",
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    get_request();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Order",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom:
            PreferredSize(preferredSize: Size.fromHeight(7), child: SizedBox()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        centerTitle: true,
        leading: DrawerMenuWidget(
          onClicked: () {
            widget.openDrawer();
          },
        ),
        backgroundColor: Color(0xFF73AEF5),
      ),
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: height * 0.01),
                buildListRequest(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListRequest() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: get_request(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Expanded(
          child: ListView.builder(
            itemCount: requestList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  await get_order(
                    requestList[index]['request_id'].toString(),
                    requestList[index]['order_id'],
                    requestList[index]['slip_img'],
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.035, vertical: height * 0.005),
                  width: width,
                  height: height * 0.07,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: Offset(3, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.015, horizontal: width * 0.07),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoText(
                              width: width * 0.15,
                              text: "order id",
                              fontSize: 14,
                              color: Colors.black,
                              text_align: TextAlign.left,
                              fontWeight: null,
                            ),
                            AutoText(
                              width: width * 0.4,
                              text: requestList[index]['order_id'],
                              fontSize: 14,
                              color: Colors.black,
                              text_align: TextAlign.right,
                              fontWeight: null,
                            ),
                          ],
                        ),
                      ),
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

  buildShow() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(11),
          margin: EdgeInsets.symmetric(
              vertical: height * 0.05, horizontal: width * 0.04),
          width: width,
          height: height * 0.5,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "assets/images/cancel.png",
                        width: width * 0.1,
                        height: height * 0.05,
                        color: Colors.black54,
                      ),
                    )
                  ],
                ),
              ),
              AutoText(
                width: width * 0.4,
                text: "  Order details",
                fontSize: 20,
                color: Colors.black,
                text_align: TextAlign.left,
                fontWeight: FontWeight.bold,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: height * 0.02, horizontal: width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoText(
                      width: width * 0.3,
                      text: "order id",
                      fontSize: 16,
                      color: Colors.black,
                      text_align: TextAlign.left,
                      fontWeight: FontWeight.w500,
                    ),
                    AutoText(
                      width: width * 0.4,
                      text: "$order_id",
                      fontSize: 16,
                      color: Colors.black,
                      text_align: TextAlign.right,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Container(
                height: height * 0.2,
                child: ListView.builder(
                  itemCount: orderList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              AutoText2(
                                width: width * 0.6,
                                text: "${orderList[index]['food_name']}",
                                fontSize: 16,
                                color: Colors.black,
                                text_align: TextAlign.left,
                                fontWeight: null,
                              ),
                              AutoText2(
                                width: width * 0.6,
                                text: "${orderList[index]['detail']}",
                                fontSize: 16,
                                color: Colors.grey,
                                text_align: TextAlign.left,
                                fontWeight: null,
                              ),
                            ],
                          ),
                          AutoText(
                            width: width * 0.1,
                            text: "${orderList[index]['amount']}",
                            fontSize: 16,
                            color: Colors.black,
                            text_align: TextAlign.right,
                            fontWeight: null,
                          ),
                          AutoText(
                            width: width * 0.1,
                            text: "${orderList[index]['price']}",
                            fontSize: 16,
                            color: Colors.black,
                            text_align: TextAlign.right,
                            fontWeight: null,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03, vertical: height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoText2(
                          width: width * 0.6,
                          text: "Total",
                          fontSize: 20,
                          color: Colors.black,
                          text_align: TextAlign.left,
                          fontWeight: FontWeight.bold,
                        ),
                        AutoText(
                          width: width * 0.1,
                          text: "$sum_price",
                          fontSize: 20,
                          color: Colors.black,
                          text_align: TextAlign.right,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return showBigSlip(img: slip_img);
                      }));
                    },
                    child: Container(
                        width: double.infinity,
                        height: height * 0.2,
                        child: Image.network(
                          "$path_img/slip/$slip_img",
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
              Container(
                width: width,
                height: height * 0.07,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildButton('Confirm', Colors.green, 0.38),
                        buildButton('Cancel', Colors.red, 0.38),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildButton(String? text, Color color, double width2) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.02),
      width: width * width2,
      height: height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          if (text == "Confirm") {
            update_request();
          } else {
            Navigator.pop(context);
          }
        },
        child: AutoText(
          color: Colors.white,
          fontSize: 16,
          text: '$text',
          text_align: TextAlign.center,
          width: width * 0.29,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
