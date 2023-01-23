// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:barg_store_app/widget/color.dart';
import 'package:barg_store_app/widget/loadingPage.dart';
import 'package:barg_store_app/widget/show_aleart.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/back_button.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  String? requset_id;
  String? status;
  OrderDetailScreen({required this.requset_id, required this.status});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List requestList = [];
  List orderList = [];
  List riderList = [];
  String? rider_id;
  bool statusLoading = false;

  get_request() async {
    final response = await http
        .get(Uri.parse("$ipcon/get_request_single/${widget.requset_id}"));
    var data = json.decode(response.body);

    setState(() {
      requestList = data;
    });
    if (requestList[0]['rider_id'] != '') {
      get_user(requestList[0]['rider_id']);
    }
    get_order(requestList[0]['order_id'].toString());
  }

  get_order(order_id) async {
    final response = await http.get(Uri.parse("$ipcon/get_order/$order_id"));
    var data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        orderList = data;
      });
    }
  }

  get_user(user_id) async {
    final response = await http.get(Uri.parse("$ipcon/get_user/$user_id"));
    var data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        riderList = data;
      });
    }
  }

  update_request() async {
    final response = await http.post(
      Uri.parse('$ipcon/update_request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "request_id": widget.requset_id.toString(),
        "status": "6",
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
    print(widget.status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: blue,
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BackArrowButton(text: "OrderDetail", width2: 0.3),
                    Container(
                      margin: EdgeInsets.all(11),
                      width: width,
                      height: height * 0.7,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: requestList.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              )
                            : buildInfo(),
                      ),
                    ),
                    widget.status == "6" || widget.status == "7"
                        ? Container()
                        : buildButton("Send To Rider", Colors.green)
                  ],
                ),
              ),
            ),
            LoadingPage(statusLoading: statusLoading)
          ],
        ),
      ),
    );
  }

  Widget buildInfo() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: get_request(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.01, horizontal: width * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoText(
                    color: Color(0xff2F4F4F),
                    fontSize: 18,
                    text: '${requestList[0]['order_id']}',
                    fontWeight: FontWeight.w700,
                  ),
                  AutoText(
                    color: Color(0xff2F4F4F),
                    fontSize: 18,
                    text: '${requestList[0]['time']}',
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                riderList.isEmpty
                    ? Container(
                        margin: EdgeInsets.only(right: width * 0.01),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xfff5f5f5),
                            borderRadius: BorderRadius.circular(10)),
                        width: width * 0.43,
                        height: height * 0.12,
                        child: Center(
                          child: AutoText(
                            color: Colors.black54,
                            fontSize: 22,
                            text: 'Waiting Rider',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(right: width * 0.01),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xfff5f5f5),
                            borderRadius: BorderRadius.circular(10)),
                        width: width * 0.43,
                        height: height * 0.12,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            requestList[0]['user_image'] == ''
                                ? CircleAvatar(
                                    radius: width * 0.05,
                                    backgroundImage:
                                        AssetImage('assets/images/profile.png'),
                                  )
                                : CircleAvatar(
                                    radius: width * 0.05,
                                    backgroundImage: NetworkImage(
                                        '$path_img/users/${riderList[0]['user_image']}'),
                                  ),
                            AutoText2(
                              color: Colors.black54,
                              fontSize: 14,
                              text:
                                  '${riderList[0]['first_name']} ${riderList[0]['last_name']}',
                              fontWeight: FontWeight.bold,
                            ),
                            AutoText2(
                              color: Colors.black54,
                              fontSize: 14,
                              text: 'Tel : ${riderList[0]['phone']}',
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                Container(
                  margin: EdgeInsets.only(right: width * 0.01),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(10)),
                  width: width * 0.42,
                  height: height * 0.12,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoText(
                        color: Colors.black54,
                        fontSize: 22,
                        text: 'Customer',
                        fontWeight: FontWeight.bold,
                      ),
                      AutoText2(
                        color: Colors.black54,
                        fontSize: 14,
                        text: '${requestList[0]['name']} ',
                        fontWeight: FontWeight.bold,
                      ),
                      AutoText2(
                        color: Colors.black54,
                        fontSize: 14,
                        text: 'Tel : ${requestList[0]['phone']}',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.01, horizontal: width * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoText(
                    color: Colors.black54,
                    fontSize: 22,
                    text: 'Order List',
                    fontWeight: FontWeight.bold,
                  ),
                  requestList.isEmpty
                      ? Text('')
                      : requestList[0]['slip_img'] == ''
                          ? AutoText(
                              color: Colors.black54,
                              fontSize: 22,
                              text: 'ปลายทาง',
                              fontWeight: FontWeight.bold,
                            )
                          : AutoText(
                              color: Colors.black54,
                              fontSize: 22,
                              text: 'OR Code ',
                              fontWeight: FontWeight.bold,
                            ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: width,
              height: height * 0.43,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xfff5f5f5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildListOrder(),
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
                        text: '${requestList[0]['sum_price']} ฿',
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
                        text: '${requestList[0]['delivery_fee']} ฿',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoText(
                        color: Colors.black,
                        fontSize: 22,
                        text: 'Total',
                        fontWeight: FontWeight.bold,
                      ),
                      AutoText(
                        color: Colors.green.shade600,
                        fontSize: 22,
                        text: '${requestList[0]['total']} ฿',
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget buildListOrder() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Expanded(
        child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: orderList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.005, horizontal: width * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * 0.55,
                    child: AutoText2(
                      color: Colors.black,
                      fontSize: 16,
                      text: '${orderList[index]['food_name']}',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AutoText2(
                    color: Colors.grey,
                    fontSize: 16,
                    text: '${orderList[index]['detail']}',
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              Container(
                child: Center(
                  child: AutoText(
                    color: Colors.black,
                    fontSize: 16,
                    text: '${orderList[index]['amount']}',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: width * 0.1,
                alignment: Alignment.centerRight,
                child: AutoText(
                    color: Colors.black,
                    fontSize: 16,
                    text: '${orderList[index]['price']}',
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    ));
  }

  Widget buildButton(String? text, Color color) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.04),
      width: width,
      height: height * 0.06,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          if (requestList[0]['rider_id'] != '') {
            setState(() {
              statusLoading = true;
            });
            update_request();
          } else {
            buildShowAlert(context, "Rider Not Accept");
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
}
