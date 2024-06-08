import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('توصل معنا'),
      ),
      body: const Center(
        child: Center(
          child: Text(
              "   num : 34664141 0r mamybhwr@gmail.con KMC APPS    توصل معنا",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
        ),
      ),
    );
  }
}

class OtherAppPage extends StatelessWidget {
  const OtherAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' تطبيقات'),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          _launchPlayStore();
        },
        child: const Text(
          "Open Google Chrome in Play Store ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      )),
    );
  }
}

_launchPlayStore() async {
  const String packageName =
      "kmc  apps"; // Replace with the desired app's package name
  const url = 'https://play.google.com/store/search?q=pub%3Akmcapps&c=apps';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
