import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('\x1B[31mTitle: ${message.notification!.title}');
  print('Body: ${message.notification!.body}');
  print('Payload: ${message.data}');

  // split the message.data.location by '_' to get the latitude and longitude
  final location = message.data['location'];

  final latitude = location.split('_')[0];
  final longitude = location.split('_')[1];

  print('Latitude: $latitude');
  print('Longitude: $longitude  \x1B[0m');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.subscribeToTopic('all');

    LocalNotificationService.initialize();

    print('\x1B[31m Token: ${await getToken()}\x1B[0m');

    FirebaseMessaging.onMessage.listen((message) {
      print('\x1B[31mTitle: ${message.notification!.title}');
      print('Body: ${message.notification!.body}');
      print('Payload: ${message.data} \x1B[0m');

      LocalNotificationService.displayNotificationOnForeground(message);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  //create a method to return the token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
