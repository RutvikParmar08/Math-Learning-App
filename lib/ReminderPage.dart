// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:math';
//
// import 'LocalNotifications.dart';
//
// class AlarmPage extends StatefulWidget {
//   const AlarmPage({super.key});
//
//   @override
//   State<AlarmPage> createState() => _AlarmPageState();
// }
//
// class _AlarmPageState extends State<AlarmPage> with TickerProviderStateMixin {
//   final _bodyController = TextEditingController();
//   TimeOfDay _selectedTime = TimeOfDay.now();
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//   List<Map<String, dynamic>> alarms = [];
//
//   final List<String> notificationMessages = [
//     'Ready to solve some puzzles? 🧠✨',
//     'Math magic is just a tap away! 🔢🪄',
//     'Let\'s play with numbers today! 🎲➗',
//     'Challenge yourself – try a new level! 🚀',
//     'It\'s a great day for a math duel! ⚔️',
//     'Sharpen your mind with a quick sum! ➕',
//     'Numbers are fun, let\'s go! 🎉',
//     'Break time? Or game time? You choose! ⏱️🎮',
//     'Try a word problem and be a math wizard! 📚🧙‍♂️',
//     'Stretch your brain – go solve something cool! 🧩💥',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _loadAlarms();
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _bodyController.dispose();
//     super.dispose();
//   }
//
//   void _loadAlarms() {
//     setState(() {
//       alarms = LocalNotifications.getActiveAlarms();
//     });
//   }
//
//   Future<void> _checkAndShowDialog() async {
//     if (await Permission.scheduleExactAlarm.isDenied) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: Row(
//             children: [
//               Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
//               const SizedBox(width: 12),
//               const Text('Permission Required'),
//             ],
//           ),
//           content: const Text(
//             'To ensure precise notification timing, please allow exact alarms in settings.',
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Later', style: TextStyle(color: Colors.grey[600])),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await openAppSettings();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               child: const Text('Open Settings'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   Future<void> _pickTime() async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             timePickerTheme: TimePickerThemeData(
//               backgroundColor: Colors.white,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (pickedTime != null && mounted) {
//       setState(() {
//         _selectedTime = pickedTime;
//       });
//     }
//   }
//
//   Future<void> _addAlarm() async {
//     await _pickTime();
//
//     if (mounted) {
//       await _checkAndShowDialog();
//
//       String alarmBody = _bodyController.text.trim();
//       if (alarmBody.isEmpty) {
//         alarmBody = (notificationMessages..shuffle()).first;
//       }
//
//       final notificationId = await LocalNotifications.showDailyNotificationAtTime(
//         title: 'Reminder',
//         body: alarmBody,
//         payload: 'daily_alarm_data',
//         time: _selectedTime,
//         context: context,
//       );
//
//       if (mounted) {
//         if (notificationId != -1) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   const Icon(Icons.check_circle, color: Colors.white),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'Alarm set for ${_selectedTime.format(context)} daily',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//               backgroundColor: Colors.green,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               duration: const Duration(seconds: 3),
//             ),
//           );
//           _bodyController.clear();
//           _loadAlarms(); // Refresh the alarms list
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Row(
//                 children: [
//                   const Icon(Icons.error, color: Colors.white),
//                   const SizedBox(width: 8),
//                   const Text('Failed to set alarm', style: TextStyle(fontSize: 16)),
//                 ],
//               ),
//               backgroundColor: Colors.red,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             ),
//           );
//         }
//       }
//     }
//   }
//
//   void _deleteAlarm(Map<String, dynamic> alarm, int index) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: [
//               Icon(Icons.warning_amber_rounded,
//                   color: Colors.orange, size: 28),
//               const SizedBox(width: 12),
//               const Text('Delete Alarm'),
//             ],
//           ),
//           content: Text(
//             'Are you sure you want to delete "${alarm['title']}"?',
//             style: const TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () =>
//                   {
//                     Navigator.of(context).pop(),
//                     Navigator.of(context).pop(),
//                   },
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 LocalNotifications.cancel(alarm['id']);
//                 Navigator.of(context).pop();
//                 setState(() {
//                   alarms.removeAt(index);
//                 });
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Row(
//                       children: [
//                         const Icon(Icons.check_circle, color: Colors.white),
//                         const SizedBox(width: 8),
//                         Text('${alarm['title']} deleted successfully'),
//                       ],
//                     ),
//                     backgroundColor: Colors.green,
//                     behavior: SnackBarBehavior.floating,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black87,
//         title: const Text(
//           'Reminder',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Column(
//           children: [
//             // Add Alarm Section
//             Padding(
//               padding: const EdgeInsets.all(24.0),
//               child: Column(
//                 children: [
//                   ScaleTransition(
//                     scale: _scaleAnimation,
//                     child: Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Colors.blue[400]!, Colors.blue[600]!],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.3),
//                             blurRadius: 15,
//                             offset: const Offset(0, 8),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.alarm,
//                         size: 40,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: _bodyController,
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         hintText: 'What would you like to be reminded about?',
//                         hintStyle: TextStyle(
//                           color: Colors.grey[400],
//                           fontSize: 14,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                         contentPadding: const EdgeInsets.all(16),
//                         prefixIcon: Padding(
//                           padding: const EdgeInsets.all(12),
//                           child: Icon(
//                             Icons.edit_note,
//                             color: Colors.blue[400],
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                       style: const TextStyle(
//                         fontSize: 14,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   ScaleTransition(
//                     scale: _scaleAnimation,
//                     child: Container(
//                       width: double.infinity,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [Colors.blue[400]!, Colors.blue[600]!],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.3),
//                             blurRadius: 10,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(16),
//                           onTap: _addAlarm,
//                           child: const Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.add_alarm,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Add Daily Alarm',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Divider
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 24),
//               height: 1,
//               color: Colors.grey[200],
//             ),
//
//             // Active Alarms Section
//             Expanded(
//               child: alarms.isEmpty
//                   ? _buildEmptyState()
//                   : _buildAlarmsList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Colors.blue[50],
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.alarm_off,
//               size: 60,
//               color: Colors.blue[300],
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No Active Alarms',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Your alarms will appear here when you create them',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[500],
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAlarmsList() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Icon(Icons.alarm, color: Colors.blue[600], size: 20),
//               const SizedBox(width: 8),
//               Text(
//                 '${alarms.length} active alarm${alarms.length != 1 ? 's' : ''}',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemCount: alarms.length,
//             itemBuilder: (context, index) {
//               final alarm = alarms[index];
//               return AnimatedContainer(
//                 duration: Duration(milliseconds: 300 + (index * 50)),
//                 curve: Curves.easeOutBack,
//                 margin: const EdgeInsets.only(bottom: 12),
//                 child: Card(
//                   elevation: 2,
//                   shadowColor: Colors.black.withOpacity(0.1),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       gradient: LinearGradient(
//                         colors: [Colors.white, Colors.blue[50]!],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(16),
//                       leading: Container(
//                         width: 48,
//                         height: 48,
//                         decoration: BoxDecoration(
//                           color: Colors.blue[100],
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Icon(
//                           Icons.alarm,
//                           color: Colors.blue[700],
//                           size: 24,
//                         ),
//                       ),
//                       title: Text(
//                         alarm['title'],
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       subtitle: Container(
//                         margin: const EdgeInsets.only(top: 8),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.green[100],
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.repeat,
//                               color: Colors.green[700],
//                               size: 14,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               'Daily at ${alarm['time']}',
//                               style: TextStyle(
//                                 color: Colors.green[700],
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       trailing: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.red[50],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             Icons.delete_outline,
//                             color: Colors.red[600],
//                             size: 20,
//                           ),
//                           onPressed: () => _deleteAlarm(alarm, index),
//                           tooltip: 'Delete alarm',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'LocalNotifications.dart';
import 'Setting.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> with TickerProviderStateMixin {
  final _bodyController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  List<Map<String, dynamic>> alarms = [];

  final List<String> notificationMessages = [
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

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadAlarms();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _loadAlarms() {
    setState(() {
      alarms = LocalNotifications.getActiveAlarms();
    });
  }

  // Get theme-aware colors
  ColorScheme _getColorScheme(bool isDark) {
    return isDark
        ? const ColorScheme.dark(
      primary: Color(0xFF60A5FA),
      secondary: Color(0xFF3B82F6),
      surface: Color(0xFF1F2937),
      background: Color(0xFF111827),
      onBackground: Colors.white,
      onSurface: Colors.white,
    )
        : const ColorScheme.light(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF1D4ED8),
      surface: Colors.white,
      background: Color(0xFFF9FAFB),
      onBackground: Color(0xFF111827),
      onSurface: Color(0xFF111827),
    );
  }

  Future<void> _checkAndShowDialog() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final colorScheme = _getColorScheme(themeProvider.isNightModeOn);

    if (await Permission.scheduleExactAlarm.isDenied) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              Text(
                'Permission Required',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ],
          ),
          content: Text(
            'To ensure precise notification timing, please allow exact alarms in settings.',
            style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Later',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _pickTime() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: themeProvider.isNightModeOn
                  ? const Color(0xFF1F2937)
                  : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && mounted) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _addAlarm() async {
    await _pickTime();

    if (mounted) {
      await _checkAndShowDialog();

      String alarmBody = _bodyController.text.trim();
      if (alarmBody.isEmpty) {
        alarmBody = (notificationMessages..shuffle()).first;
      }

      final notificationId = await LocalNotifications.showDailyNotificationAtTime(
        title: 'Reminder',
        body: alarmBody,
        payload: 'daily_alarm_data',
        time: _selectedTime,
        context: context,
      );

      if (mounted) {
        if (notificationId != -1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Alarm set for ${_selectedTime.format(context)} daily',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 3),
            ),
          );
          _bodyController.clear();
          _loadAlarms();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text('Failed to set alarm', style: TextStyle(fontSize: 16)),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    }
  }

  void _deleteAlarm(Map<String, dynamic> alarm, int index) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final colorScheme = _getColorScheme(themeProvider.isNightModeOn);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              Text(
                'Delete Alarm',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${alarm['title']}"?',
            style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                LocalNotifications.cancel(alarm['id']);
                Navigator.of(context).pop();
                setState(() {
                  alarms.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        Text('${alarm['title']} deleted successfully'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final colorScheme = _getColorScheme(themeProvider.isNightModeOn);
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final isTablet = screenWidth > 600;
        final isLandscape = screenWidth > screenHeight;

        return Scaffold(
          backgroundColor: colorScheme.background,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: colorScheme.onBackground,
            title: Text(
              'Reminder',
              style: TextStyle(
                fontSize: isTablet ? 28 : 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            centerTitle: true,
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (isLandscape && isTablet) {
                  return _buildTabletLandscapeLayout(colorScheme, screenWidth);
                } else {
                  return _buildMobileLayout(colorScheme, screenWidth, isTablet);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(ColorScheme colorScheme, double screenWidth, bool isTablet) {
    return Column(
      children: [
        // Add Alarm Section
        _buildAddAlarmSection(colorScheme, screenWidth, isTablet),

        // Divider
        Container(
          margin: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 24),
          height: 1,
          color: colorScheme.onBackground.withOpacity(0.1),
        ),

        // Active Alarms Section
        Expanded(
          child: alarms.isEmpty
              ? _buildEmptyState(colorScheme, isTablet)
              : _buildAlarmsList(colorScheme, isTablet),
        ),
      ],
    );
  }

  Widget _buildTabletLandscapeLayout(ColorScheme colorScheme, double screenWidth) {
    return Row(
      children: [
        // Left side - Add Alarm Section
        Expanded(
          flex: 2,
          child: _buildAddAlarmSection(colorScheme, screenWidth / 2, true),
        ),

        // Divider
        Container(
          width: 1,
          margin: const EdgeInsets.symmetric(vertical: 24),
          color: colorScheme.onBackground.withOpacity(0.1),
        ),

        // Right side - Alarms List
        Expanded(
          flex: 3,
          child: alarms.isEmpty
              ? _buildEmptyState(colorScheme, true)
              : _buildAlarmsList(colorScheme, true),
        ),
      ],
    );
  }

  Widget _buildAddAlarmSection(ColorScheme colorScheme, double width, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: isTablet ? 100 : 80,
              height: isTablet ? 100 : 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.alarm,
                size: isTablet ? 50 : 40,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: isTablet ? 24 : 20),
          Container(
            constraints: BoxConstraints(maxWidth: isTablet ? 400 : double.infinity),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onBackground.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: _bodyController,
              maxLines: 3,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                height: 1.4,
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'What would you like to be reminded about?',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: isTablet ? 16 : 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surface,
                contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(isTablet ? 16 : 12),
                  child: Icon(
                    Icons.edit_note,
                    color: colorScheme.primary,
                    size: isTablet ? 24 : 20,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: isTablet ? 400 : double.infinity),
              height: isTablet ? 60 : 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _addAlarm,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_alarm,
                          color: Colors.white,
                          size: isTablet ? 24 : 20,
                        ),
                        SizedBox(width: isTablet ? 12 : 8),
                        Text(
                          'Add Daily Alarm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 32 : 24),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.alarm_off,
              size: isTablet ? 80 : 60,
              color: colorScheme.primary.withOpacity(0.6),
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Text(
            'No Active Alarms',
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground.withOpacity(0.8),
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),
          Text(
            'Your alarms will appear here when you create them',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: colorScheme.onBackground.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmsList(ColorScheme colorScheme, bool isTablet) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(isTablet ? 20.0 : 16.0),
          child: Row(
            children: [
              Icon(
                Icons.alarm,
                color: colorScheme.primary,
                size: isTablet ? 24 : 20,
              ),
              SizedBox(width: isTablet ? 12 : 8),
              Text(
                '${alarms.length} active alarm${alarms.length != 1 ? 's' : ''}',
                style: TextStyle(
                  color: colorScheme.onBackground.withOpacity(0.7),
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
            itemCount: alarms.length,
            itemBuilder: (context, index) {
              final alarm = alarms[index];
              return AnimatedContainer(
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.easeOutBack,
                margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
                child: Card(
                  elevation: 2,
                  shadowColor: colorScheme.onBackground.withOpacity(0.1),
                  color: colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.surface,
                          colorScheme.primary.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(isTablet ? 20 : 16),
                      leading: Container(
                        width: isTablet ? 56 : 48,
                        height: isTablet ? 56 : 48,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.alarm,
                          color: colorScheme.primary,
                          size: isTablet ? 28 : 24,
                        ),
                      ),
                      title: Text(
                        alarm['title'],
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Container(
                        margin: EdgeInsets.only(top: isTablet ? 12 : 8),
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 12 : 10,
                          vertical: isTablet ? 6 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.repeat,
                              color: Colors.green[700],
                              size: isTablet ? 16 : 14,
                            ),
                            SizedBox(width: isTablet ? 6 : 4),
                            Text(
                              'Daily at ${alarm['time']}',
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                                fontSize: isTablet ? 14 : 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red[600],
                            size: isTablet ? 24 : 20,
                          ),
                          onPressed: () => _deleteAlarm(alarm, index),
                          tooltip: 'Delete alarm',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}