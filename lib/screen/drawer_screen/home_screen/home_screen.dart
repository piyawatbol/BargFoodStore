// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable, must_be_immutable
import 'dart:convert';
import 'package:barg_store_app/screen/drawer_screen/home_screen/cancel_order_screen.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/color.dart';
import 'package:barg_store_app/widget/loadingPage.dart';
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
  List order_List = [];
  bool show = false;
  String? request_id;
  bool statusLoading = false;

  get_request() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString('store_id');
    });
    final response =
        await http.get(Uri.parse("$ipcon/get_request/$store_id/1"));
    var data = json.decode(response.body);
    setState(() {
      requestList = data;
    });
  }

  get_order(String? _request_id, String? _order_id, String? _slip_img,
      String? _time) async {
    final response = await http.get(Uri.parse("$ipcon/get_order/$_order_id"));
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        orderList = data;
        request_id = _request_id;
      });
      setState(() {
        statusLoading = false;
      });
      buildShow(
          _request_id,
          _order_id,
          _slip_img,
          _time,
          '${requestList[0]['sum_price']}',
          '${requestList[0]['delivery_fee']}',
          '${requestList[0]['total']}');
    }
  }

  get_sum_amout_price(String? _order_id, index) async {
    final response = await http.get(Uri.parse("$ipcon/get_order/$_order_id"));
    var data = json.decode(response.body);
    setState(() {
      order_List = data;
    });
  }

  update_request() async {
    final response = await http.post(
      Uri.parse('$ipcon/update_request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "request_id": request_id.toString(),
        "status": "3",
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
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
        title: AutoText(
          text: "ORDER",
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
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
        backgroundColor: blue,
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
            LoadingPage(statusLoading: statusLoading)
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
                  setState(() {
                    statusLoading = true;
                  });
                  await get_order(
                    requestList[index]['request_id'].toString(),
                    requestList[index]['order_id'],
                    requestList[index]['slip_img'],
                    requestList[index]['time'],
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.035, vertical: height * 0.005),
                  width: width,
                  height: height * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.005),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoText(
                              text: requestList[index]['order_id'],
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: null,
                            ),
                            AutoText(
                              text: requestList[index]['time'],
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              fontWeight: null,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.005),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoText(
                              text: "Food Price",
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            AutoText(
                              text: '${requestList[index]['sum_price']}฿',
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.005),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoText(
                              text: "Delivery fee",
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            AutoText(
                              text: '${requestList[index]['delivery_fee']}฿',
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.005),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoText(
                              text: "Total ",
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            AutoText(
                              text: '${requestList[index]['total']}฿',
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
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

  buildShow(
    String? _request_id,
    String? _order_id,
    String? _slip_img,
    String? _time,
    String? sum_price,
    String? delivery_fee,
    String? total,
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(11),
            margin: EdgeInsets.symmetric(
                vertical: height * 0.05, horizontal: width * 0.04),
            width: width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      text: "Order details",
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.02, horizontal: width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoText(
                            text: "$_order_id",
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          AutoText(
                            text: "$_time",
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.26,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: orderList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // color: Colors.red,
                                      width: width * 0.55,
                                      child: AutoText2(
                                        text:
                                            "${orderList[index]['food_name']}",
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: null,
                                      ),
                                    ),
                                    AutoText2(
                                      text: "${orderList[index]['detail']}",
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: null,
                                    ),
                                  ],
                                ),
                                Container(
                                  width: width * 0.1,
                                  // color: Colors.green,
                                  child: Center(
                                    child: AutoText(
                                      text: "${orderList[index]['amount']}",
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: null,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width * 0.1,
                                  alignment: Alignment.centerRight,
                                  // color: Colors.yellow,
                                  child: AutoText(
                                    text: "${orderList[index]['price']}",
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                //buttom
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04, vertical: height * 0.01),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoText(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                text: 'Subtotal',
                              ),
                              AutoText(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                text: '$sum_price ฿',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoText(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                text: 'delivery fee',
                              ),
                              AutoText(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                text: '$delivery_fee ฿',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoText(
                                text: "Total",
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              AutoText(
                                text: "$total ฿",
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
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
              ],
            ),
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
            setState(() {
              statusLoading = true;
            });
            update_request();
          } else {
            Navigator.pop(context);
            showdialogCancel();
          }
        },
        child: AutoText(
          color: Colors.white,
          fontSize: 16,
          text: '$text',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  showdialogCancel() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Center(
            child: Text(
          "Do you want Cancel Order?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return CancelORderScreen(
                        request_id: request_id,
                      );
                    }));
                  },
                  child: Text('yes'),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('no'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
