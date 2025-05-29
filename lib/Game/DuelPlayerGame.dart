// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// class DuelPlayerGame extends StatefulWidget {
//   const DuelPlayerGame({super.key});
//
//   @override
//   _DuelPlayerGameState createState() => _DuelPlayerGameState();
// }
//
// class _DuelPlayerGameState extends State<DuelPlayerGame> {
//   int player1Score = 0; // Bottom player
//   int player2Score = 0; // Top player
//
//   int? player1SelectedAnswer;
//   int? player2SelectedAnswer;
//
//   late int firstNumber =Random().nextInt(10) + 1;
//   late int secondNumber =Random().nextInt(10) + 1;
//
//   late int correctAnswer;
//   late List<int> answers;
//
//   int currentQuestionNumber = 1;
//   final int maxQuestions = 20;
//
//   bool player1HasAnswered = false;
//   bool player2HasAnswered = false;
//
//   @override
//   void initState() {
//     super.initState();
//     correctAnswer = firstNumber * secondNumber;
//     generateAnswers();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void generateNewQuestion() {
//     if (currentQuestionNumber >= maxQuestions) {
//       showScoreDialog();
//       return;
//     }
//
//     setState(() {
//       currentQuestionNumber++;
//       firstNumber = Random().nextInt(10) + 1;
//       secondNumber = Random().nextInt(10) + 1;
//       correctAnswer = firstNumber * secondNumber;
//       generateAnswers();
//       player1SelectedAnswer = null;
//       player2SelectedAnswer = null;
//       player1HasAnswered = false;
//       player2HasAnswered = false;
//     });
//   }
//
//   void generateAnswers() {
//     answers = [
//       correctAnswer,
//       (correctAnswer + Random().nextInt(10) - 5).clamp(1, 100),
//       (correctAnswer + Random().nextInt(15) - 10).clamp(1, 100),
//       (correctAnswer + Random().nextInt(20) - 15).clamp(1, 100),
//     ]..shuffle();
//   }
//
//   void handlePlayer1Answer(int answer) {
//     if (player1HasAnswered) return;
//
//     setState(() {
//       player1SelectedAnswer = answer;
//       player1HasAnswered = true;
//
//       if (answer == correctAnswer) {
//         player1Score += 10;
//       }
//
//       // Check if both players have answered
//       checkBothPlayersAnswered();
//     });
//   }
//
//   void handlePlayer2Answer(int answer) {
//     if (player2HasAnswered) return;
//
//     setState(() {
//       player2SelectedAnswer = answer;
//       player2HasAnswered = true;
//
//       if (answer == correctAnswer) {
//         player2Score += 10;
//       }
//
//       // Check if both players have answered
//       checkBothPlayersAnswered();
//     });
//   }
//
//   void checkBothPlayersAnswered() {
//     if (player1HasAnswered && player2HasAnswered) {
//       Future.delayed(Duration(milliseconds: 200), () {
//         generateNewQuestion();
//       });
//     }
//   }
//
//   void showScoreDialog() {
//     String winner;
//     if (player1Score > player2Score) {
//       winner = "Player 1 wins!";
//     } else if (player2Score > player1Score) {
//       winner = "Player 2 wins!";
//     } else {
//       winner = "It's a tie!";
//     }
//
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Game Over'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(winner, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                 SizedBox(height: 20),
//                 Text('Final Scores:'),
//                 SizedBox(height: 10),
//                 Text('Player 1: $player1Score points',
//                     style: TextStyle(color: Colors.blue.shade700)),
//                 Text('Player 2: $player2Score points',
//                     style: TextStyle(color: Colors.indigo)),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 child: Text('Play Again'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   restartGame();
//                 },
//               ),
//               TextButton(
//                 child: Text('Exit'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         }
//     );
//   }
//
//   void restartGame() {
//     setState(() {
//       player1Score = 0;
//       player2Score = 0;
//       currentQuestionNumber = 1;
//       player1SelectedAnswer = null;
//       player2SelectedAnswer = null;
//       player1HasAnswered = false;
//       player2HasAnswered = false;
//       firstNumber = Random().nextInt(10) + 1;
//       secondNumber = Random().nextInt(10) + 1;
//       correctAnswer = firstNumber * secondNumber;
//       generateAnswers();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Math Duel',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.indigo,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 16.0),
//               child: Text(
//                 '$currentQuestionNumber/$maxQuestions',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.indigo.shade50,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.indigo.shade100, Colors.indigo.shade50],
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   SizedBox(height: 16),
//                   // Player 2 game panel (top, rotated)
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Transform.rotate(
//                       angle: pi, // Rotate 180 degrees
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(
//                             'Player 2',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.indigo,
//                             ),
//                           ),
//                           SizedBox(height: 12),
//                           Container(
//                             padding: EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.indigo.shade50,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Text(
//                               '$firstNumber × $secondNumber = ?',
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.indigo.shade800,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           GridView.count(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             crossAxisCount: 2,
//                             mainAxisSpacing: 10,
//                             crossAxisSpacing: 10,
//                             childAspectRatio: 2.5,
//                             children: answers.map((answer) {
//                               bool isSelected = player2SelectedAnswer == answer;
//                               bool isCorrect = answer == correctAnswer;
//
//                               return ElevatedButton(
//                                 onPressed: player2HasAnswered ? null : () => handlePlayer2Answer(answer),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: isSelected
//                                       ? (isCorrect
//                                       ? Colors.green.shade500
//                                       : Colors.red.shade500)
//                                       : Colors.white,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                     side: BorderSide(
//                                       color: Colors.indigo.shade200,
//                                       width: 1,
//                                     ),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: 12,
//                                     horizontal: 20,
//                                   ),
//                                   elevation: 2,
//                                 ),
//                                 child: Text(
//                                   '$answer',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: isSelected
//                                         ? Colors.white
//                                         : Colors.indigo.shade800,
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // Middle score indicator
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 16.0),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         // Score line
//                         Container(
//                           height: 8,
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [Colors.blue.shade600, Colors.indigo.shade600],
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                             ),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ),
//
//                         // VS badge
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.red.shade600,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: 4,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Text(
//                             'VS',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//
//                         // Player 1 score
//                         Positioned(
//                           left: 0,
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: Colors.blue.shade600,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Text(
//                               '$player1Score',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         // Player 2 score
//                         Positioned(
//                           right: 0,
//                           child: Container(
//                             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: Colors.indigo.shade600,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Text(
//                               '$player2Score',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Player 1 game panel (bottom)
//                   Container(
//                     padding: const EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'Player 1',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue.shade700,
//                           ),
//                         ),
//                         SizedBox(height: 12),
//                         Container(
//                           padding: EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.shade50,
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Text(
//                             '$firstNumber × $secondNumber = ?',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue.shade800,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         GridView.count(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           crossAxisCount: 2,
//                           mainAxisSpacing: 10,
//                           crossAxisSpacing: 10,
//                           childAspectRatio: 2.5,
//                           children: answers.map((answer) {
//                             bool isSelected = player1SelectedAnswer == answer;
//                             bool isCorrect = answer == correctAnswer;
//
//                             return ElevatedButton(
//                               onPressed: player1HasAnswered ? null : () => handlePlayer1Answer(answer),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: isSelected
//                                     ? (isCorrect
//                                     ? Colors.green.shade500
//                                     : Colors.red.shade500)
//                                     : Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   side: BorderSide(
//                                     color: Colors.blue.shade200,
//                                     width: 1,
//                                   ),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: 12,
//                                   horizontal: 20,
//                                 ),
//                                 elevation: 2,
//                               ),
//                               child: Text(
//                                 '$answer',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: isSelected
//                                       ? Colors.white
//                                       : Colors.blue.shade800,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
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
// }

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../Math/Operations.dart';

class DuelPlayerGame extends StatefulWidget {
  final int grade;

  const DuelPlayerGame({
    super.key,
    this.grade = 2, // Default to grade 2 if not specified
  });

  @override
  _DuelPlayerGameState createState() => _DuelPlayerGameState();
}

class _DuelPlayerGameState extends State<DuelPlayerGame> {
  int player1Score = 0; // Bottom player
  int player2Score = 0; // Top player

  double? player1SelectedAnswer;
  double? player2SelectedAnswer;

  dynamic firstNumber;
  dynamic secondNumber;
  dynamic thirdNumber;
  dynamic forthNumber;
  String sign = "";

  double correctAnswer = 0.0;
  late List<double> answers;

  int currentQuestionNumber = 1;
  final int maxQuestions = 20;

  bool player1HasAnswered = false;
  bool player2HasAnswered = false;

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  // Enhanced _parseNumber to handle edge cases
  double _parseNumber(dynamic value) {
    if (value == null) {
      print('Warning: _parseNumber received null value');
      return 0.0;
    }
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) {
      try {
        String cleanedValue = value.replaceAll(RegExp(r'\.0+$'), '');
        return double.parse(cleanedValue);
      } catch (e) {
        print('Warning: Failed to parse string "$value" as double: $e');
        return 0.0;
      }
    }
    print('Warning: Unexpected type for _parseNumber: ${value.runtimeType}');
    return 0.0;
  }

  // Updated _generateDistractor to ensure double return type
  double _generateDistractor(double correct, int operationType, {int offset = 10}) {
    double numericCorrect = correct;

    switch (operationType) {
      case 0: // Addition
      case 1: // Subtraction
        return (numericCorrect + (Random().nextInt(20) - 10 + offset)).toDouble();
      case 2: // Multiplication
        double randomFactor = 1 + (Random().nextDouble() * 0.5 - 0.25);
        return double.parse(((numericCorrect * randomFactor) + offset).toStringAsFixed(2));
      case 3: // Division
        return double.parse(
            ((numericCorrect * (1 + (Random().nextDouble() * 0.5 - 0.25))) + offset)
                .toStringAsFixed(2));
      default:
        return (numericCorrect + offset).toDouble();
    }
  }

  // Updated generateQuestion to ensure answers is List<double>
  void generateQuestion() {
    int grade = Random().nextInt(3) + 1;
    final operationType = Random().nextInt(4);
    late List<Map<String, dynamic>> operations;

    switch (operationType) {
      case 0:
        operations = Operations.getSumOperations(grade);
        sign = "+";
        break;
      case 1:
        operations = Operations.getSubtractionOperations(grade);
        sign = "-";
        break;
      case 2:
        operations = Operations.getMultiplicationOperations(grade);
        sign = "×";
        break;
      case 3:
        operations = Operations.getDivisionOperations(grade);
        sign = "÷";
        break;
      default:
        operations = Operations.getSumOperations(grade);
        sign = "+";
        break;
    }

    if (operations.isEmpty) {
      print('Warning: Operations list is empty for grade $grade, operation $operationType');
      // Normalize firstNumber and secondNumber to double
      firstNumber = (Random().nextInt(10) + 1).toDouble();
      secondNumber = (Random().nextInt(10) + 1).toDouble();
      thirdNumber = null;
      forthNumber = null;
      correctAnswer = (firstNumber + secondNumber).toDouble();

      // Explicitly ensure all answers are double
      answers = [
        correctAnswer,
        (correctAnswer + 2).toDouble(),
        (correctAnswer - 3).toDouble(),
        (correctAnswer + 5).toDouble(),
      ]..shuffle();
      print('Fallback answers: $answers (type: ${answers.runtimeType})');
      return;
    }

    int operationIndex = Random().nextInt(operations.length);
    final currentOperation = operations[operationIndex];
    final numbers = currentOperation["generateNumbers"]();

    firstNumber = numbers["number1"];
    secondNumber = numbers["number2"];
    thirdNumber = null;
    forthNumber = null;
    correctAnswer = _parseNumber(numbers["result"]);

    print('Generated question: $firstNumber $sign $secondNumber = $correctAnswer');
    print('Correct answer type: ${correctAnswer.runtimeType}');

    try {
      answers = [
        correctAnswer,
        _generateDistractor(correctAnswer, operationType),
        _generateDistractor(correctAnswer, operationType, offset: -5),
        _generateDistractor(correctAnswer, operationType, offset: 12),
      ].cast<double>()..shuffle(); // Explicitly cast to List<double>
      print('Answers: $answers (type: ${answers.runtimeType})');
    } catch (e) {
      print("Error generating answers: $e");
      // Fallback with explicit double values
      answers = [
        correctAnswer,
        (correctAnswer + 2).toDouble(),
        (correctAnswer - 3).toDouble(),
        (correctAnswer + 5).toDouble(),
      ]..shuffle();
      print('Fallback answers: $answers (type: ${answers.runtimeType})');
    }

    setState(() {
      player1SelectedAnswer = null;
      player2SelectedAnswer = null;
      player1HasAnswered = false;
      player2HasAnswered = false;
    });
  }

  void generateNewQuestion() {
    if (currentQuestionNumber >= maxQuestions) {
      showScoreDialog();
      return;
    }

    setState(() {
      currentQuestionNumber++;
      generateQuestion();
    });
  }

  void handlePlayer1Answer(double answer) {
    if (player1HasAnswered) return;

    setState(() {
      player1SelectedAnswer = answer;
      player1HasAnswered = true;

      print('Player 1 selected: $answer (type: ${answer.runtimeType})');
      print('Correct answer: $correctAnswer (type: ${correctAnswer.runtimeType})');

      double answerValue = answer;
      double correctValue = correctAnswer;

      if (answerValue == correctValue) {
        player1Score += 10;
        Future.delayed(Duration(milliseconds: 400), () {
          generateNewQuestion();
        });
      } else {
        checkBothPlayersAnswered();
      }
    });
  }

  void handlePlayer2Answer(double answer) {
    if (player2HasAnswered) return;

    setState(() {
      player2SelectedAnswer = answer;
      player2HasAnswered = true;

      print('Player 2 selected: $answer (type: ${answer.runtimeType})');
      print('Correct answer: $correctAnswer (type: ${correctAnswer.runtimeType})');

      double answerValue = answer;
      double correctValue = correctAnswer;

      if (answerValue == correctValue) {
        player2Score += 10;
        Future.delayed(Duration(milliseconds: 400), () {
          generateNewQuestion();
        });
      } else {
        checkBothPlayersAnswered();
      }
    });
  }

  void checkBothPlayersAnswered() {
    if (player1HasAnswered && player2HasAnswered) {
      Future.delayed(Duration(milliseconds: 200), () {
        generateNewQuestion();
      });
    }
  }

  void showScoreDialog() {
    String winner;
    if (player1Score > player2Score) {
      winner = "Player 1 wins!";
    } else if (player2Score > player1Score) {
      winner = "Player 2 wins!";
    } else {
      winner = "It's a tie!";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(winner, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 20),
              Text('Final Scores:'),
              SizedBox(height: 10),
              Text('Player 1: $player1Score points',
                  style: TextStyle(color: Colors.blue.shade700)),
              Text('Player 2: $player2Score points',
                  style: TextStyle(color: Colors.indigo)),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                restartGame();
              },
            ),
            TextButton(
              child: Text('Exit'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void restartGame() {
    setState(() {
      player1Score = 0;
      player2Score = 0;
      currentQuestionNumber = 1;
      player1SelectedAnswer = null;
      player2SelectedAnswer = null;
      player1HasAnswered = false;
      player2HasAnswered = false;
      generateQuestion();
    });
  }

  String _formatNumber(dynamic number) {
    if (number is int) return number.toString();
    if (number is double) {
      if (number == number.truncateToDouble()) {
        return number.toInt().toString();
      }
      return number.toStringAsFixed(2).replaceAll(RegExp(r'\.0+$'), '');
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Math Duel',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '$currentQuestionNumber/$maxQuestions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.indigo.shade100, Colors.indigo.shade50],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  // Player 2 game panel (top, rotated)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Transform.rotate(
                      angle: pi,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Player 2',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${_formatNumber(firstNumber)} $sign ${_formatNumber(secondNumber)} = ?',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2.5,
                            children: answers.map((answer) {
                              bool isSelected = player2SelectedAnswer == answer;
                              bool isCorrect = answer == correctAnswer;

                              return ElevatedButton(
                                onPressed: player2HasAnswered ? null : () => handlePlayer2Answer(answer),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? (isCorrect
                                      ? Colors.green.shade500
                                      : Colors.red.shade500)
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: Colors.indigo.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 20,
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  _formatNumber(answer),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.indigo.shade800,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Middle score indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue.shade600, Colors.indigo.shade600],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'VS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '$player1Score',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade600,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '$player2Score',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Player 1 game panel (bottom)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Player 1',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${_formatNumber(firstNumber)} $sign ${_formatNumber(secondNumber)} = ?',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2.5,
                          children: answers.map((answer) {
                            bool isSelected = player1SelectedAnswer == answer;
                            bool isCorrect = answer == correctAnswer;

                            return ElevatedButton(
                              onPressed: player1HasAnswered ? null : () => handlePlayer1Answer(answer),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? (isCorrect
                                    ? Colors.green.shade500
                                    : Colors.red.shade500)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.blue.shade200,
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 20,
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                _formatNumber(answer),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.blue.shade800,
                                ),
                              ),
                            );
                          }).toList(),
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
}