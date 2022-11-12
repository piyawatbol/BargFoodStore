import 'dart:convert';
import 'package:barg_store_app/screen/drawer_screen/accepted_screen/order_detail.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:barg_store_app/widget/back_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AcceptedScreen extends StatefulWidget {
  AcceptedScreen({Key? key}) : super(key: key);

  @override
  State<AcceptedScreen> createState() => _AcceptedScreenState();
}

class _AcceptedScreenState extends State<AcceptedScreen> {
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
    final response = await http.get(Uri.parse("$ipcon/get_request/$store_id"));
    var data = json.decode(response.body);
    setState(() {
      requestList = data;
    });
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
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
              BackArrowButton(text: "Accepted Menu", width2: 0.35),
              buildListRequest()
            ],
          ),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return OrderDetailScreen(
                      order_id: '${requestList[index]['order_id']}',
                      rider_id: '${requestList[index]['rider_id']}',
                      user_id: '${requestList[index]['user_id']}',
                      total: '${priceList[index]}',
                      time: '${requestList[index]['time']}',
                    );
                  }));
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.035, vertical: height * 0.005),
                  width: width,
                  height: height * 0.17,
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
                              width: width * 0.4,
                              text: "Status",
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              text_align: TextAlign.left,
                              fontWeight: FontWeight.bold,
                            ),
                            AutoText(
                              width: width * 0.3,
                              text: requestList[index]['order_status_name'],
                              fontSize: 16,
                              color: requestList[index]['status'] == '3'
                                  ? Colors.orange
                                  : Colors.green,
                              text_align: TextAlign.right,
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
                              width: width * 0.4,
                              text: requestList[index]['order_id'],
                              fontSize: 16,
                              color: Colors.black,
                              text_align: TextAlign.left,
                              fontWeight: FontWeight.w600,
                            ),
                            AutoText(
                              width: width * 0.2,
                              text: requestList[index]['time'],
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              text_align: TextAlign.right,
                              fontWeight: FontWeight.w600,
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
                              width: width * 0.2,
                              text: "Item ",
                              fontSize: 16,
                              color: Colors.black,
                              text_align: TextAlign.left,
                              fontWeight: FontWeight.w600,
                            ),
                            amoutList.isEmpty
                                ? Text("")
                                : AutoText(
                                    width: width * 0.2,
                                    text: amoutList[index],
                                    fontSize: 16,
                                    color: Colors.black,
                                    text_align: TextAlign.right,
                                    fontWeight: FontWeight.w600,
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
                              width: width * 0.2,
                              text: "Total ",
                              fontSize: 16,
                              color: Colors.black,
                              text_align: TextAlign.left,
                              fontWeight: FontWeight.bold,
                            ),
                            amoutList.isEmpty
                                ? Text("")
                                : AutoText(
                                    width: width * 0.2,
                                    text: '${priceList[index]}฿',
                                    fontSize: 16,
                                    color: Colors.green,
                                    text_align: TextAlign.right,
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
}
