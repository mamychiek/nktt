// ignore_for_file: unused_import, unused_local_variable, avoid_unnecessary_containers

import 'dart:typed_data';

import 'package:blogger_api/blogger_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart';
import 'package:local_notifications_demo/draw.dart';
import 'package:local_notifications_demo/html.dart';
// ignore: library_prefixes
import 'package:html/parser.dart' as htmlParser;
import 'package:local_notifications_demo/view/post.dart';
import 'package:local_notifications_demo/view/slider.dart';

class Postlable extends StatefulWidget {
  final String blogId;
  final String apiKey;
  const Postlable({
    super.key,
    required this.blogId,
    required this.apiKey,
    required String title,
  });

  @override
  State<Postlable> createState() => _PostlableState();
}

class _PostlableState extends State<Postlable>
    with SingleTickerProviderStateMixin {
  late Future<PostModel> _postModelFuture;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _postModelFuture = getAllPost();
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

  Future<PostModel> getAllPost() async {
    final res = await BloggerAPI().getAllPostFromBlog(
      includeComment: true,
      blogId: widget.blogId,
      apiKey: widget.apiKey,
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 54, 54, 53),
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
      body: FutureBuilder<PostModel>(
        future: _postModelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Try Again'),
            );
          }
          var allLabels = <String>[];
          for (var post in snapshot.data!.items!) {
            allLabels.addAll(post.labels!);
          }

          var seen = Set<String>();
          List<String> uniquelable =
              allLabels.where((country) => seen.add(country)).toList();
          var labelsCount = uniquelable.length;

          return AnimatedBuilder(
            animation: _controller,
            builder: (ctx, child) => SlideTransition(
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
            ),
            child: ListView.builder(
              itemCount: labelsCount,
              itemBuilder: (ctx, index) {
                var post = snapshot.data!.items!;
                var labels = uniquelable[index];
                return Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Display labels for the post
                        InkWell(
                          onTap: () {
                            // Filter posts based on the selected label
                            var Title = snapshot.data!.items![index].title!;
                            var postsWithLabel = snapshot.data!.items!
                                .where((post) => post.labels!.contains(labels))
                                .toList();

                            //Show list of items linked with labels
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostsWithLabelPage(
                                  title: Title,
                                  posts: postsWithLabel,
                                  label: labels,
                                ),
                              ),
                            );
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(),
                              child: Center(
                                  child: Card(
                                margin: const EdgeInsets.all(6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                clipBehavior: Clip.hardEdge,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/4.png',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 150,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Container(
                                        color: Colors.black54,
                                        child: Text(
                                          labels,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(color: Colors.white70),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                        ),

                        // Display the post content
                        // Add your post UI here
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PostsWithLabelPage extends StatelessWidget {
  final List<PostItemModel> posts;
  final String label;

  const PostsWithLabelPage({
    Key? key,
    required this.posts,
    required this.label,
    required title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts with Label: $label'),
      ),
      body: GridView.builder(
        itemCount: posts.length,
        itemBuilder: (ctx, index) {
          var imageUrl = extractImageUrlFromHtml(posts[index].content ?? '');

          var post = posts[index];
          // Display each post in the list
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HTMLVIew(
                          data: posts![index],
                        )),
              );
            },
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
                      child: Column(children: [
                        Text(
                          post.title!,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.white70),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        )
                      ]),
                    )),
              ],
            ),

            // Add onTap to navigate to post details or do other actions
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          // number of items in each row
          // spacing between rows
          crossAxisCount: 2,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
          childAspectRatio: 1 / 1,
        ),
      ),
    );
  }
}
