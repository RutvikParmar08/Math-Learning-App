// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'Math/DivisionOperations.dart';
// import 'Math/MultiplicationOperations.dart';
// import 'Math/SubtractionOperations.dart';
// import 'Math/SumOperations.dart';
// import 'Setting.dart';
//
// class MathOperationsPage extends StatefulWidget {
//   final int gradeNumber;
//   const MathOperationsPage({super.key, required this.gradeNumber});
//
//   @override
//   State<MathOperationsPage> createState() => _MathOperationsPageState();
// }
//
// class _MathOperationsPageState extends State<MathOperationsPage> {
//   late ThemeProvider themeProvider;
//   late ThemeData _themeData;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     themeProvider = Provider.of<ThemeProvider>(context);
//     _updateTheme();
//   }
//   void _updateTheme() {
//     _themeData = themeProvider.isNightModeOn
//         ? _darkTheme()
//         : _lightTheme();
//   }
//   ThemeData _lightTheme() {
//     return ThemeData(
//       brightness: Brightness.light,
//       primaryColor: Colors.blue,
//       cardColor: Colors.white,
//       scaffoldBackgroundColor: Colors.blue.shade50,
//     );
//   }
//   ThemeData _darkTheme() {
//     return ThemeData(
//       brightness: Brightness.dark,
//       primaryColor: Colors.indigo,
//       cardColor: Color(0xFF303030),
//       scaffoldBackgroundColor: Color(0xFF121212),
//     );
//   }
//   Color get primaryGradientStart => themeProvider.isNightModeOn ? Colors.indigo.shade700 : Colors.teal.shade200;
//   Color get primaryGradientEnd => themeProvider.isNightModeOn ? Colors.purple.shade800 : Colors.blue.shade400;
//
//   Color get titleGradientStart => themeProvider.isNightModeOn ? Colors.cyanAccent : Colors.orange;
//   Color get titleGradientEnd => themeProvider.isNightModeOn ? Colors.purpleAccent : Colors.purple;
//
//   Color getOperationColor(String operation) {
//     if (themeProvider.isNightModeOn) {
//       switch (operation) {
//         case 'Addition': return Colors.greenAccent.shade700;
//         case 'Subtraction': return Colors.redAccent.shade700;
//         case 'Multiplication': return Colors.amberAccent.shade700;
//         case 'Division': return Colors.blueAccent.shade700;
//         default: return Colors.purpleAccent.shade700;
//       }
//     } else {
//       switch (operation) {
//         case 'Addition': return Colors.orangeAccent;
//         case 'Subtraction': return Colors.redAccent;
//         case 'Multiplication': return Colors.greenAccent;
//         case 'Division': return Colors.blueAccent;
//         default: return Colors.purpleAccent;
//       }
//     }
//   }
//
//   Color get cardBorderColor => themeProvider.isNightModeOn ? Colors.white24 : Colors.white.withOpacity(0.3);
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: _themeData,
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           title: Text(
//             'Math Fun!',
//             style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'ComicSans',
//              color: Colors.white
//             ),
//           ),
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_circle_left_outlined,
//                 color: themeProvider.isNightModeOn ? Colors.white : Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//           actions: [],
//         ),
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [primaryGradientStart, primaryGradientEnd],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             image: DecorationImage(
//               image: AssetImage(
//
//                       'assets/BackGround/MathBackGround1.jpeg'
//               ),
//               fit: BoxFit.cover,
//               colorFilter: ColorFilter.mode(
//                 themeProvider.isNightModeOn
//                     ? Colors.black.withOpacity(0.6)
//                     : Colors.black.withOpacity(0.2),
//                 BlendMode.darken,
//               ),
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   SizedBox(height: 16),
//                   Text(
//                     'Choose Your Math Adventure!',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'ComicSans',
//                       color: Colors.white,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black26,
//                           blurRadius: 4,
//                           offset: Offset(2, 2),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 24),
//                   Expanded(
//                     child: GridView.count(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 20,
//                       mainAxisSpacing: 20,
//                       childAspectRatio: 0.9,
//                       children: [
//                         _buildOperationCard(
//                           context: context,
//                           title: 'Addition',
//                           icon: FontAwesomeIcons.plus,
//                           color: getOperationColor('Addition'),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SumOperations(grade: widget.gradeNumber),
//                               ),
//                             );
//                           },
//                         ),
//                         _buildOperationCard(
//                           context: context,
//                           title: 'Subtraction',
//                           icon: FontAwesomeIcons.minus,
//                           color: getOperationColor('Subtraction'),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SubtractionOperations(grade: widget.gradeNumber),
//                               ),
//                             );
//                           },
//                         ),
//                         _buildOperationCard(
//                           context: context,
//                           title: 'Multiplication',
//                           icon: FontAwesomeIcons.times,
//                           color: getOperationColor('Multiplication'),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => MultiplicationOperations(grade: widget.gradeNumber),
//                               ),
//                             );
//                           },
//                         ),
//                         _buildOperationCard(
//                           context: context,
//                           title: 'Division',
//                           icon: FontAwesomeIcons.divide,
//                           color: getOperationColor('Division'),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => DivisionOperations(grade: widget.gradeNumber),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOperationCard({
//     required BuildContext context,
//     required String title,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return Hero(
//       tag: title,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [color.withOpacity(0.8), color],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: themeProvider.isNightModeOn
//                   ? Colors.black.withOpacity(0.5)
//                   : Colors.black.withOpacity(0.2),
//               blurRadius: 15,
//               offset: Offset(0, 8),
//             ),
//           ],
//           border: Border.all(color: cardBorderColor, width: 2),
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: onPressed,
//             borderRadius: BorderRadius.circular(24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AnimatedScale(
//                   scale: 1.1,
//                   duration: Duration(milliseconds: 200),
//                   child: CircleAvatar(
//                     radius: 40,
//                     backgroundColor: themeProvider.isNightModeOn
//                         ? Colors.grey.shade800
//                         : Colors.white.withOpacity(0.9),
//                     child: Icon(
//                       icon,
//                       size: 40,
//                       color: color,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'ComicSans',
//                     color: Colors.white,
//                     shadows: [
//                       Shadow(
//                         color: Colors.black38,
//                         blurRadius: 6,
//                         offset: Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'Math/DivisionOperations.dart';
import 'Math/MultiplicationOperations.dart';
import 'Math/SubtractionOperations.dart';
import 'Math/SumOperations.dart';
import 'Setting.dart';

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

  List<Map<String, dynamic>> getOperations() {
    return [
      {
        'title': 'Addition',
        'icon': FontAwesomeIcons.plus,
        'color': themeProvider.isNightModeOn ? Color(0xFF66BB6A) : Color(0xFFFF9800),
        'route': SumOperations(grade: widget.gradeNumber),
        'description': 'Master addition skills',
      },
      {
        'title': 'Subtraction',
        'icon': FontAwesomeIcons.minus,
        'color': themeProvider.isNightModeOn ? Color(0xFFEF5350) : Color(0xFFE53935),
        'route': SubtractionOperations(grade: widget.gradeNumber),
        'description': 'Practice subtraction',
      },
      {
        'title': 'Multiplication',
        'icon': FontAwesomeIcons.times,
        'color': themeProvider.isNightModeOn ? Color(0xFFFFCA28) : Color(0xFF4CAF50),
        'route': MultiplicationOperations(grade: widget.gradeNumber),
        'description': 'Learn multiplication',
      },
      {
        'title': 'Division',
        'icon': FontAwesomeIcons.divide,
        'color': themeProvider.isNightModeOn ? Color(0xFF42A5F5) : Color(0xFF2196F3),
        'route': DivisionOperations(grade: widget.gradeNumber),
        'description': 'Explore division',
      },
    ];
  }

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
              image: AssetImage('assets/BackGround/MathBackGround1.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                themeProvider.isNightModeOn
                    ? Colors.black.withOpacity(0.7)
                    : Colors.black.withOpacity(0.2),
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
                          color: Colors.white.withOpacity(0.2),
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
                    color:themeProvider.isNightModeOn ? Colors.white.withOpacity(0.5) :Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
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
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
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
                            color: Colors.white.withOpacity(0.9),
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
}