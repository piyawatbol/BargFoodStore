// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable, must_be_immutable
import 'dart:convert';
import 'package:barg_store_app/screen/drawer_screen/home_screen/cancel_order_screen.dart';
import 'package:barg_store_app/screen/drawer_screen/home_screen/show_bid_slip.dart';
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
  int sum_price = 0;
  String? request_id;
  bool statusLoading = false;
  List amoutList = [];
  List priceList = [];
  int sum_amount = 0;
  int sum_pirce = 0;

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
        sum_price = 0;
      });
      for (var i = 0; i < orderList.length; i++) {
        if (orderList[i]['price'] != null) {
          sum_price = sum_price + int.parse(orderList[i]['price']);
        }
      }
      setState(() {
        statusLoading = false;
      });
      buildShow(_request_id, _order_id, _slip_img, _time);
    }
  }

  get_sum_amout_price(String? _order_id, index) async {
    final response = await http.get(Uri.parse("$ipcon/get_order/$_order_id"));
    var data = json.decode(response.body);
    setState(() {
      order_List = data;
      sum_amount = 0;
      sum_pirce = 0;
    });
    for (var i = 0; i < order_List.length; i++) {
      int amount = int.parse(order_List[i]['amount']);
      int price = int.parse(order_List[i]['price']);

      sum_amount = sum_amount + amount;
      sum_pirce = sum_pirce + price;
    }
    if (amoutList.length < requestList.length) {
      amoutList.add('$sum_amount');
      priceList.add('$sum_pirce');
    } else {
      amoutList[index] = sum_amount.toString();
      priceList[index] = sum_pirce.toString();
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
              get_sum_amout_price(requestList[index]['order_id'], index);
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
                  height: height * 0.13,
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
                              text: "Item ",
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: null,
                            ),
                            amoutList.isEmpty
                                ? Text("")
                                : AutoText(
                                    text: amoutList[index],
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  )
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
                            amoutList.isEmpty
                                ? Text("")
                                : AutoText(
                                    text: '${priceList[index]}฿',
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

  buildShow(String? _request_id, String? _order_id, String? _slip_img,
      String? _time) {
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
                                  children: [
                                    AutoText2(
                                      text: "${orderList[index]['food_name']}",
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: null,
                                    ),
                                    AutoText2(
                                      text: "${orderList[index]['detail']}",
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: null,
                                    ),
                                  ],
                                ),
                                AutoText(
                                  text: "${orderList[index]['amount']}",
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: null,
                                ),
                                AutoText(
                                  text: "${orderList[index]['price']}",
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: null,
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
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoText2(
                            text: "Total",
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          AutoText(
                            text: "${sum_price}฿",
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    _slip_img == ""
                        ? Container(
                            width: width * 0.5,
                            height: height * 0.07,
                            child: Center(
                              child: AutoText(
                                text: "เก็บปลายทาง",
                                fontSize: 20,
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return showBigSlip(img: _slip_img);
                              }));
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: height * 0.01),
                                width: double.infinity,
                                height: height * 0.22,
                                child: Image.network(
                                  "$path_img/slip/$_slip_img",
                                  fit: BoxFit.contain,
                                )),
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
