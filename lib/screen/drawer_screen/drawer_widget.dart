// ignore_for_file: must_be_immutable
import 'package:barg_store_app/ipcon.dart';
import 'package:barg_store_app/screen/drawer_screen/accepted_screen/accepted_screen.dart';
import 'package:barg_store_app/screen/drawer_screen/profile_screen/profile_screen.dart';
import 'package:barg_store_app/screen/drawer_screen/setting_menu_screen/setting_menu_screen.dart';
import 'package:barg_store_app/screen/drawer_screen/setting_store_screen/setting_store_screen.dart';
import 'package:barg_store_app/screen/login_system/login_screen.dart';
import 'package:barg_store_app/screen/login_system/select_store/select_store_screen.dart';
import 'package:barg_store_app/widget/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  final get_id;
  final ValueChanged<DrawerItem> onSelectedItem;

  List userList;

  DrawerWidget({
    required this.get_id,
    required this.userList,
    required this.onSelectedItem,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: height * 0.01, horizontal: width * 0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.055),
          buildUsername(context),
          SizedBox(height: height * 0.02),
          buildDrawerItems(context), //only Home
          BuildListTile(context, "assets/images/fast-delivery.png",
              "Accepted List", AcceptedScreen(), 0.25),
          BuildListTile(context, "assets/images/menu.png", "Setting Menu",
              SettingMenuScreen(), 0.25),
          BuildListTile(context, "assets/images/settings.png", "Setting Store",
              SettingStoreScreen(), 0.24),
          SizedBox(height: height * 0.025),
          Divider(height: 10, color: Colors.white),

          BuildListTile(context, "assets/images/change.png", "Change Store",
              SelectStoreScreen(), 0.24),
          BuildListTile(context, "assets/images/logout.png", "Logout",
              LoginScreen(), 0.14)
        ],
      ),
    );
  }

  Widget buildUsername(context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: get_id,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.01, horizontal: width * 0.01),
          child: userList.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(),
                  child: CircleAvatar(
                      backgroundColor: Colors.blue.shade200,
                      radius: width * 0.06,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ProfileScreen();
                    }));
                  },
                  child: Container(
                    child: Row(
                      children: [
                        userList[0]['user_image'] == ""
                            ? CircleAvatar(
                                radius: width * 0.078,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: width * 0.07,
                                  backgroundImage:
                                      AssetImage("assets/images/profile.png"),
                                ),
                              )
                            : CircleAvatar(
                                radius: width * 0.078,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: width * 0.07,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: width * 0.07,
                                    backgroundImage: NetworkImage(
                                        "$path_img/users/${userList[0]['user_image']}"),
                                  ),
                                ),
                              ),
                        SizedBox(width: width * 0.02),
                        Column(
                          children: [
                            AutoText2(
                              width: width * 0.35,
                              text:
                                  "${userList[0]['first_name']} ${userList[0]['last_name']}",
                              fontSize: 16,
                              color: Colors.white,
                              text_align: TextAlign.left,
                              fontWeight: null,
                            ),
                            AutoText2(
                              width: width * 0.35,
                              text: "${userList[0]['email']}",
                              fontSize: 14,
                              color: Colors.grey.shade300,
                              text_align: TextAlign.left,
                              fontWeight: null,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget BuildListTile(
      context, String? img, String? title, Widget? page, double? width2) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () async {
        if (title == "Change Menu") {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('store_id', "");
        } else if (title == "Logout") {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear();
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return page!;
        }));
      },
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: Row(
            children: [
              Image.asset(
                "$img",
                width: width * 0.08,
                height: height * 0.08,
                color: Colors.white,
              ),
              SizedBox(width: width * 0.055),
              AutoText(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                text: '$title',
                text_align: TextAlign.left,
                width: width * width2!,
              ),
            ],
          ),
        ),
      ),
    );
  }

//only home
  Widget buildDrawerItems(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: DrawerItems.all
          .map(
            (item) => SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: Row(
                  children: [
                    Image.asset(
                      item.img,
                      width: width * 0.08,
                      height: height * 0.08,
                      color: Colors.white,
                    ),
                    SizedBox(width: width * 0.055),
                    AutoText(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      text: item.title,
                      text_align: TextAlign.left,
                      width: width * 0.12,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class DrawerMenuWidget extends StatelessWidget {
  final VoidCallback onClicked;
  const DrawerMenuWidget({Key? key, required this.onClicked}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () {
        onClicked();
      },
    );
  }
}

class DrawerItem {
  final String title;
  final String img;
  DrawerItem({required this.img, required this.title});
}

class DrawerItems {
  static DrawerItem home =
      DrawerItem(title: 'Home', img: "assets/images/home.png");

  static final List<DrawerItem> all = [
    home,
  ];
}
