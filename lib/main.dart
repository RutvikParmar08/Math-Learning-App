//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'HomePage.dart';
// import 'ReminderPage.dart';
// import 'Setting.dart';
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones();
//   // await initializeNotifications();
//   runApp(
//
//     ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         brightness: themeProvider.isNightModeOn ? Brightness.dark : Brightness.light,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//           brightness: themeProvider.isNightModeOn ? Brightness.dark : Brightness.light,
//         ),
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//       debugShowMaterialGrid: false,
//       home: MathBlastHomePage(),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'HomePage.dart';
import 'LocalNotifications.dart';
import 'Setting.dart';

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  tz.initializeTimeZones();
  // await initializeNotifications();

  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

  // Handle notifications when app is launched from a terminated state
  final initialNotification =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    final payload = initialNotification?.notificationResponse?.payload;
    if (payload != null) {
      // Delay to ensure navigator is ready
      Future.delayed(const Duration(seconds: 1), () {
        final context = navigatorKey.currentContext;
        if (context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      });
    }
  }



  runApp(

    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: themeProvider.isNightModeOn ? Brightness.dark : Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: themeProvider.isNightModeOn ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: MathBlastHomePage(),
    );
  }
}
