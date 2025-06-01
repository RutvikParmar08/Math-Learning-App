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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      body: _pages[_selectedIndex],
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
            topLeft: Radius.circular(isTablet ? 35 : 30),
            topRight: Radius.circular(isTablet ? 35 : 30),
          ),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isNightModeOn
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isTablet ? 16 : 12,
              spreadRadius: 2,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: isTablet ? 15.0 : 10.0,
            top: isTablet ? 10 : 7,
            left: isTablet ? 20 : 0,
            right: isTablet ? 20 : 0,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isTablet ? 35 : 30),
              topRight: Radius.circular(isTablet ? 35 : 30),
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
                fontSize: isTablet ? 15 : 13,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: isTablet ? 14 : 12,
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
      ),
    );
  }

  // BottomNavigationBarItem _buildNavItem({
  //   required String icon,
  //   required String label,
  //   required int index,
  // })
  // {
  //   final themeProvider = Provider.of<ThemeProvider>(context);
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final isTablet = screenWidth > 600;
  //   final iconSize = isTablet ? 28.0 : 24.0;
  //
  //   return BottomNavigationBarItem(
  //     icon: AnimatedContainer(
  //       duration: const Duration(milliseconds: 2000),
  //       curve: Curves.fastLinearToSlowEaseIn,
  //       transform: Matrix4.identity()
  //         ..scale(_selectedIndex == index ? 1.1 : 1.0),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
  //         color: _selectedIndex == index
  //             ? (themeProvider.isNightModeOn
  //             ? Colors.white.withOpacity(0.1)
  //             : Colors.blue.withOpacity(0.1))
  //             : Colors.transparent,
  //       ),
  //       padding: EdgeInsets.symmetric(
  //         horizontal: isTablet ? 16 : 12,
  //         vertical: isTablet ? 10 : 8,
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           ImageIcon(
  //             AssetImage(icon),
  //             size: iconSize,
  //             color: _selectedIndex == index
  //                 ? (themeProvider.isNightModeOn
  //                 ? Colors.white
  //                 : Colors.blue.shade700)
  //                 : (themeProvider.isNightModeOn
  //                 ? Colors.grey.shade500
  //                 : Colors.grey.shade600),
  //           ),
  //           if (_selectedIndex == index)
  //             Container(
  //               margin: EdgeInsets.only(top: isTablet ? 6 : 4),
  //               height: isTablet ? 4 : 3,

  //               width: isTablet ? 24 : 20,
  //               decoration: BoxDecoration(
  //                 color: themeProvider.isNightModeOn
  //                     ? Colors.white
  //                     : Colors.blue.shade700,
  //                 borderRadius: BorderRadius.circular(2),
  //               ),
  //             ),
  //         ],
  //       ),
  //     ),
  //     label: label,
  //   );
  // }
  BottomNavigationBarItem _buildNavItem({
    required String icon,
    required String label,
    required int index,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final iconSize = isTablet ? 28.0 : 24.0;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.fastLinearToSlowEaseIn,
        transform: Matrix4.identity()
          ..scale(_selectedIndex == index ? 1.1 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          color: _selectedIndex == index
              ? (themeProvider.isNightModeOn
              ? Colors.white.withOpacity(0.1)
              : Colors.blue.withOpacity(0.1))
              : Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 12,
          vertical: isTablet ? 10 : 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageIcon(
              AssetImage(icon),
              size: iconSize,
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
                margin: EdgeInsets.only(top: isTablet ? 6 : 4),
                height: isTablet ? 4 : 3,
                width: isTablet ? 24 : 20,
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
  // Helper methods for responsive design
  double _getHeaderHeight(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return screenSize.width > 800 ? 120 : 100;
    }

    if (screenSize.width > 800) return 200; // Desktop
    if (screenSize.width > 600) return 180; // Tablet
    return 140; // Mobile
  }

  double _getTitleFontSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 800) return 42.0; // Desktop
    if (screenWidth > 600) return 36.0; // Tablet
    return 28.0; // Mobile
  }

  EdgeInsets _getHorizontalPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return EdgeInsets.symmetric(horizontal: 80.0);
    if (screenWidth > 800) return EdgeInsets.symmetric(horizontal: 60.0);
    if (screenWidth > 600) return EdgeInsets.symmetric(horizontal: 40.0);
    return EdgeInsets.symmetric(horizontal: 20.0);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isDesktop = screenSize.width > 800;
    final isTablet = screenSize.width > 600 && screenSize.width <= 800;
    final headerHeight = _getHeaderHeight(context);
    final titleFontSize = _getTitleFontSize(context);

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
        child: isLandscape ?
        _buildLandscapeLayout(context, themeProvider, headerHeight, titleFontSize) :
        _buildPortraitLayout(context, themeProvider, headerHeight, titleFontSize),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, ThemeProvider themeProvider,
      double headerHeight, double titleFontSize) {
    return Column(
      children: [
        _buildHeader(context, themeProvider, headerHeight, titleFontSize),
        Expanded(
          child: Padding(
            padding: _getHorizontalPadding(context),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: _buildMathCard(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, ThemeProvider themeProvider,
      double headerHeight, double titleFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        // Left side with header content
        Expanded(
          flex: screenWidth > 800 ? 2 : 3,
          child: Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeProvider.isNightModeOn
                  ? Colors.grey.shade800
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(30),
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
            child: _buildHeaderContent(context, themeProvider, titleFontSize),
          ),
        ),
        // Right side with math card
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500, maxHeight: 400),
                child: _buildMathCard(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider,
      double headerHeight, double titleFontSize) {
    return Container(
      height: headerHeight,
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
      child: _buildHeaderContent(context, themeProvider, titleFontSize),
    );
  }

  Widget _buildHeaderContent(BuildContext context, ThemeProvider themeProvider, double titleFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 600;

    return Stack(
      children: [
        // Decorative circles
        Positioned(
          top: -20,
          right: -20,
          child: Container(
            width: isDesktop ? 120 : (isTablet ? 100 : 80),
            height: isDesktop ? 120 : (isTablet ? 100 : 80),
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
            width: isDesktop ? 80 : (isTablet ? 60 : 50),
            height: isDesktop ? 80 : (isTablet ? 60 : 50),
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
                padding: EdgeInsets.all(isDesktop ? 25 : (isTablet ? 20 : 15)),
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
                          ..strokeWidth = isDesktop ? 8 : (isTablet ? 6 : 4)
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
                  fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
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
    );
  }

  Widget _buildMathCard(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;
    final isDesktop = screenSize.width > 800;
    final isTablet = screenSize.width > 600;

    // Responsive sizing
    final cardHeight = isLandscape ?
    (isDesktop ? 350.0 : 300.0) :
    (isDesktop ? 400.0 : (isTablet ? 350.0 : 280.0));

    final iconSize = isDesktop ? 60.0 : (isTablet ? 50.0 : 40.0);
    final titleSize = isDesktop ? 28.0 : (isTablet ? 25.0 : 22.0);
    final descriptionSize = isDesktop ? 18.0 : (isTablet ? 16.0 : 14.0);
    final buttonTextSize = isDesktop ? 20.0 : (isTablet ? 18.0 : 16.0);
    final cardPadding = isDesktop ? 30.0 : (isTablet ? 25.0 : 20.0);
    final borderRadius = isDesktop ? 35.0 : 30.0;

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
        height: cardHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: themeProvider.isNightModeOn
                ? [Colors.orange.shade900, Colors.deepOrange.shade700]
                : [Colors.orange.shade300, Colors.orange.shade100],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isNightModeOn
                  ? Colors.black.withOpacity(0.5)
                  : Colors.orange.shade200.withOpacity(0.7),
              blurRadius: isDesktop ? 25 : 20,
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
                width: isDesktop ? 180 : (isTablet ? 150 : 120),
                height: isDesktop ? 180 : (isTablet ? 150 : 120),
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
                width: isDesktop ? 120 : (isTablet ? 100 : 80),
                height: isDesktop ? 120 : (isTablet ? 100 : 80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Math icon with shadow
                  Container(
                    padding: EdgeInsets.all(isDesktop ? 25 : (isTablet ? 20 : 15)),
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
                      size: iconSize,
                      color: themeProvider.isNightModeOn
                          ? Colors.deepOrange.shade800
                          : Colors.orange.shade500,
                    ),
                  ),

                  SizedBox(height: isDesktop ? 20 : (isTablet ? 15 : 10)),

                  // Title and description
                  Text(
                    "Mathematics",
                    style: TextStyle(
                      fontSize: titleSize,
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

                  SizedBox(height: isDesktop ? 15 : (isTablet ? 10 : 8)),

                  Flexible(
                    child: Text(
                      "Learn numbers, addition, subtraction, and more math concepts!",
                      style: TextStyle(
                        fontSize: descriptionSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                      maxLines: isLandscape ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Spacer(),

                  // Start learning button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: isDesktop ? 15 : (isTablet ? 12 : 8)
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isDesktop ? 20 : 15),
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
                            fontSize: buttonTextSize,
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
                          size: buttonTextSize,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Shine effect
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: isDesktop ? 120 : (isTablet ? 100 : 80),
                height: isDesktop ? 120 : (isTablet ? 100 : 80),
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
                    topLeft: Radius.circular(borderRadius),
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