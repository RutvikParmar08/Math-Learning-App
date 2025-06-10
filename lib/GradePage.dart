import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Math/MathOperations.dart';
import 'Setting.dart';

//#region Grade Page
class GradePage extends StatefulWidget {
  const GradePage({super.key});

  @override
  _GradePageState createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _staggerController;

  final List<Map<String, dynamic>> grades = [
    {"grade": "Grade 1", "icon": Icons.looks_one},
    {"grade": "Grade 2", "icon": Icons.looks_two},
    {"grade": "Grade 3", "icon": Icons.looks_3},
    {"grade": "Grade 4", "icon": Icons.looks_4},
    {"grade": "Grade 5", "icon": Icons.looks_5_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimationController.forward();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  // Responsive helper methods
  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 1200) return 32.0; // Desktop
    if (screenWidth > 600) return 24.0;  // Tablet
    return 16.0; // Mobile
  }

  double _getSubtitleFontSize(double screenWidth) {
    if (screenWidth > 1200) return 18.0; // Desktop
    if (screenWidth > 600) return 16.0;  // Tablet
    return 16.0; // Mobile
  }

  int _getCrossAxisCount(double screenWidth, bool isLandscape) {
    if (screenWidth > 1200) return isLandscape ? 5 : 4; // Desktop
    if (screenWidth > 900) return isLandscape ? 4 : 3;  // Large tablet
    if (screenWidth > 600) return isLandscape ? 3 : 2;  // Tablet
    return 2; // Mobile
  }

  double _getChildAspectRatio(double screenWidth, bool isLandscape) {
    if (screenWidth > 1200) return isLandscape ? 0.9 : 0.85; // Desktop
    if (screenWidth > 600) return isLandscape ? 0.95 : 0.85; // Tablet
    return isLandscape ? 1.0 : 0.85; // Mobile
  }

