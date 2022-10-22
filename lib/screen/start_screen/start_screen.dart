// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'package:barg_store_app/screen/login_system/select_store/select_store_screen.dart';
import 'package:barg_store_app/screen/myPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:barg_store_app/screen/login_system/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  StartScreen({Key? key}) : super(key: key);
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  check_connect() async {
    String? user_id;
    String? store_id;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('user_id') == null ||
        preferences.getString('user_id') == "") {
      preferences.setString('user_id', "");
    } else {
      setState(() {
        user_id = preferences.getString('user_id');
      });
    }
    if (preferences.getString('store_id') == null) {
      preferences.setString('store_id', "");
    } else {
      setState(() {
        store_id = preferences.getString('store_id');
      });
    }
    print("user_id : $user_id");
    print("store_id : $store_id");
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return user_id == null || user_id == ""
          ? LoginScreen()
          : store_id == null || store_id == ""
              ? SelectStoreScreen()
              : MyPage();
    }));
  }

  check_connect2() async {
    String? user_id;
    String? store_id;
    Timer.periodic(new Duration(seconds: 1), (timer) async {
      print("loading ...");
      final response = await http.get(Uri.parse("$ipcon/"));
      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200) {
        print("connected");
        timer.cancel();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        if (preferences.getString('user_id') == null ||
            preferences.getString('user_id') == "") {
          preferences.setString('user_id', "");
        } else {
          setState(() {
            user_id = preferences.getString('user_id');
          });
        }
        if (preferences.getString('store_id') == null) {
          preferences.setString('store_id', "");
        } else {
          setState(() {
            store_id = preferences.getString('store_id');
          });
        }
      }
      print("user_id : $user_id");
      print("store_id : $store_id");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return user_id == null || user_id == ""
            ? LoginScreen()
            : store_id == null || store_id == ""
                ? SelectStoreScreen()
                : MyPage();
      }));
    });
  }

  @override
  void initState() {
    // get_id();
    check_connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0xFF73AEF5),
            Color(0xFF61A4F1),
            Color(0xFF478De0),
            Color(0xFF398AE5)
          ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/logo.png",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: SpinKitThreeBounce(
              color: Colors.blue,
              size: 30,
            ),
          )
        ],
      ),
    ));
  }
}
