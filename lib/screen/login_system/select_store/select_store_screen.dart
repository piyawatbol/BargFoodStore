// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barg_store_app/screen/login_system/login_screen.dart';
import 'package:barg_store_app/screen/login_system/select_store/add_store_screen.dart';
import 'package:barg_store_app/screen/myPage.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class SelectStoreScreen extends StatefulWidget {
  SelectStoreScreen({Key? key}) : super(key: key);

  @override
  State<SelectStoreScreen> createState() => _SelectStoreScreenState();
}

class _SelectStoreScreenState extends State<SelectStoreScreen> {
  List storeList = [];
  var data;

  get_store() async {
    String? user_id;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final response = await http.get(Uri.parse("$ipcon/get_store/$user_id"));
    data = json.decode(response.body);
    setState(() {
      storeList = data;
    });
  }

  save_store_id(store_id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('store_id', store_id);
    print("select store_id : $store_id");
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return LoginScreen();
    }), (route) => false);
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.03),
                  child: AutoText(
                    width: width * 0.5,
                    text: "Select Your Store",
                    fontSize: 50,
                    color: Colors.white,
                    text_align: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildGetStore(),
                Container(
                  width: double.infinity,
                  height: height * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildButtonAdd(),
                      buildButtonLogout(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGetStore() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: get_store(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return storeList.isEmpty
            ? Container(
                height: height * 0.65,
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return buildLoading();
                  },
                ),
              )
            : storeList[0]['store_id'] == null
                ? Container(
                    height: height * 0.65,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                    height: height * 0.65,
                    child: ListView.builder(
                      itemCount: storeList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            save_store_id(
                                storeList[index]['store_id'].toString());
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return MyPage();
                            }));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: height * 0.005,
                            ),
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 5,
                                  blurRadius: 4,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * 0.4,
                                    height: height * 0.25,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        "$path_img/store/${storeList[index]['store_image']}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.4,
                                    height: height * 0.2,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(height: height * 0.006),
                                          AutoSizeText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            minFontSize: 18,
                                            storeList[index]['store_name']
                                                .toString(),
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.01),
                                          buildRowText(
                                              "Store number : ",
                                              "${storeList[index]['store_house_number']}",
                                              0.26,
                                              0.14),
                                          buildRowText(
                                              "County : ",
                                              "${storeList[index]['store_county']}",
                                              0.15,
                                              0.25),
                                          buildRowText(
                                              "District : ",
                                              "${storeList[index]['store_district']}",
                                              0.15,
                                              0.25),
                                          buildRowText(
                                              "Province : ",
                                              "${storeList[index]['store_province']}",
                                              0.17,
                                              0.23),
                                          buildRowText(
                                              "Zipcode : ",
                                              "${storeList[index]['store_zipcode']}",
                                              0.16,
                                              0.24),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
      },
    );
  }

  Widget buildRowText(
      String? text1, String? text2, double? width1, double? width2) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        AutoText(
          width: width * width1!,
          text: text1,
          fontSize: 14,
          color: Colors.black,
          text_align: TextAlign.left,
          fontWeight: null,
        ),
        AutoText2(
          width: width * width2!,
          text: text2,
          fontSize: 14,
          color: Colors.grey,
          text_align: TextAlign.left,
          fontWeight: null,
        ),
      ],
    );
  }

  Widget buildButtonAdd() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.07),
      width: double.infinity,
      height: height * 0.055,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return AddStoreScreen();
          }));
        },
        child: Center(
          child: AutoText(
            color: Color(0xFF527DAA),
            fontSize: 20,
            text: 'Add Store',
            text_align: TextAlign.center,
            width: width * 0.29,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildButtonLogout() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.07),
      width: double.infinity,
      height: height * 0.055,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          logout();
        },
        child: Center(
          child: AutoText(
            color: Color(0xFF527DAA),
            fontSize: 20,
            text: 'Logout',
            text_align: TextAlign.center,
            width: width * 0.25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    buildRowLoading(double? width2) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: height * 0.003),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.white70,
              highlightColor: Colors.white10,
              child: Container(
                width: MediaQuery.of(context).size.width * width2!,
                height: MediaQuery.of(context).size.height * 0.017,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Shimmer.fromColors(
                baseColor: Colors.white70,
                highlightColor: Colors.white10,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.12,
                  height: MediaQuery.of(context).size.height * 0.017,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.005, horizontal: width * 0.07),
      width: double.infinity,
      height: height * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white24,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.white70,
              highlightColor: Colors.white10,
              child: Container(
                width: width * 0.4,
                height: height * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.black38,
                ),
              ),
            ),
            SizedBox(
              width: width * 0.4,
              child: Column(
                children: [
                  SizedBox(height: height * 0.006),
                  Shimmer.fromColors(
                    baseColor: Colors.white70,
                    highlightColor: Colors.white10,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: height * 0.01),
                      width: width * 0.35,
                      height: height * 0.025,
                      decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  buildRowLoading(0.22),
                  buildRowLoading(0.18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
