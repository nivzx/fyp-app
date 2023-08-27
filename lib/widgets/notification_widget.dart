import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  List<RemoteMessage> _notifications = [];

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _configureFirebaseMessaging();
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _notifications.add(message);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            // Simulate sending a notification using Firebase Cloud Messaging
            await _firebaseMessaging.subscribeToTopic('exampleTopic');
          },
          child: Text('Subscribe to Topic'),
        ),
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              RemoteMessage message = _notifications[index];
              return ListTile(
                title: Text(message.notification?.title ?? ''),
                subtitle: Text(message.notification?.body ?? ''),
              );
            },
          ),
        ),
      ],
    );
  }
}
