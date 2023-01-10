import 'dart:convert';
import 'package:barg_store_app/screen/drawer_screen/accepted_screen/order_detail.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/color.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:barg_store_app/widget/back_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryOrderScreen extends StatefulWidget {
  HistoryOrderScreen({Key? key}) : super(key: key);

  @override
  State<HistoryOrderScreen> createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  String? store_id;
  List requestList = [];
  List orderList = [];
  bool show = false;
  String? request_id;
  bool statusLoading = false;

  get_request() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString('store_id');
    });
    final response =
        await http.get(Uri.parse("$ipcon/get_request_history/$store_id"));
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
              BackArrowButton(text: "History", width2: 0.35),
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
                  height: height * 0.16,
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
                              text: "Status",
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            AutoText(
                              text: requestList[index]['order_status_name'],
                              fontSize: 16,
                              color: requestList[index]['status'] == '3'
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
                      buildRowText(
                          index,
                          'Pay type ',
                          requestList[index]['slip_img'] != ''
                              ? 'QR Code'
                              : "ปลายทาง"),
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
