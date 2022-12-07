import 'dart:convert';
import 'package:barg_store_app/screen/drawer_screen/drawer_widget.dart';
import 'package:barg_store_app/screen/drawer_screen/home_screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:barg_store_app/ipcon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  MyPage({Key? key}) : super(key: key);
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List userList = [];

  get_id() async {
    String? user_id;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
    });
    if (user_id == null || user_id == "") {
      return userList;
    } else {
      final response = await http.get(Uri.parse("$ipcon/get_user/$user_id"));
      var data = json.decode(response.body);
      if (this.mounted) {
        setState(() {
          userList = data;
        });
        return userList;
      }
    }
  }

  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  late bool isDrawerOpen;
  DrawerItem item = DrawerItems.home;
  bool isDragging = false;

  void openDrawer() {
    setState(() {
      xOffset = MediaQuery.of(context).size.width * 0.6;
      yOffset = MediaQuery.of(context).size.height * 0.2;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    return setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  void initState() {
    get_id();
    closeDrawer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white54,
        child: Stack(
          children: [
            buildDrawer(),
            buildPage(),
          ],
        ),
      ),
    );
  }

  buildDrawer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: SafeArea(
          child: DrawerWidget(
        userList: userList,
        onSelectedItem: (item) {
          setState(() {
            this.item = item;
          });
          closeDrawer();
        },
        get_id: get_id(),
      )),
    );
  }

  buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onHorizontalDragStart: ((details) => isDragging = true),
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        onTap: () {
          closeDrawer();
        },
        child: AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor),
            duration: Duration(milliseconds: 300),
            child: AbsorbPointer(
              absorbing: isDrawerOpen,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isDrawerOpen ? 30 : 0),
                child: Container(
                    color: isDrawerOpen
                        ? Colors.grey.shade300
                        : Colors.grey.shade200,
                    child: getDrawerPage()),
              ),
            )),
      ),
    );
  }

  getDrawerPage() {
    if (item == DrawerItems.home) {
      return HomeScreen(
        openDrawer: openDrawer,
      );
    }
  }
}
