import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Setting/ReminderPage.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool isSoundOn = false;
  bool isVibrationOn = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  //#region InitState , dispose
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    _loadPreferences();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  //#endregion

  //#region Load and Save Preferences
  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSoundOn = prefs.getBool('isSoundOn') ?? true;
      isVibrationOn = prefs.getBool('isVibrationOn') ?? true;
    });
  }

  Future<void> _savePreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
  //#endregion

  //#region Page UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isNightModeOn;

    return Theme(
      data: isDarkMode ? _darkTheme() : _lightTheme(),
      child: Scaffold(
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: isDarkMode
                  ? Color(0xFF1F1F1F)
                  : Color(0xFFF5F9FC),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDarkMode
                          ? [Color(0xFF2C3E50), Color(0xFF1F1F1F)]
                          : [Color(0xFFE0F7FA), Color(0xFFC5CAE9)],
                    ),
                  ),
                ),
              ),
              // actions: [
              //   IconButton(
              //     icon: Icon(
              //       isDarkMode ? CupertinoIcons.sun_max : CupertinoIcons.moon_stars,
              //       color: isDarkMode ? Colors.amber : Colors.blueGrey,
              //     ),
              //     onPressed: () {
              //       themeProvider.toggleNightMode(!isDarkMode);
              //     },
              //   ),
              // ],
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _animation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('General', isDarkMode),
                      SizedBox(height: 8),
                      _buildToggleOption(
                        title: 'Sound',
                        subtitle: 'Play sounds for notifications and actions',
                        icon: Icons.volume_up_rounded,
                        initialValue: isSoundOn,
                        isDarkMode: isDarkMode,
                        onChanged: (bool value) {
                          setState(() {
                            isSoundOn = value;
                          });
                          _savePreference('isSoundOn', value);
                        },
                      ),
                      _buildToggleOption(
                        title: 'Vibration',
                        subtitle: 'Haptic feedback for interactions',
                        icon: Icons.vibration,
                        initialValue: isVibrationOn,
                        isDarkMode: isDarkMode,
                        onChanged: (bool value) {
                          setState(() {
                            isVibrationOn = value;
                          });
                          _savePreference('isVibrationOn', value);
                        },
                      ),
                      _buildToggleOption(
                        title: 'Dark Mode',
                        subtitle: 'Switch between light and dark theme',
                        icon: isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                        initialValue: isDarkMode,
                        isDarkMode: isDarkMode,
                        onChanged: (bool value) {
                          themeProvider.toggleNightMode(value);
                        },
                      ),
                      SizedBox(height: 24),
                      _buildSectionHeader('Personalization', isDarkMode),
                      SizedBox(height: 8),
                      _buildNavigationOption(
                        title: 'Reminders',
                        subtitle: 'Set up daily study reminders',
                        icon: Icons.notifications_active,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 24),
                      _buildSectionHeader('About & Support', isDarkMode),
                      SizedBox(height: 8),
                      _buildNavigationOption(
                        title: 'Privacy Policy',
                        subtitle: 'How we handle your data',
                        icon: Icons.security,
                        isDarkMode: isDarkMode,
                      ),
                      _buildNavigationOption(
                        title: 'Share App',
                        subtitle: 'Invite friends to learn with you',
                        icon: Icons.share,
                        isDarkMode: isDarkMode,
                      ),
                      _buildNavigationOption(
                        title: 'Rate Us',
                        subtitle: 'Love the app? Let us know!',
                        icon: Icons.star,
                        isDarkMode: isDarkMode,
                      ),
                      _buildNavigationOption(
                        title: 'Send Feedback',
                        subtitle: 'Help us improve the app',
                        icon: Icons.feedback,
                        isDarkMode: isDarkMode,
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Version 1.0.0',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //#endregion

  //#region Theme
  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Color(0xFFF5F9FC),
      cardColor: Colors.white,
      dividerColor: Colors.grey.shade200,
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.tealAccent,
      scaffoldBackgroundColor: Color(0xFF121212),
      cardColor: Color(0xFF252525),
      dividerColor: Colors.grey.shade800,
    );
  }
  //#endregion

  //#region Helper Widgets

  //#region Section Header
  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: isDarkMode
              ? Colors.tealAccent
              : Colors.blue.shade700,
        ),
      ),
    );
  }
  //#endregion

  //#region Toggle Option
  Widget _buildToggleOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool initialValue,
    required bool isDarkMode,
    required Function(bool) onChanged,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      color: isDarkMode ? Color(0xFF252525) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.grey.shade800
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDarkMode ? Colors.tealAccent : Colors.blue,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDarkMode
                  ? Colors.grey.shade400
                  : Colors.grey.shade700,
            ),
          ),
          trailing: Switch.adaptive(
            value: initialValue,
            onChanged: onChanged,
            activeColor: isDarkMode ? Colors.tealAccent : Colors.blue,
          ),
        ),
      ),
    );
  }
  //#endregion

  //#region Navigation Option
  Widget _buildNavigationOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isDarkMode,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode
              ? Colors.grey.shade800
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      color: isDarkMode ? Color(0xFF252525) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AlarmPage()));
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey.shade800
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDarkMode ? Colors.tealAccent : Colors.blue,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode
                    ? Colors.grey.shade400
                    : Colors.grey.shade700,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDarkMode
                  ? Colors.grey.shade400
                  : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
  //#endregion
  //#endregion
}

//#region Theme Provider class
class ThemeProvider extends ChangeNotifier {
  bool _isNightModeOn = false;

  bool get isNightModeOn => _isNightModeOn;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleNightMode(bool value) {
    _isNightModeOn = value;
    _saveTheme(value);

    notifyListeners();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isNightModeOn = prefs.getBool('isNightModeOn') ?? false;
    notifyListeners();
  }

  Future<void> _saveTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNightModeOn', value);
  }
}
//#endregion
