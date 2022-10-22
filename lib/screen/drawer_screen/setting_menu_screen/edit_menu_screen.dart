// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, non_constant_identifier_names, must_be_immutable, deprecated_member_use, unused_local_variable
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'dart:io';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:barg_store_app/widget/back_button.dart';
import 'package:barg_store_app/widget/loadingPage.dart';
import 'package:barg_store_app/widget/show_modol_img.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditMenuScreen extends StatefulWidget {
  String food_id;
  String img;
  String food_name;
  String price;
  String detail;
  int status;
  EditMenuScreen(
      {required this.food_id,
      required this.img,
      required this.food_name,
      required this.price,
      required this.detail,
      required this.status});

  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {
  bool statusLoading = false;
  TextEditingController? food_name;
  TextEditingController? price;
  TextEditingController? detail;
  File? image;

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

  edit_menu() async {
    final response = await http.patch(
      Uri.parse('$ipcon/edit_menu/${widget.food_id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "food_name": food_name!.text,
        "price": price!.text,
        "detail": detail!.text,
        "food_status": widget.status.toString()
      }),
    );
    print(response.body);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      if (data == "update menu success") {
        Navigator.pop(context);
      }
    }
  }

  delete_menu() async {
    print(widget.food_id);
    final response =
        await http.delete(Uri.parse("$ipcon/delete_menu/${widget.food_id}}"));
    var data = json.decode(response.body);
    print(data);
    if (data == "delete menu success") {
      setState(() {
        statusLoading = false;
      });
      if (data == "delete menu success") {
        Navigator.pop(context);
      }
    }
  }

  edit_img() async {
    final uri = Uri.parse("$ipcon/edit_img_food");
    var request = http.MultipartRequest('POST', uri);
    var img = await http.MultipartFile.fromPath("img", image!.path);
    request.files.add(img);
    request.fields['id'] = widget.food_id.toString();
    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        statusLoading = false;
      });
      print("upload images success");
      Navigator.pop(context);
    } else {
      print("Not upload images");
    }
  }

  setTextController() async {
    food_name = TextEditingController(text: widget.food_name);
    price = TextEditingController(text: widget.price);
    detail = TextEditingController(text: widget.detail);
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
                      BackArrowButton(text: "Edit Menu", width2: 0.22),
                      buildImage(),
                      SizedBox(height: height * 0.02),
                      buildMenuSwitch(),
                      buildInputBox(
                          "Foodname", food_name, Icons.food_bank, 0.18),
                      buildInputBox("price", price, Icons.attach_money, 0.09),
                      buildInputBox("detail", detail, Icons.edit_note, 0.1),
                      buildButtonSave(),
                      buildButtonDelete()
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

  Widget buildMenuSwitch() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoText(
            width: width * 0.17,
            text: "Menu",
            fontSize: 22,
            color: Colors.white,
            text_align: TextAlign.left,
            fontWeight: FontWeight.bold,
          ),
          Row(
            children: [
              AutoText(
                width: width * 0.16,
                text: "Status",
                fontSize: 20,
                color: Colors.white,
                text_align: TextAlign.left,
                fontWeight: FontWeight.bold,
              ),
              Switch(
                activeColor: Colors.white,
                value: widget.status == 1 ? true : false,
                onChanged: ((v) {
                  if (v == true) {
                    setState(() {
                      widget.status = 1;
                    });
                  } else {
                    setState(() {
                      widget.status = 0;
                    });
                  }
                }),
              ),
            ],
          ),
        ],
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
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.24,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: image != null
              ? Image.file(
                  image!,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  "$path_img/food/${widget.img}",
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }

  Widget buildInputBox(String? text, TextEditingController? controller,
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
            width: width * width2!,
            text: text,
            fontSize: 14,
            color: Colors.white,
            text_align: TextAlign.left,
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
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.08, vertical: height * 0.03),
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
          setState(() {
            statusLoading = true;
          });
          if (image == null) {
            edit_menu();
          } else {
            edit_menu();
            edit_img();
          }
        },
        child: Center(
          child: AutoText(
            color: Color(0xFF527DAA),
            fontSize: 24,
            text: 'Save',
            text_align: TextAlign.center,
            width: width * 0.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildButtonDelete() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.08, vertical: height * 0.0),
      width: double.infinity,
      height: height * 0.055,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.red,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
        onPressed: () {
          showdialogDelete();
        },
        child: Center(
          child: AutoText(
            color: Colors.white,
            fontSize: 24,
            text: 'Delete',
            text_align: TextAlign.center,
            width: width * 0.2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  showdialogDelete() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Center(
            child: Text(
          "Do you want Delete Menu?",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      statusLoading = true;
                    });
                    delete_menu();
                    Navigator.pop(context);
                  },
                  child: Text('yes'),
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Colors.red,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('no'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
