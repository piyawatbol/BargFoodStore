import 'dart:convert';
import 'package:barg_store_app/screen/drawer_screen/accepted_screen/order_detail.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/color.dart';
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
  bool show = false;
  int sum_price = 0;
  String? request_id;
  bool statusLoading = false;

  get_request_confirm() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString('store_id');
    });
    final response =
        await http.get(Uri.parse("$ipcon/get_request_confirm/$store_id"));
    var data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        requestList = data;
      });
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
        color: blue,
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
      future: get_request_confirm(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Expanded(
          child: ListView.builder(
            itemCount: requestList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return OrderDetailScreen(
                      requset_id: '${requestList[index]['request_id']}',
                      status: '${requestList[index]['status']}',
                    );
                  }));
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
                              text: "Status",
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            AutoText(
                              text: requestList[index]['order_status_name'],
                              fontSize: 16,
                              color: requestList[index]['order_status_id'] == 3
                                  ? Colors.orange
                                  : Colors.green,
                              fontWeight: null,
                            ),
                          ],
                        ),
                      ),
                      buildRowText(
                          index,
                          requestList[index]['order_id'].toString(),
                          requestList[index]['time'].toString()),
                      buildRowText(index, 'Pay type ',
                          "${requestList[index]['buyer_name']}"),
                      buildRowText(
                        index,
                        'Total',
                        '${requestList[index]['total']}฿',
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

  Widget buildRowText(index, String text1, String text2) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.03, vertical: height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoText(
            text: "$text1",
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          AutoText(
            text: '$text2',
            fontSize: 16,
            color: text1 == 'Total' ? Colors.green : Colors.black,
            fontWeight: null,
          ),
        ],
      ),
    );
  }
}
