import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'ArithmeticOperationsPage.dart';
import '../Setting.dart';

class MathOperationsPage extends StatefulWidget {
  final int gradeNumber;
  const MathOperationsPage({super.key, required this.gradeNumber});

  @override
  State<MathOperationsPage> createState() => _MathOperationsPageState();
}

class _MathOperationsPageState extends State<MathOperationsPage> with SingleTickerProviderStateMixin {
  late ThemeProvider themeProvider;
  late ThemeData _themeData;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  //#region Init state and dispose
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  //#endregion

  //#region Theme Helper methods
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
    _updateTheme();
  }

  void _updateTheme() {
    _themeData = themeProvider.isNightModeOn
        ? _darkTheme()
        : _lightTheme();
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      cardColor: Colors.white,
      scaffoldBackgroundColor: Colors.blue.shade50,
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.indigo,
      cardColor: Color(0xFF303030),
      scaffoldBackgroundColor: Color(0xFF121212),
    );
  }

  // Modernized gradient colors
  Color get primaryGradientStart => themeProvider.isNightModeOn ? Color(0xFF1A237E) : Color(0xFF4DB6AC);
  Color get primaryGradientEnd => themeProvider.isNightModeOn ? Color(0xFF6A1B9A) : Color(0xFF1976D2);
  //#endregion


  //#region Get Operations List
  List<Map<String, dynamic>> getOperations() {
    return [
      {
        'title': 'Addition',
        'icon': FontAwesomeIcons.plus,
        'color': themeProvider.isNightModeOn ? Color(0xFF66BB6A) : Color(0xFFFF9800),
        'route': ArithmeticOperationsPage(grade: widget.gradeNumber, operation: 'Addition',),
        'description': 'Master addition skills',
      },
      {
        'title': 'Subtraction',
        'icon': FontAwesomeIcons.minus,
        'color': themeProvider.isNightModeOn ? Color(0xFFEF5350) : Color(0xFFE53935),
        'route': ArithmeticOperationsPage(grade: widget.gradeNumber,operation: 'Subtraction',),
        'description': 'Practice subtraction',
      },
      {
        'title': 'Multiplication',
        'icon': FontAwesomeIcons.xmark,
        'color': themeProvider.isNightModeOn ? Color(0xFFFFCA28) : Color(0xFF4CAF50),
        'route': ArithmeticOperationsPage(grade: widget.gradeNumber, operation: 'Multiplication',),
        'description': 'Learn multiplication',
      },
      {
        'title': 'Division',
        'icon': FontAwesomeIcons.divide,
        'color': themeProvider.isNightModeOn ? Color(0xFF42A5F5) : Color(0xFF2196F3),
        'route': ArithmeticOperationsPage(grade: widget.gradeNumber, operation: 'Division',),
        'description': 'Explore division',
      },
    ];
  }
  //#endregion

  //#region Page UI
  @override
  Widget build(BuildContext context) {
    final operations = getOperations();
    return Theme(
      data: _themeData,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryGradientStart, primaryGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: DecorationImage(
              image: AssetImage('assets/BackGround/BackGround2.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                themeProvider.isNightModeOn
                    ? Color.fromRGBO(0,0,0,0.7)
                    : Color.fromRGBO(0,0,0,0.2),
                BlendMode.darken,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_rounded, color: themeProvider.isNightModeOn ? Colors.white :Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Math Fun!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'ComicSans',
                              color: themeProvider.isNightModeOn ? Colors.white :Colors.black,
                              shadows: [
                                Shadow(
                                  color: Colors.black38,
                                  blurRadius: 8,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                // Header with grade info
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color:themeProvider.isNightModeOn ? Color.fromRGBO(255, 255, 255, 0.5) :Color.fromRGBO(0,0,0,0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${widget.gradeNumber}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isNightModeOn ? Colors.white :Colors.black ,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Grade ${widget.gradeNumber}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:  themeProvider.isNightModeOn ? Colors.white :Colors.black
                            ),
                          ),
                          Text(
                            "Let's practice math skills!",
                            style: TextStyle(
                              fontSize: 14,
                              color: themeProvider.isNightModeOn ? Colors.white :Colors.black
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: operations.length,
                          itemBuilder: (context, index) {
                            final operation = operations[index];
                            return _buildOperationCard(
                              context: context,
                              title: operation['title'],
                              icon: operation['icon'],
                              color: operation['color'],
                              description: operation['description'],
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:  Duration(milliseconds: 500),
                                    pageBuilder: (_, __, ___) => operation['route'],
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
  //#endregion

  //#region Operation Card Build Method
  Widget _buildOperationCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Hero(
        tag: title,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Color.fromRGBO(255, 255, 255, 0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 16),
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 2,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(255, 255, 255, 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow icon
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 18,
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
}