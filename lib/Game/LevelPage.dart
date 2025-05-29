// import 'package:flutter/material.dart';
// import 'package:mathblast/Game/InputAnswerGame.dart';
// import 'package:mathblast/Game/MissingValueGame.dart';
// import 'package:mathblast/Game/TrueFalseGame.dart';
// import 'package:mathblast/Game/SoloPlayerGame.dart';
//
// class LevelPage extends StatelessWidget {
//   final String title;
//   final Color themeColor;
//   final int totalLevels;
//   final int totalQuestions;
//
//   const LevelPage({
//     Key? key,
//     required this.title,
//     this.themeColor = Colors.green,
//     this.totalLevels = 60,
//     this.totalQuestions = 600,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[200],
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Colored card with title, total levels and questions
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: themeColor,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         // Left side - Total Levels
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Text(
//                                 '$totalLevels',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 32,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               const Text(
//                                 'Total Levels',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         // Center divider
//                         Container(
//                           height: 50,
//                           width: 1,
//                           color: Colors.white,
//                         ),
//
//                         // Right side - Total Question
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Text(
//                                 '$totalQuestions',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 32,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               const Text(
//                                 'Total Question',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//
//               Expanded(
//                 child: GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     childAspectRatio: 0.9,
//                   ),
//                   itemCount: totalLevels <= 60 ? totalLevels : 60,
//                   itemBuilder: (context, index) {
//                     final levelNumber = index + 1;
//                     return LevelCard(
//                       levelNumber: levelNumber,
//                       themeColor: themeColor,
//                       onTap: () {
//                         int grade = ((levelNumber - 1) ~/ 12) + 1;
//                         if (grade > 5) grade = 5;
//                         Widget targetPage;
//                         switch (title) {
//                           case 'Single Player':
//                             targetPage = SoloPlayerGame(
//                               grade: grade,
//                               level: levelNumber,
//                               title: title,
//                             );
//                             break;
//                           case 'Input Answer':
//                             targetPage = InputAnswerGame(
//                               grade: grade,
//                               level: levelNumber,
//                               title: title,
//                             );
//                             break;
//                           case 'True False':
//                             targetPage = TrueFalseGame(
//                               grade: grade,
//                               level: levelNumber,
//                               title: title,
//                             );
//                             break;
//                           case 'Missing value':
//                             targetPage = MissingValueGame(
//                               grade: grade,
//                               level: levelNumber,
//                               title: title,
//                             );
//                             break;
//                           default:
//                           // Default to MissingValueGame if title doesn't match
//                             targetPage = MissingValueGame(
//                               grade: grade,
//                               level: levelNumber,
//                               title: title,
//                             );
//                             break;
//                         }
//
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => targetPage),
//                         );
//
//                        },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class LevelCard extends StatelessWidget {
//   final int levelNumber;
//   final Color themeColor;
//   final VoidCallback? onTap;
//   final int stars; // Number of filled stars (0-3)
//
//   const LevelCard({
//     Key? key,
//     required this.levelNumber,
//     this.themeColor = Colors.green,
//     this.onTap,
//     this.stars = 0,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         color: Colors.white,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Circle with level number
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   '$levelNumber',
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 12),
//
//             // Three stars
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 3,
//                     (index) => Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 2),
//                   child: Icon(
//                     index < stars ? Icons.star : Icons.star_border,
//                     color: themeColor,
//                     size: 18,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:mathblast/Game/InputAnswerGame.dart';
import 'package:mathblast/Game/MissingValueGame.dart';
import 'package:mathblast/Game/TrueFalseGame.dart';
import 'package:mathblast/Game/SoloPlayerGame.dart';

import '../Database.dart';

class LevelPage extends StatefulWidget {
  final String title;
  final Color themeColor;

  const LevelPage({
    Key? key,
    required this.title,
    this.themeColor = Colors.green,
  }) : super(key: key);

  @override
  _LevelPageState createState() => _LevelPageState();
}

