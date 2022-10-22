import 'package:flutter/material.dart';

class AcceptedScreen extends StatefulWidget {
  AcceptedScreen({Key? key}) : super(key: key);

  @override
  State<AcceptedScreen> createState() => _AcceptedScreenState();
}

class _AcceptedScreenState extends State<AcceptedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Accepted List",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "รายละเอียดคำสั่งซื้อ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "คำสั่งซื้อที่ 1",
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                buildMenuList2(context, "1", "กระเพราไก่ไข่ดาว",
                                    "2", "120"),
                                buildMenuList2(
                                    context, "2", "ข้าวหมูกระเทียม", "1", "50"),
                                buildMenuList2(context, "3", "ข้าวไก่กระเทียม",
                                    "3", "120"),
                                buildMenuList2(
                                    context, "4", "ข้าวไ่ข่เจียว", "2", "120"),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [Text("รวม"), Text("410 บาท")],
                                )
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                      color: Color(0xffFFD646),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                      child: Text(
                                    "กำลังรอคนขับ",
                                    style: TextStyle(fontSize: 22),
                                  )),
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildMenuList2(
      context, String? number, String? name, String? count, String? price) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.43,
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(number.toString()), Text(name.toString())],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
          height: 20,
          child: Text(
            count.toString(),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          height: 20,
          child: Text(
            price.toString(),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
