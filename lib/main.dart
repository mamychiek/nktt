import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:local_notifications_demo/view/post.dart';
import 'package:local_notifications_demo/welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isviewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('welcome');
  AwesomeNotifications().initialize('resource://drawable/launch_background', [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic notifications',
      channelDescription: 'Notification channel for basic notifications',
      defaultColor: const Color(0xFF9D50DD),
      ledColor: Colors.white,
    )
  ]);
  // Schedule the daily notification
  runApp(const MyApp());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Initialize Awesome Notifications
    AwesomeNotifications().initialize('resource://drawable/launch_background', [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ]);
    // Schedule the daily notification
    _scheduleDailyNotification();
  }

  // Function to schedule the daily notification
  void _scheduleDailyNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: ' nouakchoot food',
        body: ' fast food!',
      ),
      schedule: NotificationInterval(
        interval: 24, // 24 hours interval for daily notification
        repeats: true,
        allowWhileIdle: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'VIEW',
          label: 'View',
        )
      ],
    );
    print('Daily notification scheduled!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Notifications'),
      ),
      body: const Center(
        child: Text('Daily Notifications will be sent every day at 8 AM.'),
      ),
    );
  }
}
