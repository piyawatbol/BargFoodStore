// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:barg_store_app/screen/myPage.dart';
import 'package:flutter/material.dart';

class CencelScreen extends StatefulWidget {
  CencelScreen({Key? key}) : super(key: key);

  @override
  State<CencelScreen> createState() => _CencelScreenState();
}

class _CencelScreenState extends State<CencelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xff85BFF4),
      ),
      backgroundColor: Color(0xff85BFF4),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      "สาเหตุที่ยกเลิก",
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  maxLines: 7,
                  maxLength: 500,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.white,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 3,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MyPage();
                  }));
                },
                child: Text('ส่ง'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
