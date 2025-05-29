import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'GamePage.dart';
import 'GradePage.dart';
import 'Setting.dart';

//#region Main Home Page
class MathBlastHomePage extends StatefulWidget {
  @override
  _MathBlastPageState createState() => _MathBlastPageState();
}

class _MathBlastPageState extends State<MathBlastHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    GameScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        body: _pages[_selectedIndex], // Display the selected page
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themeProvider.isNightModeOn
                  ? [Colors.grey.shade900, Colors.black]
                  : [Colors.purple.shade50, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: themeProvider.isNightModeOn
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
                blurRadius: 12,
                spreadRadius: 2,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 7),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: themeProvider.isNightModeOn
                    ? Colors.deepPurple.shade200
                    : Colors.deepPurple.shade700,
                unselectedItemColor: themeProvider.isNightModeOn
                    ? Colors.grey.shade400
                    : Colors.grey.shade500,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12,
                ),
                items: [
                  _buildNavItem(
                    icon: 'assets/icons/home.png',
                    label: 'Home',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: 'assets/icons/gameIcon.png',
                    label: 'Game',
                    index: 1,
                  ),
                  _buildNavItem(
                    icon: 'assets/icons/setting.png',
                    label: 'Setting',
                    index: 2,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  BottomNavigationBarItem _buildNavItem({
    required String icon,
    required String label,
    required int index,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.fastLinearToSlowEaseIn,
        transform: Matrix4.identity()
          ..scale(_selectedIndex == index ? 1.1 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _selectedIndex == index
              ? (themeProvider.isNightModeOn
              ? Colors.white.withOpacity(0.1)
              : Colors.blue.withOpacity(0.1))
              : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageIcon(
              AssetImage(icon),
              size: 24,
              color: _selectedIndex == index
                  ? (themeProvider.isNightModeOn
                  ? Colors.white
                  : Colors.blue.shade700)
                  : (themeProvider.isNightModeOn
                  ? Colors.grey.shade500
                  : Colors.grey.shade600),
            ),
            if (_selectedIndex == index)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                  color: themeProvider.isNightModeOn
                      ? Colors.white
                      : Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
      label: label,
    );
  }
}
//#endregion

// ===================== Home Screen =====================

//#region Home Page
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final titleFontSize = isSmallScreen ? 28.0 : 36.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: themeProvider.isNightModeOn
                ? [Colors.grey.shade900, Colors.black]
                : [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: isSmallScreen ? 140 : 180,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: themeProvider.isNightModeOn
                    ? Colors.grey.shade800
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeProvider.isNightModeOn
                        ? Colors.black.withOpacity(0.4)
                        : Colors.blue.shade200.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: isSmallScreen ? 80 : 100,
                      height: isSmallScreen ? 80 : 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeProvider.isNightModeOn
                            ? Colors.orange.shade700.withOpacity(0.3)
                            : Colors.orange.shade100.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 30,
                    child: Container(
                      width: isSmallScreen ? 50 : 60,
                      height: isSmallScreen ? 50 : 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeProvider.isNightModeOn
                            ? Colors.purple.shade700.withOpacity(0.3)
                            : Colors.purple.shade100.withOpacity(0.5),
                      ),
                    ),
                  ),

                  // Title text
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                'Math Learning',
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ComicSans',
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = isSmallScreen ? 4 : 6
                                    ..color = themeProvider.isNightModeOn
                                        ? Colors.grey.shade900
                                        : Colors.white,
                                ),
                              ),
                              Text(
                                'Math Learning',
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ComicSans',
                                  color: themeProvider.isNightModeOn
                                      ? Colors.deepPurple.shade200
                                      : Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Learn and have fun!",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w500,
                            color: themeProvider.isNightModeOn
                                ? Colors.deepPurple.shade200
                                : Colors.deepPurple.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Single Math card
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20.0 : 30.0
                ),
                child: Center(
                  child: _buildMathCard(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMathCard(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => GradePage(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              }
          ),
        );
      },
      child: Container(
        height: isSmallScreen ? 280 : 320,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeProvider.isNightModeOn
                ? [Colors.orange.shade900, Colors.deepOrange.shade700]
                : [Colors.orange.shade300, Colors.orange.shade100],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isNightModeOn
                  ? Colors.black.withOpacity(0.5)
                  : Colors.orange.shade200.withOpacity(0.7),
              blurRadius: 20,
              spreadRadius: 5,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              right: -30,
              bottom: -30,
              child: Container(
                width: isSmallScreen ? 120 : 150,
                height: isSmallScreen ? 120 : 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              left: -20,
              top: -20,
              child: Container(
                width: isSmallScreen ? 80 : 100,
                height: isSmallScreen ? 80 : 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 20.0 : 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Math icon with shadow
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeProvider.isNightModeOn
                              ? Colors.deepOrange.shade900.withOpacity(0.5)
                              : Colors.orange.shade300.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: Offset(0, 7),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.calculate,
                      size: isSmallScreen ? 40 : 50,
                      color: themeProvider.isNightModeOn
                          ? Colors.deepOrange.shade800
                          : Colors.orange.shade500,
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 15),

                  // Title and description
                  Text(
                    "Mathematics",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 22 : 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicSans',
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 8 : 10),

                  Text(
                    "Learn numbers, addition, subtraction, and more math concepts!",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),

                  Spacer(),

                  // Start learning button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 5 : 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.isNightModeOn
                                    ? Colors.deepOrange.shade900.withOpacity(0.3)
                                    : Colors.orange.shade300.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Start Learning",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isNightModeOn
                                      ? Colors.deepOrange.shade800
                                      : Colors.orange.shade600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: themeProvider.isNightModeOn
                                    ? Colors.deepOrange.shade800
                                    : Colors.orange.shade600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Shine effect
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: isSmallScreen ? 80 : 100,
                height: isSmallScreen ? 80 : 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(100),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//#endregion