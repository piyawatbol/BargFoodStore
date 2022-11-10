// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:barg_store_app/screen/drawer_screen/setting_store_screen/edit_store_screen.dart';
import 'package:barg_store_app/screen/drawer_screen/setting_store_screen/map_picker.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/back_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class SettingStoreScreen extends StatefulWidget {
  SettingStoreScreen({Key? key}) : super(key: key);

  @override
  State<SettingStoreScreen> createState() => _SettingStoreScreenState();
}

class _SettingStoreScreenState extends State<SettingStoreScreen> {
  List storeList = [];
  GoogleMapController? mapController;
  final Set<Marker> markers = new Set();

  get_store_single() async {
    String? user_id;
    String? store_id;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
      store_id = preferences.getString('store_id');
    });
    final response =
        await http.get(Uri.parse("$ipcon/get_store/single/$user_id/$store_id"));
    var data = json.decode(response.body);

    if (this.mounted) {
      setState(() {
        storeList = data;
        mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 16,
            target: LatLng(double.parse(storeList[0]['store_lat']),
                double.parse(storeList[0]['store_long'])),
          ),
        ));
        markers.add(Marker(
          markerId: MarkerId('1'),
          position: LatLng(double.parse(storeList[0]['store_lat']),
              double.parse(storeList[0]['store_long'])),
          infoWindow: InfoWindow(
            title: 'My Custom Title ',
            snippet: 'My Custom Subtitle',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                  BackArrowButton(text: "Setting Store", width2: 0.3),
                  buildImage(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.025, horizontal: width * 0.1),
                    child: Row(
                      children: [
                        AutoText(
                          width: width * 0.25,
                          text: "My Store",
                          fontSize: 22,
                          color: Colors.white,
                          text_align: TextAlign.left,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                  buildInfoStore(),
                  buildMap(),
                  buildButtonEdit()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: get_store_single(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return storeList.isEmpty
            ? buildLoadingImage()
            : Container(
                width: width * 0.8,
                height: height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    "$path_img/store/${storeList[0]['store_image']}",
                    fit: BoxFit.cover,
                  ),
                ),
              );
      },
    );
  }

  Widget buildInfoStore() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return storeList.isEmpty
        ? buildLoadingInfo()
        : Container(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            width: width * 0.85,
            height: height * 0.21,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(3, 5),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildRowText(
                      "Store name :", storeList[0]['store_name'], 0.27, 0.42),
                  buildRowText("House number :",
                      storeList[0]['store_house_number'], 0.33, 0.36),
                  buildRowText(
                      "County :", storeList[0]['store_county'], 0.18, 0.51),
                  buildRowText(
                      "District :", storeList[0]['store_district'], 0.18, 0.51),
                  buildRowText(
                      "Province :", storeList[0]['store_province'], 0.22, 0.47),
                  buildRowText(
                      "Zipcode :", storeList[0]['store_zipcode'], 0.2, 0.49),
                ],
              ),
            ),
          );
  }

  Widget buildRowText(
      String? text1, String? text2, double? width1, double? width2) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.004, horizontal: width * 0.07),
      child: Row(
        children: [
          AutoText(
            width: width * width1!,
            text: "$text1",
            fontSize: 16,
            color: Colors.black87,
            text_align: TextAlign.left,
            fontWeight: FontWeight.bold,
          ),
          AutoText2(
            width: width * width2!,
            text: "${text2}",
            fontSize: 16,
            color: Colors.black87,
            text_align: TextAlign.left,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget buildMap() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return storeList.isEmpty
        ? buildLoadingInfo()
        : GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MappickerScreen();
              }));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: height * 0.02),
              width: width * 0.85,
              height: height * 0.22,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    offset: Offset(3, 5),
                  ),
                ],
              ),
              child: Center(
                child: storeList[0]['store_lat'] == null ||
                        storeList[0]['store_lat'] == ""
                    ? AutoText(
                        width: width * 0.35,
                        text: "Please Pin the Store",
                        fontSize: 14,
                        color: Colors.black,
                        text_align: TextAlign.center,
                        fontWeight: null)
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: GoogleMap(
                              onMapCreated: _onMapCreated,
                              zoomControlsEnabled: false,
                              markers: markers,
                              myLocationButtonEnabled: false,
                              initialCameraPosition: CameraPosition(
                                zoom: 17,
                                target: LatLng(
                                    double.parse(storeList[0]['store_lat']),
                                    double.parse(storeList[0]['store_long'])),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return MappickerScreen();
                              }));
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        ],
                      ),
              ),
            ),
          );
  }

  Widget buildButtonEdit() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return storeList.isEmpty
        ? buildLoadingButton()
        : Container(
            width: width * 0.3,
            height: height * 0.05,
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
                  return EditStoreScreen(
                      store_img: storeList[0]['store_image'],
                      store_id: storeList[0]['store_id'].toString(),
                      store_name: storeList[0]['store_name'],
                      store_house_number: storeList[0]['store_house_number'],
                      store_county: storeList[0]['store_county'],
                      store_district: storeList[0]['store_district'],
                      store_province: storeList[0]['store_province'],
                      store_zipcode: storeList[0]['store_zipcode']);
                }));
              },
              child: Center(
                child: AutoText(
                  color: Color(0xFF527DAA),
                  fontSize: 14,
                  text: 'Edit Store',
                  text_align: TextAlign.center,
                  width: width * 0.29,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }

  Widget buildLoadingImage() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Shimmer.fromColors(
      baseColor: Colors.white24,
      highlightColor: Colors.white12,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        width: width * 0.8,
        height: height * 0.2,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  Widget buildLoadingInfo() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.white24,
      highlightColor: Colors.white12,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: height * 0.005, horizontal: width * 0.07),
        width: width * 0.8,
        height: height * 0.22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.015),
        ),
      ),
    );
  }

  Widget buildLoadingButton() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.white24,
      highlightColor: Colors.white12,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: height * 0.005, horizontal: width * 0.07),
        width: width * 0.3,
        height: height * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.02, vertical: height * 0.015),
        ),
      ),
    );
  }
}