//#region LevelPageState
class _LevelPageState extends State<LevelPage> {
  List<Map<String, dynamic>> levels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLevels();
  }

  // Future<void> fetchLevels() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     // Initialize the database and ensure all tables are created
  //     await MathBlastDatabase.instance.database;
  //
  //     // Fetch levels from the appropriate table
  //     final List<Map<String, dynamic>> fetchedLevels =
  //     await MathBlastDatabase.instance.getAllRecords(getTableName());
  //
  //     print("Fetched ${fetchedLevels.length} levels for ${widget.title}");
  //
  //     // Update the UI with the fetched levels
  //     setState(() {
  //       levels = fetchedLevels;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print("Error fetching levels: $e");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  Future<void> fetchLevels() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 🧠 This ensures DB is initialized (good!)
      await MathBlastDatabase.instance.database;

      // ✅ Gets the table name based on widget.title
      final List<Map<String, dynamic>> fetchedLevels =
      await MathBlastDatabase.instance.getAllRecords(getTableName());

      print("Fetched ${fetchedLevels.length} levels for ${widget.title}");

      // ✅ Update state with fetched levels
      setState(() {
        levels = fetchedLevels;
        isLoading = false;
      });

      // 🔍 Print star values to debug
      for (var level in fetchedLevels) {
        print("⭐ Level ${level['LevelNumber']} → Stars: ${level['LevelStar']}, Score: ${level['LevelScore']}");
      }

    } catch (e) {
      print("Error fetching levels: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  String getTableName() {
    switch (widget.title) {
      case 'Single Player':
        return 'SoloPlayerLevel';
      case 'Input Answer':
        return 'InputAnswerLevel';
      case 'True False':
        return 'TrueFalseLevel';
      case 'Missing value':
        return 'MissingValueLevel';
      default:
        return 'MissingValueLevel';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        extendBodyBehindAppBar: true,
        body: isLoading
            ? Center(child: CircularProgressIndicator(color: widget.themeColor))
            : Column(
          children: [
            // Curved header with game type and stats
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.themeColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.themeColor.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_circle_left_outlined,
                              color: Colors.white,size: 30,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildStatCard('${levels.length}', 'Levels'),
                          _buildStatCard('${levels.length * 10}', 'Questions'),
                          _buildStatCard(
                              '${levels.fold<int>(0, (sum, level) => sum + (level['LevelStar'] ?? 0) as int)}',
                              'Stars'
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Level selection heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Select Level',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: widget.themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Progress: ${_calculateProgress()}%',
                      style: TextStyle(
                        color: widget.themeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Grid of level cards
            Expanded(
              child: levels.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No levels found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try restarting the app',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    final levelData = levels[index];
                    final levelNumber = levelData['LevelNumber'];
                    final stars = levelData['LevelStar'] ?? 0;
                    final score = levelData['LevelScore'] ?? 0;
                    final isLocked = index > 0 && levels[index-1]['LevelStar'] == 0;

                    return LevelCard(
                      levelNumber: levelNumber,
                      themeColor: widget.themeColor,
                      stars: stars,
                      score: score,
                      isLocked: isLocked,
                      onTap: isLocked ? null : () {
                        int grade = ((levelNumber - 1) ~/ 12) + 1;
                        if (grade > 5) grade = 5;
                        Widget targetPage;
                        switch (widget.title) {
                          case 'Single Player':
                            targetPage = SoloPlayerGame(
                              grade: grade,
                              level: levelNumber,
                              title: widget.title,
                            );
                            break;
                          case 'Input Answer':
                            targetPage = InputAnswerGame(
                              grade: grade,
                              level: levelNumber,
                              title: widget.title,
                            );
                            break;
                          case 'True False':
                            targetPage = TrueFalseGame(
                              grade: grade,
                              level: levelNumber,
                              title: widget.title,
                            );
                            break;
                          case 'Missing value':
                            targetPage = MissingValueGame(
                              grade: grade,
                              level: levelNumber,
                              title: widget.title,
                            );
                            break;
                          default:
                            targetPage = MissingValueGame(
                              grade: grade,
                              level: levelNumber,
                              title: widget.title,
                            );
                            break;
                        }

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_,__,___) => targetPage,
                              transitionDuration: Duration(milliseconds: 500),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              }),
                        ).then((_) {
                          fetchLevels();
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Card(
        color: Colors.white.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateProgress() {
    if (levels.isEmpty) return '0';

    int totalStars = levels.length * 3;
    int earnedStars = levels.fold<int>(0, (sum, level) => sum + (level['LevelStar'] ?? 0) as int);

    double percentage = (earnedStars / totalStars) * 100;
    return percentage.toStringAsFixed(0);
  }
}
//#endregion

//#region LevelCard

class LevelCard extends StatelessWidget {
  final int levelNumber;
  final Color themeColor;
  final VoidCallback? onTap;
  final int stars;
  final int score;
  final bool isLocked;

  const LevelCard({
    Key? key,
    required this.levelNumber,
    this.themeColor = Colors.green,
    this.onTap,
    this.stars = 0,
    this.score = 0,
    this.isLocked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isLocked ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isLocked
                  ? Colors.grey.withOpacity(0.3)
                  : themeColor.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Level number circle
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLocked
                        ? Colors.grey[300]
                        : stars > 0
                        ? themeColor.withOpacity(0.15)
                        : Colors.grey[100],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLocked
                        ? Colors.grey[400]
                        : stars > 0
                        ? themeColor.withOpacity(0.3)
                        : Colors.grey[200],
                  ),
                  child: Center(
                    child: isLocked
                        ? const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 20,
                    )
                        : Text(
                      '$levelNumber',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: stars > 0 ? themeColor : Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: index < stars
                        ? themeColor
                        : isLocked
                        ? Colors.grey[400]
                        : Colors.grey[300],
                    size: 16,
                  ),
                ),
              ),
            ),

            if (score > 0 && !isLocked) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
//#endregion
