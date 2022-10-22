// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/back_button.dart';
import 'package:barg_store_app/widget/loadingPage.dart';
import 'package:barg_store_app/widget/show_aleart.dart';
import 'package:barg_store_app/widget/show_modol_img.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStoreScreen extends StatefulWidget {
  AddStoreScreen({Key? key}) : super(key: key);

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  bool statusLoading = false;
  String? user_id;
  File? image;
  TextEditingController store_name = TextEditingController();
  TextEditingController store_house_number = TextEditingController();
  TextEditingController store_county = TextEditingController();
  TextEditingController store_district = TextEditingController();
  TextEditingController store_province = TextEditingController();
  TextEditingController store_zipcode = TextEditingController();

  add_store() async {
    String? user_id;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    final uri = Uri.parse("$ipcon/add_store/$user_id");
    var request = http.MultipartRequest('POST', uri);
    var img = await http.MultipartFile.fromPath("img", image!.path);
    request.files.add(img);
    request.fields['store_name'] = store_name.text;
    request.fields['store_house_number'] = store_house_number.text;
    request.fields['store_county'] = store_county.text;
    request.fields['store_district'] = store_district.text;
    request.fields['store_province'] = store_province.text;
    request.fields['store_zipcode'] = store_zipcode.text;

    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      print('add store success');
      Navigator.pop(context);
    }
  }

  check() {
    if (image == "" || image == null) {
      buildShowAlert(context, "Please Select Image");
    } else if (store_name.text == "") {
      buildShowAlert(context, "Please enter your Store Name");
    } else if (store_house_number.text == "") {
      buildShowAlert(context, "Please enter your house number");
    } else if (store_county.text == "") {
      buildShowAlert(context, "Please enter your County");
    } else if (store_district.text == "") {
      buildShowAlert(context, "Please enter your house District");
    } else if (store_province.text == "") {
      buildShowAlert(context, "Please enter your house Province");
    } else if (store_zipcode.text == "") {
      buildShowAlert(context, "Please enter your house Zipcode");
    } else {
      setState(() {
        statusLoading = true;
      });
      add_store();
    }
  }

  pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    Navigator.pop(context);
  }

  pickCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
          child: Stack(
            children: [
              SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      BackArrowButton(text: "AddStore", width2: 0.22),
                      SizedBox(height: height * 0.012),
                      buildImage(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      buildInputBox("Storename", store_name, 0.18),
                      buildInputBox("Storenumber", store_house_number, 0.21),
                      buildInputBox("County", store_county, 0.12),
                      buildInputBox("District", store_district, 0.12),
                      buildInputBox("Province", store_province, 0.14),
                      buildInputBox("Zipcode", store_zipcode, 0.13),
                      buildButtonAdd()
                    ],
                  ),
                ),
              ),
              LoadingPage(statusLoading: statusLoading)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            barrierColor: Colors.black26,
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            builder: (context) {
              return ShowMoDalImg(
                pickCamera: pickCamera,
                pickImage: pickImage,
              );
            });
      },
      child: image == null
          ? Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.24,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 4),
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Image.asset(
                "assets/images/add.png",
                color: Colors.blue,
              ))
          : Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.24,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 4),
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }

  Widget buildInputBox(
      String? text, TextEditingController? controller, double? width2) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.005, horizontal: width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoText(
            width: width * width2!,
            text: text,
            fontSize: 14,
            color: Colors.white,
            text_align: TextAlign.left,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: height * 0.005),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(3, 5),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 24),
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButtonAdd() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: height * 0.04, horizontal: width * 0.06),
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
          check();
        },
        child: Center(
          child: AutoText(
            color: Color(0xFF527DAA),
            fontSize: 24,
            text: 'Add Store',
            text_align: TextAlign.center,
            width: width * 0.31,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
}
