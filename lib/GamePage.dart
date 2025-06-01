import 'package:flutter/material.dart';
import 'Game/DuelPlayerGame.dart';
import 'Game/LevelPage.dart';
import 'package:provider/provider.dart';

import 'Setting.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _staggerController;


  //#region Init state , dispose
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animationController.forward();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _staggerController.dispose();
    super.dispose();
  }
  //#endregion

  //#region page UI
  @override
  Widget build(BuildContext context) {
    //#region Responsive Variable
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isNightModeOn;
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isLandscape = screenWidth > screenHeight;
    final isDesktop = screenWidth > 1200;

    // Responsive measurements
    final horizontalPadding = _getHorizontalPadding(screenWidth);
    final headerFontSize = _getHeaderFontSize(screenWidth);
    final crossAxisCount = _getCrossAxisCount(screenWidth, isLandscape);
    final childAspectRatio = _getChildAspectRatio(screenWidth, isLandscape);
    //#endregion

    // Theme colors
    final mainBgGradient = isDarkMode
        ? [Color(0xFF0A0A0A), Color(0xFF1A1A1A), Color(0xFF2A2A2A)]
        : [Color(0xFFE8F5E8), Color(0xFFB8E6B8), Color(0xFFA5D6A7)];

    final cardColors = [
      isDarkMode ? Color(0xFFE91E63) : Color(0xFFFF4081), // Pink
      isDarkMode ? Color(0xFF4CAF50) : Color(0xFF66BB6A), // Green
      isDarkMode ? Color(0xFF2196F3) : Color(0xFF42A5F5), // Blue
      isDarkMode ? Color(0xFF9C27B0) : Color(0xFFAB47BC), // Purple
      isDarkMode ? Color(0xFF00BCD4) : Color(0xFF26C6DA), // Cyan
    ];


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: mainBgGradient,
            stops: isDarkMode ? [0.0, 0.5, 1.0] : [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDarkMode, horizontalPadding, headerFontSize, isTablet),
              Expanded(
                child: _buildGameGrid(
                  context,
                  cardColors,
                  isDarkMode,
                  horizontalPadding,
                  crossAxisCount,
                  childAspectRatio,
                  isTablet,
                  isDesktop,
                ),
              ),
              if (isTablet) _buildFooterInfo(isDarkMode, horizontalPadding),
            ],
          ),
        ),
      ),
    );
  }
  //#endregion

  //#region Responsive helper methods
  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 1200) return 40.0; // Desktop
    if (screenWidth > 600) return 28.0;  // Tablet
    return 20.0; // Mobile
  }

  double _getHeaderFontSize(double screenWidth) {
    if (screenWidth > 1200) return 42.0; // Desktop
    if (screenWidth > 600) return 36.0;  // Tablet
    return 28.0; // Mobile
  }

  int _getCrossAxisCount(double screenWidth, bool isLandscape) {
    if (screenWidth > 1200) return isLandscape ? 5 : 4; // Desktop
    if (screenWidth > 900) return isLandscape ? 4 : 3;  // Large tablet
    if (screenWidth > 600) return isLandscape ? 3 : 2;  // Tablet
    return 2; // Mobile
  }

  double _getChildAspectRatio(double screenWidth, bool isLandscape) {
    if (screenWidth > 1200) return isLandscape ? 0.9 : 0.85; // Desktop
    if (screenWidth > 600) return isLandscape ? 0.95 : 0.9; // Tablet
    return isLandscape ? 1.1 : 0.85; // Mobile
  }
  //#endregion

  //#region Header
  Widget _buildHeader(bool isDarkMode, double padding, double fontSize, bool isTablet) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _animationController.value)),
          child: Opacity(
            opacity: _animationController.value,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Game Modes',
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.w800,
                                color: isDarkMode ? Colors.white : Colors.black87,
                                letterSpacing: 1.2,
                                shadows: isDarkMode ? [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ] : null,
                              ),
                            ),
                            if (isTablet) ...[
                              SizedBox(height: 8),
                              Text(
                                'Choose your challenge level',
                                style: TextStyle(
                                  fontSize: fontSize * 0.4,
                                  color: (isDarkMode ? Colors.white : Colors.black87)
                                      .withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isTablet)
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (isDarkMode ? Colors.white : Colors.black)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.games,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                            size: fontSize * 0.8,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  //#endregion

  //#region Game Grid
  Widget _buildGameGrid(
      BuildContext context,
      List<Color> cardColors,
      bool isDarkMode,
      double padding,
      int crossAxisCount,
      double childAspectRatio,
      bool isTablet,
      bool isDesktop,
      ) {
    final gameOptions = [
      {
        'title': 'Single Player',
        'color': cardColors[0],
        'page': LevelPage(title: 'Single Player', themeColor: Colors.pinkAccent),
        'icon': 'assets/icons/SinglePlayer.png',
        'description': 'Solo gameplay experience',
        'subtitle': 'Challenge yourself'
      },
      {
        'title': 'Duel Player',
        'color': cardColors[1],
        'page': DuelPlayerGame(),
        'icon': 'assets/icons/multiplayer.png',
        'description': 'Compete with friends',
        'subtitle': 'Multiplayer fun'
      },
      {
        'title': 'Input Answer',
        'color': cardColors[2],
        'page': LevelPage(title: 'Input Answer', themeColor: Colors.blueAccent),
        'icon': 'assets/icons/InputText.png',
        'description': 'Type your solutions',
        'subtitle': 'Text-based answers'
      },
      {
        'title': 'True False',
        'color': cardColors[3],
        'page': LevelPage(title: 'True False', themeColor: Colors.purpleAccent),
        'icon': 'assets/icons/TrueFalse.png',
        'description': 'Quick decisions',
        'subtitle': 'Yes or no questions'
      },
      {
        'title': 'Missing Value',
        'color': cardColors[4],
        'page': LevelPage(title: 'Missing value', themeColor: Colors.lightBlueAccent),
        'icon': 'assets/icons/MissingValue.png',
        'description': 'Fill in the blanks',
        'subtitle': 'Find missing pieces'
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: isTablet ? 20 : 16,
          mainAxisSpacing: isTablet ? 20 : 16,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: gameOptions.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _staggerController,
            builder: (context, child) {
              // Calculate the base animation value with stagger delay
              final delayedValue = (_staggerController.value - (index * 0.1)).clamp(0.0, 1.0);

              // Apply the curve and then clamp again to ensure valid range
              final animationValue = Curves.easeOutBack.transform(delayedValue).clamp(0.0, 1.0);

              return Transform.scale(
                scale: animationValue,
                child: Transform.translate(
                  offset: Offset(0, 50 * (1 - animationValue)),
                  child: Opacity(
                    opacity: animationValue,
                    child: _buildGameCard(
                      context,
                      gameOptions[index]['title'] as String,
                      gameOptions[index]['color'] as Color,
                      gameOptions[index]['page'] as Widget,
                      gameOptions[index]['icon'] as String,
                      gameOptions[index]['description'] as String,
                      gameOptions[index]['subtitle'] as String,
                      isDarkMode,
                      isTablet,
                      isDesktop,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  //#endregion

  //#region Build Game Card
  Widget _buildGameCard(
      BuildContext context,
      String title,
      Color color,
      Widget page,
      String iconPath,
      String description,
      String subtitle,
      bool isDarkMode,
      bool isTablet,
      bool isDesktop,
      ) {
    final cardPadding = isTablet ? 20.0 : 16.0;
    final titleFontSize = isDesktop ? 20.0 : (isTablet ? 18.0 : 16.0);
    final descriptionFontSize = isDesktop ? 14.0 : (isTablet ? 13.0 : 12.0);
    final iconSize = isDesktop ? 36.0 : (isTablet ? 32.0 : 28.0);

    return Hero(
      tag: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => page,
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.easeInOutCubic;
                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 300),
              ),
            );
          },
          borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
          splashColor: color.withOpacity(0.3),
          highlightColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  color.withOpacity(0.8),
                  color.withBlue((color.blue + 30).clamp(0, 255)),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isDarkMode ? 0.4 : 0.25),
                  blurRadius: isTablet ? 25 : 20,
                  spreadRadius: -3,
                  offset: Offset(0, isTablet ? 12 : 10),
                ),
                BoxShadow(
                  color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
                  blurRadius: isTablet ? 40 : 30,
                  spreadRadius: -10,
                  offset: Offset(0, isTablet ? 20 : 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isTablet ? 28 : 24),
              child: Stack(
                children: [
                  // Enhanced background decoration
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Container(
                      width: isTablet ? 130 : 100,
                      height: isTablet ? 130 : 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Container(
                      width: isTablet ? 80 : 60,
                      height: isTablet ? 80 : 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -15,
                    top: -15,
                    child: Container(
                      width: isTablet ? 90 : 70,
                      height: isTablet ? 90 : 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),

                  // Main content
                  Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon container
                        Container(
                          padding: EdgeInsets.all(isTablet ? 14 : 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(isTablet ? 18 : 14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Image.asset(
                            iconPath,
                            width: iconSize,
                            height: iconSize,
                            color: Colors.white,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.games,
                                size: iconSize,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),

                        Spacer(),

                        // Title
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          maxLines: isTablet ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: isTablet ? 6 : 4),

                        // Description/Subtitle
                        if (isTablet) ...[
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: descriptionFontSize,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2),
                        ],

                        Text(
                          description,
                          style: TextStyle(
                            fontSize: descriptionFontSize - (isTablet ? 1 : 0),
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        if (isDesktop) ...[
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Tap to play',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  //#endregion

  //#region Footer
  Widget _buildFooterInfo(bool isDarkMode, double padding) {
    return Container(
      margin: EdgeInsets.all(padding),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.7),
          ),
          SizedBox(width: 8),
          Text(
            'Swipe and tap to explore different game modes',
            style: TextStyle(
              fontSize: 14,
              color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  //#endregion
}