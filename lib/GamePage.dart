import 'package:flutter/material.dart';
import 'Game/DuelPlayerGame.dart';
import 'Game/LevelPage.dart';
import 'package:provider/provider.dart';

import 'Setting.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isNightModeOn;

    // Theme colors
    final mainBgGradient = isDarkMode
        ? [Color(0xFF121212), Color(0xFF262626)]
        : [Color(0xFFE0F2F1), Color(0xFFB2DFDB)];

    final cardColors = [
      isDarkMode ? Color(0xFFE91E63) : Color(0xFFFF4D79), // Pink
      isDarkMode ? Color(0xFF00C853) : Color(0xFF2ECB71), // Green
      isDarkMode ? Color(0xFF2196F3) : Color(0xFF3498DB), // Blue
      isDarkMode ? Color(0xFF9C27B0) : Color(0xFFAB4BDB), // Purple
      isDarkMode ? Color(0xFF00BCD4) : Color(0xFF36D1DC), // Cyan
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: mainBgGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Game Modes',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        letterSpacing: 1.2,
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85, // Adjusted to prevent overflow
                    ),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final gameOptions = [
                        {
                          'title': 'Single Player',
                          'color': cardColors[0],
                          'page': LevelPage(title: 'Single Player', themeColor: Colors.pinkAccent),
                          'icon': 'assets/icons/SinglePlayer.png',
                          'description': 'Solo gameplay'
                        },
                        {
                          'title': 'Duel Player',
                          'color': cardColors[1],
                          'page': DuelPlayerGame(),
                          'icon': 'assets/icons/multiplayer.png',
                          'description': 'Play with friends'
                        },
                        {
                          'title': 'Input Answer',
                          'color': cardColors[2],
                          'page': LevelPage(title: 'Input Answer', themeColor: Colors.blueAccent),
                          'icon': 'assets/icons/InputText.png',
                          'description': 'Type your answers'
                        },
                        {
                          'title': 'True False',
                          'color': cardColors[3],
                          'page': LevelPage(title: 'True False', themeColor: Colors.purpleAccent),
                          'icon': 'assets/icons/TrueFalse.png',
                          'description': 'Yes or no questions'
                        },
                        {
                          'title': 'Missing Value',
                          'color': cardColors[4],
                          'page': LevelPage(title: 'Missing value', themeColor: Colors.lightBlueAccent),
                          'icon': 'assets/icons/MissingValue.png',
                          'description': 'Find the missing piece'
                        },
                      ];

                      return _buildGameCard(
                        context,
                        gameOptions[index]['title'] as String,
                        gameOptions[index]['color'] as Color,
                        gameOptions[index]['page'] as Widget,
                        gameOptions[index]['icon'] as String,
                        gameOptions[index]['description'] as String,
                        isDarkMode,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //#region Build Game Card
  Widget _buildGameCard(
      BuildContext context,
      String title,
      Color color,
      Widget page,
      String iconPath,
      String description,
      bool isDarkMode,
      ) {
    return Hero(
      tag: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          },
          borderRadius: BorderRadius.circular(24),
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
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(isDarkMode ? 0.5 : 0.3),
                  blurRadius: 20,
                  spreadRadius: -5,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Decorative elements for background
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
                    left: -5,
                    top: -5,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  // Content container with fixed height constraints to prevent overflow
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Image.asset(
                            iconPath,
                            width: 28,
                            height: 28,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
}