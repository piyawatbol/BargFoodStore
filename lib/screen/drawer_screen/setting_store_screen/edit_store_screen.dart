// ignore_for_file: deprecated_member_use, must_be_immutable, unused_local_variable
import 'dart:convert';
import 'dart:io';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/back_button.dart';
import 'package:barg_store_app/widget/loadingPage.dart';
import 'package:barg_store_app/widget/show_modol_img.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:barg_store_app/ipcon.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditStoreScreen extends StatefulWidget {
  String store_img;
  String store_id;
  String store_name;
  String store_house_number;
  String store_county;
  String store_district;
  String store_province;
  String store_zipcode;

  EditStoreScreen(
      {required this.store_img,
      required this.store_id,
      required this.store_name,
      required this.store_house_number,
      required this.store_county,
      required this.store_district,
      required this.store_province,
      required this.store_zipcode});

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  bool statusLoading = false;
  List storeList = [];
  File? image;
  TextEditingController? store_name;
  TextEditingController? store_house_number;
  TextEditingController? store_county;
  TextEditingController? store_district;
  TextEditingController? store_province;
  TextEditingController? store_zipcode;

  setTextController() async {
    store_name = TextEditingController(text: widget.store_name);
    store_house_number = TextEditingController(text: widget.store_house_number);
    store_county = TextEditingController(text: widget.store_county);
    store_district = TextEditingController(text: widget.store_district);
    store_province = TextEditingController(text: widget.store_province);
    store_zipcode = TextEditingController(text: widget.store_zipcode);
  }

  edit_store() async {
    final response = await http.patch(
      Uri.parse('$ipcon/edit_store/${widget.store_id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "store_name": store_name!.text,
        "store_house_number": store_house_number!.text,
        "store_county": store_county!.text,
        "store_district": store_district!.text,
        "store_province": store_province!.text,
        "store_zipcode": store_zipcode!.text,
      }),
    );
    var data = json.decode(response.body);
    print(data);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      if (data == "update store success") {
        Navigator.pop(context);
      }
    }
  }

  edit_img_store() async {
    final uri = Uri.parse("$ipcon/edit_img_store");
    var request = http.MultipartRequest('POST', uri);
    var img = await http.MultipartFile.fromPath("img", image!.path);
    request.files.add(img);
    request.fields['store_id'] = widget.store_id.toString();
    var response = await request.send();
    if (response.statusCode == 200) {
      print("upload images success");
    } else {
      print("Not upload images");
    }
  }

  Future pickImage() async {
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

  Future pickCamera() async {
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
    setTextController();
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
                      BackArrowButton(text: "Edit Store", width2: 0.23),
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
                      buildInputBox("Storename", store_name),
                      buildInputBox("Store number", store_house_number),
                      buildInputBox("County", store_county),
                      buildInputBox("District", store_district),
                      buildInputBox("Province", store_province),
                      buildInputBox("Zipcode", store_zipcode),
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
          },
        );
      },
      child: Container(
        width: width * 0.8,
        height: height * 0.24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(3, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: image == null
              ? Image.network("$path_img/store/${widget.store_img}",
                  fit: BoxFit.cover)
              : Image.file(
                  image!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget buildInputBox(String? text, TextEditingController? controller) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoText(
            width: width * 0.26,
            text: text,
            fontSize: 14,
            color: Colors.white,
            text_align: TextAlign.left,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: height * 0.004),
          Container(
            width: width * 0.87,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(3, 5),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              style: TextStyle(
                color: Color(0xff3f3f3f),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 25),
              ),
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
      margin: EdgeInsets.symmetric(vertical: height * 0.03),
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
          setState(() {
            statusLoading = true;
          });
          if (image == null) {
            edit_store();
          } else {
            edit_store();
            edit_img_store();
          }
        },
        child: Center(
          child: AutoText(
            color: Color(0xFF527DAA),
            fontSize: 14,
            text: 'Save',
            text_align: TextAlign.center,
            width: width * 0.29,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
