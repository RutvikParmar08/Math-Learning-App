import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();
  static int _notificationIdCounter = 2;
  static final List<Map<String, dynamic>> _activeAlarms = [];
  static final List<int> _fourHourNotificationIds = [];

  // Notification messages for 4-hour notifications (from AlarmPage)
  static final List<String> _notificationMessages = [
    'Ready to solve some puzzles? 🧠✨',
    'Math magic is just a tap away! 🔢🪄',
    'Let\'s play with numbers today! 🎲➗',
    'Challenge yourself – try a new level! 🚀',
    'It\'s a great day for a math duel! ⚔️',
    'Sharpen your mind with a quick sum! ➕',
    'Numbers are fun, let\'s go! 🎉',
    'Break time? Or game time? You choose! ⏱️🎮',
    'Try a word problem and be a math wizard! 📚🧙‍♂️',
    'Stretch your brain – go solve something cool! 🧩💥',
  ];

  static Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_alarms', jsonEncode(_activeAlarms));
  }

  static Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getString('active_alarms');
    if (alarmsJson != null) {
      _activeAlarms.clear();
      final List<dynamic> decoded = jsonDecode(alarmsJson);
      _activeAlarms.addAll(decoded.cast<Map<String, dynamic>>());
    }
  }

  static Future<void> onNotificationTap(NotificationResponse response) async {
    final String? payload = response.payload;
    if (payload != null) {
      onClickNotification.add(payload);
    }
  }

  static Future<void> init() async {
    await _loadAlarms();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();
    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (status.isDenied) {
        try {
          final intent = AndroidIntent(
            action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
            flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await intent.launch();
        } catch (e) {
          await openAppSettings();
        }
      }
    }

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    // Schedule 4-hour notifications automatically during init
    await _scheduleEveryFourHoursNotification();
  }

  static Future<void> _scheduleEveryFourHoursNotification() async {
    try {
      // Initialize timezone
      tz.initializeTimeZones();

      // Clear existing 4-hour notifications
      await _cancelFourHourNotifications();

      // Create notification channel
      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'channel_id_4hour',
            '4-Hour Notification Channel',
            description: 'Channel for notifications every 4 hours',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            showBadge: true,
          ),
        );
      }

      // Check permissions
      bool notificationsEnabled = true;
      if (androidPlugin != null) {
        notificationsEnabled = await androidPlugin.requestNotificationsPermission() ?? false;
      }
      final exactAlarmStatus = await Permission.scheduleExactAlarm.status;

      if (!notificationsEnabled || exactAlarmStatus.isDenied) {
        // Permissions are required for scheduling; skip if not granted
        return;
      }

      // Schedule notifications every 4 hours
      final now = tz.TZDateTime.now(tz.local);
      final startTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        now.hour,
        0,
      ).add(Duration(hours: 4 - (now.hour % 4))); // Align to next 4-hour mark

      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id_4hour',
          '4-Hour Notification Channel',
          channelDescription: 'Channel for notifications every 4 hours',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          playSound: true,
          enableVibration: true,
          channelShowBadge: true,
        ),
      );

      // Schedule for 24 hours (6 notifications: 0, 4, 8, 12, 16, 20)
      for (int i = 0; i < 6; i++) {
        final notificationId = _notificationIdCounter++;
        final scheduleTime = startTime.add(Duration(hours: i * 4));
        final message = (_notificationMessages..shuffle()).first;

        await _flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          'Reminder',
          message,
          scheduleTime,
          notificationDetails,
          androidScheduleMode: exactAlarmStatus.isGranted
              ? AndroidScheduleMode.exactAllowWhileIdle
              : AndroidScheduleMode.inexactAllowWhileIdle,
          payload: 'four_hour_notification',
          matchDateTimeComponents: DateTimeComponents.time,
        );

        _fourHourNotificationIds.add(notificationId);
      }
    } catch (e) {
      // Handle error silently to avoid user disruption
    }
  }

  static Future<void> _cancelFourHourNotifications() async {
    try {
      for (var id in _fourHourNotificationIds) {
        await _flutterLocalNotificationsPlugin.cancel(id);
      }
      _fourHourNotificationIds.clear();
    } catch (e) {
      // Handle error silently
    }
  }

  static Future<int> showDailyNotificationAtTime({
    required String title,
    required String body,
    required String payload,
    required TimeOfDay time,
    required BuildContext context,
  }) async {
    try {
      tz.initializeTimeZones();

      final now = DateTime.now();
      var scheduleTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour-5,
        time.minute-30,
      );
      if (scheduleTime.isBefore(tz.TZDateTime.now(tz.local))) {
        scheduleTime = scheduleTime.add(const Duration(days: 1));
      }

      final notificationId = _notificationIdCounter++;

      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'channel_id_1',
            'Daily Alarm Channel',
            description: 'Channel for daily alarms at specific times',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            showBadge: true,
          ),
        );
      }

      bool notificationsEnabled = true;
      if (androidPlugin != null) {
        notificationsEnabled = await androidPlugin.requestNotificationsPermission() ?? false;
      }
      final exactAlarmStatus = await Permission.scheduleExactAlarm.status;

      if (!notificationsEnabled) {
        notificationsEnabled = await androidPlugin?.requestNotificationsPermission() ?? false;
        if (!notificationsEnabled) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable notifications in settings')),
          );
          await openAppSettings();
          return -1;
        }
      }
      if (exactAlarmStatus.isDenied) {
        final status = await Permission.scheduleExactAlarm.request();
        if (status.isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enable exact alarms in settings')),
          );
          try {
            final intent = AndroidIntent(
              action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
              flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
            );
            await intent.launch();
          } catch (e) {
            await openAppSettings();
          }
          return -1;
        }
      }

      const androidDetails = AndroidNotificationDetails(
        'channel_id_1',
        'Daily Alarm Channel',
        channelDescription: 'Channel for daily alarms at specific times',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
        enableVibration: true,
        channelShowBadge: true,
      );
      const notificationDetails = NotificationDetails(android: androidDetails);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        scheduleTime,
        notificationDetails,
        androidScheduleMode: exactAlarmStatus.isGranted
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      _activeAlarms.add({
        'id': notificationId,
        'title': title,
        'time': time.format(context),
      });
      await _saveAlarms();
      return notificationId;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to schedule notification: $e')),
      );
      return -1;
    }
  }

  static List<Map<String, dynamic>> getActiveAlarms() => _activeAlarms;

  static Future cancel(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      _activeAlarms.removeWhere((alarm) => alarm['id'] == id);
      await _saveAlarms();
    } catch (e) {
      // Handle error silently
    }
  }

  static Future cancelAll() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      _activeAlarms.clear();
      _fourHourNotificationIds.clear();
      await _saveAlarms();
    } catch (e) {
      // Handle error silently
    }
  }
}