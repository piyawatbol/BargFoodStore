import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:barg_store_app/screen/login_system/login_screen.dart';
import 'package:barg_store_app/screen/login_system/select_store/select_store_screen.dart';
import 'package:barg_store_app/screen/myPage.dart';
import 'package:page_transition/page_transition.dart'; // อย่าลืมตัวนี้
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? user_id;
  String? store_id;
  get_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = preferences.getString('user_id');
      store_id = preferences.getString('store_id');
    });
    print(user_id);
    print(store_id);
  }

  @override
  void initState() {
    get_user();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: SizedBox(
            width: 1000,
            height: 1000,
            child: Image.asset("assets/images/logo.png")),
      ),
      nextScreen: user_id == null || user_id == ''
          ? LoginScreen()
          : store_id == null || store_id == ''
              ? SelectStoreScreen()
              : MyPage(),
      splashIconSize: 200,
      backgroundColor: Color(0xff85BFF4),
      duration: 2000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.topToBottom,
    );
  }
}
