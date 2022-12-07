// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, non_constant_identifier_names, deprecated_member_use
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:io';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/back_button.dart';
import 'package:barg_store_app/widget/loadingPage.dart';
import 'package:barg_store_app/widget/show_aleart.dart';
import 'package:barg_store_app/widget/show_modol_img.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMenuScreen extends StatefulWidget {
  AddMenuScreen({Key? key}) : super(key: key);

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  bool statusLoading = false;
  File? image;
  String? store_id;
  TextEditingController food_name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController detail = TextEditingController();

  add_menu() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      store_id = preferences.getString('store_id');
    });
    final uri = Uri.parse("$ipcon/add_menu");
    var request = http.MultipartRequest('POST', uri);
    var img = await http.MultipartFile.fromPath("img", image!.path);
    request.files.add(img);
    request.fields['store_id'] = store_id.toString();
    request.fields['food_name'] = food_name.text;
    request.fields['price'] = price.text;
    request.fields['detail'] = detail.text;
    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      print('add menu success');
      Navigator.pop(context);
    }
  }

  check() {
    if (image == null) {
      buildShowAlert(context, "Please Select Image");
    } else if (food_name.text == "") {
      buildShowAlert(context, "Please Insert Foodname");
    } else if (price.text == "") {
      buildShowAlert(context, "Please Insert Price");
    } else if (detail.text == "") {
      buildShowAlert(context, "Please Insert Detail");
    } else {
      setState(() {
        statusLoading = true;
      });
      add_menu();
    }
  }

  pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 80);

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
  void initState() {
    super.initState();
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
        body: Stack(
          children: [
            Container(
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
                      BackArrowButton(text: "Add Menu", width2: 0.23),
                      buildImage(),
                      SizedBox(height: height * 0.04),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.015, horizontal: width * 0.05),
                        child: Row(
                          children: [
                            AutoText(
                           
                              text: "Menu",
                              fontSize: 22,
                              color: Colors.white,
                              
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                      BuildInputBox(
                          "Foodname", food_name, Icons.food_bank, 0.18),
                      BuildInputBox("price", price, Icons.attach_money, 0.1),
                      BuildInputBox("detail", detail, Icons.edit_note, 0.1),
                      buildButtonSave()
                    ],
                  ),
                ),
              ),
            ),
            LoadingPage(statusLoading: statusLoading)
          ],
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

  Widget BuildInputBox(String? text, TextEditingController? controller,
      IconData? icon, double? width2) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.07, vertical: height * 0.006),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoText(
         
            text: text,
            fontSize: 14,
            color: Colors.white,
           
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: height * 0.004),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF6CA8F1),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              obscureText: false,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                    icon,
                    color: Colors.white,
                  ),
                  hintText: "$text",
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButtonSave() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.04),
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
          check();
        },
        child: Center(
          child: AutoText(
            color: Color(0xFF527DAA),
            fontSize: 14,
            text: 'Save',
           
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
