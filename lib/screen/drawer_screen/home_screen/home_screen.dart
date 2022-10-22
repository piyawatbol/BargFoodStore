// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable, must_be_immutable
import 'package:barg_store_app/screen/drawer_screen/cencel_creen/cencel_creen.dart';
import 'package:barg_store_app/screen/drawer_screen/drawer_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback openDrawer;

  HomeScreen({required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Order",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom:
            PreferredSize(preferredSize: Size.fromHeight(7), child: SizedBox()),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        centerTitle: true,
        leading: DrawerMenuWidget(
          onClicked: () {
            openDrawer();
          },
        ),
        backgroundColor: Color(0xFF73AEF5),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 3,
                                blurRadius: 3,
                                offset: Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("คำสั่งซื้อที่  1"),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("รายการอาหาร"),
                                          Text("จำนวน"),
                                          Text("ราคา"),
                                        ],
                                      ),
                                      buildMenuList(context, "1",
                                          "กระเพราไก่ไข่ดาว", "2", "120"),
                                      buildMenuList(context, "2",
                                          "ข้าวหมูกระเทียม", "1", "50"),
                                      buildMenuList(context, "3",
                                          "ข้าวไก่กระเทียม", "3", "120"),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Row(
                                          children: [
                                            Text(
                                              "กดตรวจสอบเพื่อดูรายการเพิ่มเติม",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.yellow,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  SimpleDialog(
                                                    title: Text(
                                                        "รายละเอียดคำสั่งซื้อ"),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30)),
                                                    ),
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.6,
                                                        child: Column(
                                                          children: [
                                                            buildMenuList2(
                                                                context,
                                                                "1",
                                                                "กระเพราไก่ไข่ดาว",
                                                                "2",
                                                                "120"),
                                                            buildMenuList2(
                                                                context,
                                                                "2",
                                                                "ข้าวหมูกระเทียม",
                                                                "1",
                                                                "50"),
                                                            buildMenuList2(
                                                                context,
                                                                "3",
                                                                "ข้าวไก่กระเทียม",
                                                                "3",
                                                                "120"),
                                                            buildMenuList2(
                                                                context,
                                                                "4",
                                                                "ข้าวไข่เจียว",
                                                                "2",
                                                                "120"),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 20,
                                                                  horizontal:
                                                                      20),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text("รวม"),
                                                                  Text("410")
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.7,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.35,
                                                              child: Image.asset(
                                                                  "assets/images/saleep.jpeg"),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                Colors.green,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30)),
                                                            ),
                                                          ),
                                                          onPressed: () {},
                                                          child: Text('ยอมรับ'),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                Colors.red,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30)),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pushReplacement(
                                                                context,
                                                                MaterialPageRoute(builder:
                                                                    (BuildContext
                                                                        context) {
                                                              return CencelScreen();
                                                            }));
                                                          },
                                                          child: Text('ยกเลิก'),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                Colors.blue,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30)),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child:
                                                              Text('ย้อนกลับ'),
                                                        ),
                                                      )
                                                    ],
                                                  ));
                                        },
                                        child: Text('ตรวจสอบ'),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.green,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text('ยอมรับ'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  buildMenuList(
      context, String? number, String? name, String? count, String? price) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.38,
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
          width: MediaQuery.of(context).size.width * 0.22,
          height: 20,
          child: Text(
            price.toString(),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  buildMenuList2(
      context, String? number, String? name, String? count, String? price) {
    return Row(
      children: [
        SizedBox(
          // color: Colors.yellow,
          width: MediaQuery.of(context).size.width * 0.08,
          height: 20,
          child: Text(
            number.toString(),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(
          // color: Colors.red,
          width: MediaQuery.of(context).size.width * 0.35,
          height: 29,
          child: Text(
            name.toString(),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(
          //  color: Colors.blue,
          width: MediaQuery.of(context).size.width * 0.14,
          height: 20,
          child: Text(
            count.toString(),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(
          //  color: Colors.green,
          width: MediaQuery.of(context).size.width * 0.20,
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
