// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:blogger_api/blogger_api.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:local_notifications_demo/html.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: library_prefixes
import 'package:html/parser.dart' as htmlParser;
import 'package:local_notifications_demo/main.dart';
import 'package:local_notifications_demo/view/tapbar.dart';
import 'package:local_notifications_demo/welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

String key = 'AIzaSyCmHaewGIXBcY-kn0W0d9SktbgmIxBFBKw';
List<String> blogIds = ['1516663059969642739'];
Future<List<BlogsModel>> getAllBlogs() async {
  final res = await BloggerAPI().getAllBlogs(apiKey: key, blogId: blogIds);

  return res;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blogs Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.grey,
        primaryColorDark: Color.fromARGB(255, 0, 0, 0),
        primarySwatch: Colors.red,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: isviewed != 0
          ? welcome()
          : MyWidget(
              posts: [],
            ),
    );
  }
}

class PostPage extends StatefulWidget {
  final String blogId;
  final String apiKey;
  const PostPage({
    super.key,
    required this.blogId,
    required this.apiKey,
    required String title,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

String extractImageUrlFromHtml(String htmlContent) {
  final document = htmlParser.parse(htmlContent);
  final imgElement = document.querySelector('img');
  return imgElement != null ? imgElement.attributes['src'] ?? '' : '';
}

class _PostPageState extends State<PostPage>
    with SingleTickerProviderStateMixin {
  Future<PostModel> getAllpost() async {
    final res = await BloggerAPI().getAllPostFromBlog(
      includeComment: true,
      blogId: widget.blogId,
      apiKey: widget.apiKey,
    );

    return res;
  }

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 1,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: FutureBuilder(
            future: getAllpost(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    children: [
                      Text(
                        " اتصل بالانترنت",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Try Again'),
                );
              } else {
                List<Widget> postItems = [];
                // Loop through the fetched data and create post items
                for (var post in snapshot.data!.items!) {
                  var imageUrl = extractImageUrlFromHtml(post.content ?? '');
                  var title = post.title ?? '';
                  String cont = post!.content!;
                  postItems.add(
                    InkWell(
                      child: Card(
                        margin: const EdgeInsets.all(6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Stack(
                          children: [
                            Container(
                              child: imageUrl != null
                                  ? FadeInImage(
                                      placeholder: AssetImage("assets/p.png"),
                                      image: NetworkImage(imageUrl),
                                    )
                                  : Container(),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 44,
                                ),
                                color: Colors.black54,
                                child: Column(
                                  children: [
                                    Text(
                                      title!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(color: Colors.white70),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                postItems.shuffle();
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (ctx, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: const Offset(0, 0),
                      ).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeInOutExpo,
                        ),
                      ),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    child: GridView.builder(
                      itemCount: snapshot.data!.items!.length,
                      itemBuilder: (ctx, index) {
                        var post = snapshot.data!.items![index];
                        var imageUrl =
                            extractImageUrlFromHtml(post.content ?? '');
                        if (index == 0) {
                          return SingleChildScrollView(
                              child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HTMLVIew(
                                          data: snapshot.data!.items![index],
                                        )),
                              );
                            },
                            child: CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 1,
                              ),
                              items: postItems,
                            ),
                          ));
                        } else {
                          return Center(
                            child: Card(
                                margin: const EdgeInsets.all(6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HTMLVIew(
                                                data: snapshot
                                                    .data!.items![index],
                                              )),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsetsDirectional.all(0),
                                    child: Stack(
                                      children: [
                                        imageUrl != null
                                            ? FadeInImage(
                                                placeholder:
                                                    AssetImage("assets/p.png"),
                                                image: NetworkImage(
                                                  imageUrl,
                                                ),
                                                fit: BoxFit.cover,
                                                width: 1000,
                                                height: 1000,
                                              )
                                            : Container(
                                                //         height: double.infinity/ 2 ,
                                                ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          left: 0,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                              horizontal: 44,
                                            ),
                                            color: Colors.black54,
                                            child: Column(
                                              children: [
                                                Text(
                                                  snapshot.data!.items![index]
                                                      .title!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                          color:
                                                              Colors.white70),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        }
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        // number of items in each row
                        // spacing between rows
                        crossAxisCount: 1,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        childAspectRatio: 1 / 1,
                      ),
                    ),
                  ),
                );
              }
            })),
      ),
    );
  }
}
