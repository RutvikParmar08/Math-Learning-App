import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'MathOperations.dart';
import 'Setting.dart';

//#region Grade Page
class GradePage extends StatelessWidget {
  final List<Map<String, dynamic>> grades = [
    {"grade": "Grade 1", "icon": Icons.looks_one},
    {"grade": "Grade 2", "icon": Icons.looks_two},
    {"grade": "Grade 3", "icon": Icons.looks_3},
    {"grade": "Grade 4", "icon": Icons.looks_4},
    {"grade": "Grade 5", "icon": Icons.looks_5_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    // Get theme from provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isNightModeOn;

    // Theme-aware colors
    final cardColors = [
      isDarkMode ? Color(0xFFE91E63) : Color(0xFFFF4D79), // Pink
      isDarkMode ? Color(0xFF00C853) : Color(0xFF2ECB71), // Green
      isDarkMode ? Color(0xFF2196F3) : Color(0xFF3498DB), // Blue
      isDarkMode ? Color(0xFF9C27B0) : Color(0xFFAB4BDB), // Purple
      isDarkMode ? Color(0xFFFF9800) : Color(0xFFFFAB40), // Orange
    ];

    // Background gradient
    final backgroundGradient = isDarkMode
        ? [Color(0xFF121212), Color(0xFF262626)]
        : [Color(0xFFE0F2F1), Color(0xFFB2DFDB)];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [Color(0xFF2C3E50), Color(0xFF1A2533)]
                  : [Color(0xFF4A89DC), Color(0xFF5C97D6)],
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.blue.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 26,
            ),
            SizedBox(width: 10),
            Text(
              'Choose Your Grade',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
            splashRadius: 20,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                  child: Text(
                    'Select a grade level to begin',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      return GradeCard(
                        grade: grades[index]["grade"],
                        color: cardColors[index],
                        icon: grades[index]["icon"],
                        isDarkMode: isDarkMode,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder: (_, __, ___) => MathOperationsPage(
                                gradeNumber: index + 1,
                              ),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                    opacity: animation,
                                    child: child
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//#endregion

//#region Grade Card
class GradeCard extends StatelessWidget {
  final String grade;
  final Color color;
  final IconData icon;
  final bool isDarkMode;
  final VoidCallback onTap;

  const GradeCard({
    required this.grade,
    required this.color,
    required this.icon,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      splashColor: color.withOpacity(0.3),
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withBlue((color.blue + 40).clamp(0, 255)),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isDarkMode ? 0.4 : 0.3),
              blurRadius: 12,
              spreadRadius: -2,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -10,
              top: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                        icon,
                        size: 32,
                        color: Colors.white
                    ),
                  ),
                  Spacer(),
                  Text(
                    grade,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap to start',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//#endregion