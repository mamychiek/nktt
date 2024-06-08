// ignore_for_file: unused_import

import 'package:blogger_api/blogger_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_notifications_demo/draw.dart';
import 'package:local_notifications_demo/html.dart';
import 'package:local_notifications_demo/page.dart';
import 'package:local_notifications_demo/view/labels.dart';
import 'package:local_notifications_demo/main.dart';
import 'package:local_notifications_demo/view/post.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_notifications_demo/view/slider.dart';

class MyWidget extends StatefulWidget {
  final List<PostItemModel> posts;

  const MyWidget({
    super.key,
    required this.posts,
  });

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 54, 54, 53),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.amber.shade700),
          title: Text(
            " Noukchoott  FooD    نوكشوط فود",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white),
            textAlign: TextAlign.start,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(
                Icons.food_bank_outlined,
                color: Colors.amber.shade700,
                size: 35,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.restaurant_menu,
                color: Colors.amber.shade700,
                size: 35,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.contact_page,
                color: Colors.amber.shade700,
                size: 35,
              ),
            ),
          ]),
        ),
        drawer: MainDrawer(
          onSelectScreen: (String identifier) {
            Navigator.of(context).pop();
            if (identifier == 'filters') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => PageView(),
                ),
              );
            }
          },
          ontoggleMeal: (PostItemModel element) {},
        ),
        body: const TabBarView(
          children: [
            Center(
              child: PostPage(
                blogId: '2995008147071629568',
                apiKey: 'AIzaSyCmHaewGIXBcY-kn0W0d9SktbgmIxBFBKw',
                title: '',
              ),
            ),
            Center(
              child: Postlable(
                blogId: '2995008147071629568',
                apiKey: 'AIzaSyCmHaewGIXBcY-kn0W0d9SktbgmIxBFBKw',
                title: '',
              ),
            ),
            Center(
              child: PagesView(
                blogId: '2995008147071629568',
                apiKey: 'AIzaSyCmHaewGIXBcY-kn0W0d9SktbgmIxBFBKw',
              ),
            )
          ],
        ),
      ),
    );
  }
}
