// ignore_for_file: must_be_immutable

import 'package:barg_store_app/widget/back_button.dart';
import 'package:flutter/material.dart';

class CancelORderScreen extends StatefulWidget {
  String? request_id;
  CancelORderScreen({required this.request_id});

  @override
  State<CancelORderScreen> createState() => _CancelORderScreenState();
}

class _CancelORderScreenState extends State<CancelORderScreen> {
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
              BackArrowButton(text: "CancelOrder", width2: 0.3),
              Text(widget.request_id.toString())
            ],
          ),
        ),
      ),
    );
  }
}
