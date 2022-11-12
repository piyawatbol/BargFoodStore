// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/back_button.dart';
import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  String? order_id;
  String? rider_id;
  String? user_id;
  String? total;
  String? time;

  OrderDetailScreen(
      {required this.order_id,
      required this.rider_id,
      required this.user_id,
      required this.total,
      required this.time});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List orderList = [];
  List userList = [];
  List riderList = [];
  get_order() async {
    final response =
        await http.get(Uri.parse("$ipcon/get_order/${widget.order_id}"));
    var data = json.decode(response.body);
    setState(() {
      orderList = data;
    });
    // print(orderList);
  }

  get_user() async {
    final response =
        await http.get(Uri.parse("$ipcon/get_user/${widget.user_id}"));
    var data = json.decode(response.body);
    setState(() {
      userList = data;
    });
    // print(userList);
  }

  get_rider() async {
    final response =
        await http.get(Uri.parse("$ipcon/get_user/${widget.rider_id}"));
    var data = json.decode(response.body);
    setState(() {
      riderList = data;
    });
  }

  @override
  void initState() {
    get_rider();
    get_user();
    get_order();
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
                    child: userList.isEmpty ||
                            riderList.isEmpty ||
                            orderList.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          )
                        : buildInfo()),
              ),
              buildButton("Send To Rider", Colors.green)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfo() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                text: '${widget.order_id}',
                text_align: TextAlign.left,
                width: width * 0.52,
                fontWeight: FontWeight.w700,
              ),
              AutoText(
                color: Color(0xff2F4F4F),
                fontSize: 18,
                text: '${widget.time}',
                text_align: TextAlign.right,
                width: width * 0.3,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(right: width * 0.01),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(10)),
              width: width * 0.43,
              height: height * 0.12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoText(
                    color: Colors.black54,
                    fontSize: 22,
                    text: 'Rider Info ',
                    text_align: TextAlign.left,
                    width: width * 0.52,
                    fontWeight: FontWeight.bold,
                  ),
                  AutoText2(
                    color: Colors.black54,
                    fontSize: 14,
                    text:
                        '${riderList[0]['first_name']} ${riderList[0]['last_name']}',
                    text_align: TextAlign.left,
                    width: width * 0.41,
                    fontWeight: FontWeight.bold,
                  ),
                  AutoText2(
                    color: Colors.black54,
                    fontSize: 14,
                    text: '${riderList[0]['phone']}',
                    text_align: TextAlign.left,
                    width: width * 0.41,
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
                children: [
                  AutoText(
                    color: Colors.black54,
                    fontSize: 22,
                    text: 'Customer Info ',
                    text_align: TextAlign.left,
                    width: width * 0.52,
                    fontWeight: FontWeight.bold,
                  ),
                  AutoText2(
                    color: Colors.black54,
                    fontSize: 14,
                    text:
                        '${userList[0]['first_name']} ${userList[0]['last_name']}',
                    text_align: TextAlign.left,
                    width: width * 0.41,
                    fontWeight: FontWeight.bold,
                  ),
                  AutoText2(
                    color: Colors.black54,
                    fontSize: 14,
                    text: '${userList[0]['phone']}',
                    text_align: TextAlign.left,
                    width: width * 0.41,
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
          child: AutoText(
            color: Colors.black54,
            fontSize: 22,
            text: 'Order List',
            text_align: TextAlign.left,
            width: width * 0.52,
            fontWeight: FontWeight.bold,
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
                  children: [
                    AutoText(
                      color: Colors.black,
                      fontSize: 22,
                      text: 'Total',
                      text_align: TextAlign.left,
                      width: width * 0.52,
                      fontWeight: FontWeight.bold,
                    ),
                    AutoText(
                      color: Colors.green.shade600,
                      fontSize: 22,
                      text: '${widget.total}฿',
                      text_align: TextAlign.right,
                      width: width * 0.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                )
              ],
            ))
      ],
    );
  }

  Widget buildListOrder() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
        child: ListView.builder(
      itemCount: orderList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.005),
          child: Row(
            children: [
              AutoText2(
                color: Colors.black,
                fontSize: 16,
                text: '${orderList[index]['food_name']}',
                text_align: TextAlign.left,
                width: width * 0.55,
                fontWeight: FontWeight.w500,
              ),
              AutoText(
                color: Colors.black,
                fontSize: 16,
                text: '${orderList[index]['amount']}',
                text_align: TextAlign.right,
                width: width * 0.1,
                fontWeight: FontWeight.w500,
              ),
              AutoText(
                  color: Colors.black,
                  fontSize: 16,
                  text: '${orderList[index]['price']}',
                  text_align: TextAlign.right,
                  width: width * 0.16,
                  fontWeight: FontWeight.w500),
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
        onPressed: () {},
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
