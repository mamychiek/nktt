// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_notifications_demo/main.dart';
import 'package:local_notifications_demo/view/tapbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class welcome extends StatelessWidget {
  const welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.grey,
        primaryColorDark: Color.fromARGB(255, 0, 0, 0),
        primarySwatch: Colors.amber,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const boarding(),
    );
  }
}

class boarding extends StatefulWidget {
  const boarding({super.key});

  @override
  State<boarding> createState() => _walcomeState();
}

class _walcomeState extends State<boarding> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  storeOnboardingInfo() async {
    int isviewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('welcome', isviewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              page1(),
              page2(),
              page3(),
            ],
          ),
          Container(
              alignment: const Alignment(0, 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  onLastPage
                      ? GestureDetector(
                          child: const Text(
                            " انهاء",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onTap: () async {
                            await storeOnboardingInfo();
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const MyWidget(
                                  posts: [],
                                ),
                              ),
                            );
                          },
                        )
                      : GestureDetector(
                          child: const Text(
                            " التالي",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                        ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                  ),
                  GestureDetector(
                    child: const Icon(Icons.skip_previous),
                    onTap: () async {
                      await storeOnboardingInfo();

                      _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const MyWidget(
                            posts: [],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class page1 extends StatelessWidget {
  const page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 54, 54, 53),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "تطبيق نوكشوط فوود هو تطبيق يتيح للمستخدمين استعراض قوائم المطاعم  و وجبات في منطقتهم",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Image(
                  image: AssetImage("assets/1.png"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class page2 extends StatelessWidget {
  const page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 54, 54, 53),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    " تطبيق نوكشوط فوود هو منصة رقمية تسمح للمطاعم بإدارة أعمالها بشكل فعال، حيث يمكنها عرض قوائم الطعام الخاصة بها،",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Image(
                image: AssetImage("assets/2.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class page3 extends StatelessWidget {
  const page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      color: const Color.fromARGB(255, 54, 54, 53),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "  تطبيق يسمح للمستخدمين بتصفح قوائم المطاعم المحلية وتواصل مع المطاعم",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Image(
                image: AssetImage("assets/3.png"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
