import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:recall/services/notification_helper.dart';

class ScheduledNotificationsScreen extends StatefulWidget {
  const ScheduledNotificationsScreen({super.key});

  @override
  State<ScheduledNotificationsScreen> createState() =>
      _ScheduledNotificationsScreenState();
}

class _ScheduledNotificationsScreenState
    extends State<ScheduledNotificationsScreen> {
  List<PendingNotificationRequest> pendingNotifications = [];
  final NotificationHelper notificationHelper = NotificationHelper();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationHelper.getPendingNotifications().then((value) => {
            setState(() {
              pendingNotifications = value;
              _initialized = true;
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Notifications"),
      ),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pendingNotifications.length,
              itemBuilder: (context, index) {
                final notification = pendingNotifications[index];
                return ListTile(
                  title: Text("ID: ${notification.id}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title: ${notification.title}"),
                      Text("Body: ${notification.body}"),
                      Text("Schedule Date: ${notification.payload}"),
                      //Text(
                      //    "Schedule Date: ${DateTime.parse(notification.payload ?? '').toLocal().toString()}"),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