  @override
  Widget build(BuildContext context) {
    // Get theme from provider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isNightModeOn;

    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isLandscape = screenWidth > screenHeight;
    final isDesktop = screenWidth > 1200;

    // Responsive measurements
    final horizontalPadding = _getHorizontalPadding(screenWidth);
    final subtitleFontSize = _getSubtitleFontSize(screenWidth);
    final crossAxisCount = _getCrossAxisCount(screenWidth, isLandscape);
    final childAspectRatio = _getChildAspectRatio(screenWidth, isLandscape);

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
                    ? Color.fromRGBO(0,0,0,0.3)
                    : Color.fromRGBO(33, 150, 243,0.2),
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
              size: isTablet ? 28 : 26,
            ),
            SizedBox(width: 10),
            Text(
              'Choose Your Grade',
              style: TextStyle(
                fontSize: isDesktop ? 24 : (isTablet ? 22 : 20),
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
                ? Color.fromRGBO(255,255,255,0.1)
                : Color.fromRGBO(255,255,255,0.3),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedSubtitle(isDarkMode, horizontalPadding, subtitleFontSize),
              Expanded(
                child: _buildAnimatedGradeGrid(
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

  Widget _buildAnimatedSubtitle(bool isDarkMode, double padding, double fontSize) {
    return AnimatedBuilder(
      animation: _headerAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _headerAnimationController.value)),
          child: Opacity(
            opacity: _headerAnimationController.value,
            child: Padding(
              padding: EdgeInsets.only(
                left: padding + 8.0,
                right: padding,
                top: 16.0,
                bottom: 16.0,
              ),
              child: Text(
                'Select a grade level to begin',
                style: TextStyle(
                  fontSize: fontSize,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedGradeGrid(
      BuildContext context,
      List<Color> cardColors,
      bool isDarkMode,
      double padding,
      int crossAxisCount,
      double childAspectRatio,
      bool isTablet,
      bool isDesktop,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: isTablet ? 20 : 16,
          mainAxisSpacing: isTablet ? 20 : 16,
        ),
        itemCount: grades.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _staggerController,
            builder: (context, child) {
              // Calculate the base animation value with stagger delay
              final delayedValue = (_staggerController.value - (index * 0.15)).clamp(0.0, 1.0);

              // Apply the curve and then clamp again to ensure valid range
              final animationValue = Curves.easeOutBack.transform(delayedValue).clamp(0.0, 1.0);

              return Transform.scale(
                scale: animationValue,
                child: Transform.translate(
                  offset: Offset(0, 50 * (1 - animationValue)),
                  child: Opacity(
                    opacity: animationValue,
                    child: GradeCard(
                      grade: grades[index]["grade"],
                      color: cardColors[index],
                      icon: grades[index]["icon"],
                      isDarkMode: isDarkMode,
                      isTablet: isTablet,
                      isDesktop: isDesktop,
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
                                child: child,
                              );
                            },
                          ),
                        );
                      },
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

  Widget _buildFooterInfo(bool isDarkMode, double padding) {
    return AnimatedBuilder(
      animation: _headerAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _headerAnimationController.value)),
          child: Opacity(
            opacity: _headerAnimationController.value * 0.8,
            child: Container(
              margin: EdgeInsets.all(padding),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: (isDarkMode ? Color.fromRGBO(255,255,255,0.05) : Color.fromRGBO(0,0,0,0.05)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (isDarkMode ? Color.fromRGBO(255,255,255,0.1) : Color.fromRGBO(0,0,0,0.1)),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: (isDarkMode ? Color.fromRGBO(255,255,255,0.7) : Color.fromRGBO(0,0,0,0.7)),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tap any grade to start your math journey',
                    style: TextStyle(
                      fontSize: 14,
                      color: (isDarkMode ? Color.fromRGBO(255,255,255,0.7) : Color.fromRGBO(0,0,0,0.7)),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
  final bool isTablet;
  final bool isDesktop;
  final VoidCallback onTap;

  const GradeCard({super.key,
    required this.grade,
    required this.color,
    required this.icon,
    required this.isDarkMode,
    required this.isTablet,
    required this.isDesktop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardPadding = isTablet ? 20.0 : 16.0;
    final iconSize = isDesktop ? 36.0 : (isTablet ? 34.0 : 32.0);
    final titleFontSize = isDesktop ? 22.0 : (isTablet ? 20.0 : 18.0);
    final subtitleFontSize = isDesktop ? 14.0 : (isTablet ? 13.0 : 12.0);

    return Hero(
      tag: grade,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
          splashColor: Color.fromRGBO(color.red, color.green, color.blue, 0.3),
          highlightColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  Color.fromRGBO(color.red, color.green, color.blue,0.8),
                  color.withBlue((color.blue + 40).clamp(0, 255)),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(color.red, color.green, color.blue,isDarkMode ? 0.4 : 0.3),
                  blurRadius: isTablet ? 20 : 15,
                  spreadRadius: -3,
                  offset: Offset(0, isTablet ? 8 : 6),
                ),
                BoxShadow(
                  color: Color.fromRGBO(color.red, color.green, color.blue,isDarkMode ? 0.2 : 0.15),
                  blurRadius: isTablet ? 35 : 25,
                  spreadRadius: -8,
                  offset: Offset(0, isTablet ? 15 : 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isTablet ? 24 : 20),
              child: Stack(
                children: [
                  // Enhanced decorative elements
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Container(
                      width: isTablet ? 120 : 100,
                      height: isTablet ? 120 : 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(255,255,255,0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -15,
                    bottom: -15,
                    child: Container(
                      width: isTablet ? 80 : 60,
                      height: isTablet ? 80 : 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(255,255,255,0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -15,
                    top: -15,
                    child: Container(
                      width: isTablet ? 80 : 60,
                      height: isTablet ? 80 : 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(255,255,255,0.06),
                      ),
                    ),
                  ),

                  // Main content
                  Padding(
                    padding: EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon container with enhanced styling
                        Container(
                          padding: EdgeInsets.all(isTablet ? 14 : 12),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.2),
                            borderRadius: BorderRadius.circular(isTablet ? 16 : 14),
                            border: Border.all(
                              color: Color.fromRGBO(255,255,255,0.1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            size: iconSize,
                            color: Colors.white,
                          ),
                        ),

                        Spacer(),

                        // Grade title
                        Text(
                          grade,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                offset: Offset(1, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isTablet ? 6 : 4),

                        // Subtitle
                        Text(
                          'Tap to start',
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        if (isDesktop) ...[
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Begin learning',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color.fromRGBO(255, 255, 255, 0.9),
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
}
//#endregion