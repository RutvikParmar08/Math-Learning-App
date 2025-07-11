import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../Database.dart';
import '../Math/Operations.dart';

class TrueFalseGame extends StatefulWidget {
  final int grade;
  final int level;
  final String title;

  const TrueFalseGame({
    super.key,
    required this.grade,
    required this.level,
    required this.title,
  });

  @override
  _TrueFalseGameState createState() => _TrueFalseGameState();
}

class _TrueFalseGameState extends State<TrueFalseGame> {
  //#region Variables
  int score = 0;
  int currentQuestion = 1;
  int totalQuestions = 10;
  int correctAnswersCount = 0;
  int wrongAnswers = 0;

  late int timeLeft;
  int savedScore = 0;
  late int maxTime;
  late int levelScore;
  late int scoreIncrement;
  late int scoreDecrement;

  Timer? timer;
  int lives = 3;
  bool? selectedAnswer;

  late Map<String, dynamic> currentOperation;
  late dynamic firstNumber;
  late dynamic secondNumber;
  dynamic thirdNumber;
  dynamic forthNumber;
  late String sign;
  late dynamic correctAnswer;
  late dynamic displayedAnswer;

  late bool _isVibrationOn = false;

  //#endregion

  //#region Init state , Dispose , Load Score
  @override
  void initState() {
    super.initState();
    setMaxTimeForGrade();
    setLevelScoreForGrade();
    generateQuestion();
    startTimer();
    loadScoreFromDatabase();
    _loadPreferences();

  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadScoreFromDatabase() async {
    String tableName = 'TrueFalseLevel';

        if (tableName.isNotEmpty) {
      final record = await MathBlastDatabase.instance.getRecordById(
          tableName, widget.level);
      setState(() {
        savedScore = record?['LevelScore'] ?? 0;
      });
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVibrationOn = prefs.getBool('isVibrationOn') ?? false;
    });
  }
  //#endregion

  //#region Set Timer And Level Score
  void setMaxTimeForGrade() {
    switch (widget.grade) {
      case 1:
        maxTime = 20;
        break;
      case 2:
        maxTime = 20;
        break;
      case 3:
        maxTime = 25;
        break;
      case 4:
        maxTime = 30;
        break;
      case 5:
        maxTime = 40;
        break;
      default:
        maxTime = 20;
        break;
    }

    timeLeft = maxTime;
  }

  void setLevelScoreForGrade() {
    switch (widget.grade) {
      case 1:
        levelScore = 200;
        scoreIncrement = 20;
        scoreDecrement = 10;
        break;
      case 2:
        levelScore = 300;
        scoreIncrement = 30;
        scoreDecrement = 15;
        break;
      case 3:
        levelScore = 350;
        scoreIncrement = 35;
        scoreDecrement = 18;
        break;
      case 4:
        levelScore = 400;
        scoreIncrement = 40;
        scoreDecrement = 20;
        break;
      case 5:
        levelScore = 500;
        scoreIncrement = 50;
        scoreDecrement = 25;
        break;
      default:
        levelScore = 200;
        scoreIncrement=20;
        scoreDecrement=10;
        break;
    }
  }

  //#endregion

  //#region Start Timer
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          handleTimeUp();
        }
      });
    });
  }
  //#endregion

  //#region Handle Time Up
  void handleTimeUp() {
    setState(() {
      timeLeft = maxTime;
      wrongAnswers++;
      currentQuestion++;
      lives--;
      generateQuestion();
      selectedAnswer = null;
    });

    checkGameOver();
    if (lives > 0 && currentQuestion <= totalQuestions) {
      startTimer();
    }
  }
  //#endregion

  //#region Generate Question
  void generateQuestion() {
    final operationType = Random().nextInt(4);
    late List<Map<String, dynamic>> operations;
    bool isWordProblem = false;

    switch (operationType) {
      case 0:
        operations = Operations.getSumOperations(widget.grade);
        sign = "+";
        break;
      case 1:
        operations = Operations.getSubtractionOperations(widget.grade);
        sign = "-";
        break;
      case 2:
        operations = Operations.getMultiplicationOperations(widget.grade);
        sign = "×";
        break;
      case 3:
        operations = Operations.getDivisionOperations(widget.grade);
        sign = "÷";
        break;
      default:
        operations = Operations.getSumOperations(widget.grade);
        sign = "+";
        break;
    }

    if (operations.isEmpty) {
      firstNumber = Random().nextInt(50);
      secondNumber = Random().nextInt(50);
      thirdNumber = null;
      forthNumber = null;
      correctAnswer = firstNumber + secondNumber;
      displayedAnswer = Random().nextBool() ? correctAnswer : correctAnswer + Random().nextInt(10) - 5;
      timeLeft = maxTime;
      return;
    }

    int operationIndex = Random().nextInt(operations.length);
    currentOperation = operations[operationIndex];
    final numbers = currentOperation["generateNumbers"]();


    if (currentOperation["title"] == "Binary Addition" ||
        _isBinary(numbers["number1"]) || _isBinary(numbers["number2"])) {
      generateQuestion();
      return;
    } else if (currentOperation["title"] == "Complex Number Addition") {
      firstNumber = numbers["number1"];
      secondNumber = numbers["number2"];
      thirdNumber = null;
      forthNumber = null;
      sign = numbers["sign"] ?? "+";
      correctAnswer = numbers["result"];
      displayedAnswer = Random().nextBool()
          ? correctAnswer
          : _generateComplexDistractor(correctAnswer, operationType);
    } else if (currentOperation["title"] == "Fraction Addition") {
      firstNumber = numbers["number1"];
      secondNumber = numbers["number2"];
      thirdNumber = null;
      forthNumber = null;
      sign = numbers["sign"] ?? "+";
      correctAnswer = numbers["result"];
      displayedAnswer = Random().nextBool()
          ? correctAnswer
          : _generateFractionDistractor(correctAnswer, operationType);
    } else {
      isWordProblem = currentOperation["title"] == "Word Problem" ||
          (numbers["number1"] is String && numbers["number1"].toString().length > 20);

      if (isWordProblem) {
        firstNumber = numbers["number1"];
        secondNumber = "";
        thirdNumber = null;
        forthNumber = null;
        sign = "";
        correctAnswer = _parseNumber(numbers["result"]);
        displayedAnswer = Random().nextBool()
            ? correctAnswer
            : _generateDistractor(correctAnswer, operationType);
      } else {
        double num1 = _parseNumber(numbers["number1"]);
        double num2 = _parseNumber(numbers["number2"]);
        double? num3 = numbers["number3"] == null ? null : _parseNumber(numbers["number3"]);
        double? num4 = numbers["number4"] == null ? null : _parseNumber(numbers["number4"]);
        double result = _parseNumber(numbers["result"]);

        if (operationType == 3 && num2 == 0) {
          num2 = Random().nextInt(9) + 1.0;
        }

        firstNumber = num1 == num1.roundToDouble() ? num1.toInt() : num1;
        secondNumber = num2 == num2.roundToDouble() ? num2.toInt() : num2;
        thirdNumber = num3 == null ? null : (num3 == num3.roundToDouble() ? num3.toInt() : num3);
        forthNumber = num4 == null ? null : (num4 == num4.roundToDouble() ? num4.toInt() : num4);
        correctAnswer = result == result.roundToDouble() ? result.toInt() : result;

        displayedAnswer = Random().nextBool()
            ? correctAnswer
            : _generateDistractor(correctAnswer, operationType);
      }
    }

    timeLeft = maxTime;
    selectedAnswer = null;
  }
  //#endregion

  //#region check Binary Helper Method
  bool _isBinary(dynamic value) {
    return value is String && RegExp(r'^[01]+$').hasMatch(value);
  }
  //#endregion

  //#region Number Datatype Change into Numeric
  double _parseNumber(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      if (_isBinary(value)) return int.parse(value, radix: 2).toDouble();
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
  //#endregion

  //#region Generate Options
  //#region Generate Normal Number Option
  dynamic _generateDistractor(dynamic correct, int operationType,
      {int offset = 10}) {
    switch (operationType) {
      case 0: // Addition
        return
          correct is double ?
          double.parse(
              (correct + (Random().nextInt(20) - 10 + offset+1)).toStringAsFixed(
                  2)) :
          correct + (Random().nextInt(20) - 10 + offset);
      case 1: // Subtraction
        return
          correct is double ?
          double.parse(
              (correct + (Random().nextInt(20) - 10 + offset+1)).toStringAsFixed(
                  2)) :
          correct + (Random().nextInt(20) - 10 + offset);
      case 2: // Multiplication
        return
          correct is int ?
          double.parse(
              ((correct * (1 + (Random().nextDouble() * 0.5 - 0.25))) + offset)
                  .toInt().toString()) :
          double.parse(
              ((correct * (1 + (Random().nextDouble() * 0.5 - 0.25))) + offset)
                  .toStringAsFixed(2));


      case 3: // Division
        return double.parse(
            ((correct * (1 + (Random().nextDouble() * 0.5 - 0.25))) + offset)
                .toStringAsFixed(2));
      default:
        return correct + offset;
    }
  }

  //#endregion

  //#region Generate Complex Number Option
  String _generateComplexDistractor(String correctAnswer, int operationType) {
    // Parse the complex number
    RegExp complexPattern = RegExp(r'(-?\d+)([+-]\d+)i');
    var match = complexPattern.firstMatch(correctAnswer);

    if (match != null) {
      int realPart = int.parse(match.group(1)!);
      int imaginaryPart = int.parse(match.group(2)!);

      int strategy = Random().nextInt(5);

      switch (strategy) {
        case 0: // Change real part
          realPart += Random().nextInt(5) + 1;
          break;
        case 1: // Change imaginary part
          imaginaryPart += Random().nextInt(5) + 1;
          break;
        case 2: // Change both parts
          realPart += Random().nextInt(3) + 1;
          imaginaryPart += Random().nextInt(3) + 1;
          break;
        case 3: // Swap real and imaginary
          int temp = realPart;
          realPart = imaginaryPart;
          imaginaryPart = temp;
          break;
        case 4: // Flip sign of imaginary part
          imaginaryPart = -imaginaryPart;
          return "$realPart-${imaginaryPart.abs()}i";
      }

      return "${Random().nextInt(5)}+${Random().nextInt(5)}i";
    }
    return "${Random().nextInt(5)}+${Random().nextInt(5)}i";
  }

  //#endregion

  //#region Generate Fraction Number Option
  String _generateFractionDistractor(String correctAnswer, int operationType) {
    // Parse the fraction
    RegExp fractionPattern = RegExp(r'(-?\d+)/(-?\d+)');
    var match = fractionPattern.firstMatch(correctAnswer);

    if (match != null) {
      int numerator = int.parse(match.group(1)!);
      int denominator = int.parse(match.group(2)!);

      int strategy = Random().nextInt(5);

      switch (strategy) {
        case 0: // Change numerator
          numerator += Random().nextInt(5) - 2;
          if (numerator == 0) numerator = 1;
          break;
        case 1: // Change denominator
          denominator += Random().nextInt(5) - 2;
          if (denominator <= 0) denominator = 1;
          break;
        case 2: // Invert fraction
          if (numerator != 0) {
            return "$denominator/$numerator";
          } else {
            numerator += Random().nextInt(3) + 1;
          }
          break;
        case 3: // Add to both
          int addValue = Random().nextInt(3) + 1;
          numerator += addValue;
          denominator += addValue;
          break;
        case 4: // Common mistake: add numerators and denominators directly
          return "${numerator + numerator}/${denominator + denominator}";
      }

      return "$numerator/$denominator";
    }

    return "correctAnswer";
  }

  //#endregion
  //#endregion

  //#region Handle Answer
  void handleAnswer(bool userAnswer) {
    timer?.cancel();

    bool isCorrect = (displayedAnswer == correctAnswer) == userAnswer;

    if (isCorrect) {
      setState(() {
        int timeBonus = (timeLeft / maxTime * 10).round();
        score += scoreIncrement + timeBonus;

        correctAnswersCount++;
        currentQuestion++;
        generateQuestion();
      });

      HapticFeedback.lightImpact();
    }
    else {
      setState(() {
        if (_isVibrationOn) {
          Vibration.hasVibrator().then((hasVibrator) {
            if (hasVibrator) {
              Vibration.vibrate(duration: 200);
            }
          });
        }
        wrongAnswers++;

        score = score - scoreDecrement;
        currentQuestion++;
        lives--;
        generateQuestion();
      });

      HapticFeedback.mediumImpact();
    }

    HapticFeedback.lightImpact();
    checkGameOver();
    if (lives > 0 && currentQuestion <= totalQuestions) {
      startTimer();
    }
  }
  //#endregion

  //#region Check Game Over and Reset
  void checkGameOver() {
    if (lives <= 0 || currentQuestion > totalQuestions) {
      timer?.cancel();
      HapticFeedback.heavyImpact();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final isDarkMode = Theme
              .of(context)
              .brightness == Brightness.dark;
          final bool isWinner = score >= levelScore*0.4; // Check if score is 80 or above

          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.85,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDarkMode
                      ? [Colors.indigo[900]!, Colors.purple[900]!]
                      : [Colors.cyan[600]!, Colors.blue[400]!],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Color.fromRGBO(0, 0, 0, 0.6)
                        : Color.fromRGBO(33, 150, 243,0.3),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: isDarkMode
                            ? [Colors.white, Colors.white]
                            : [Colors.black, Colors.black],
                      ).createShader(bounds);
                    },
                    child: Text(
                      isWinner ? 'FINISHED' : 'PLAY AGAIN',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Color.fromRGBO(0, 0, 0, 0.4)
                          : Color.fromRGBO(255,255,255,0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDarkMode ? Colors.purple[700]! : Colors
                            .cyan[300]!,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: score / levelScore,
                                backgroundColor:
                                isDarkMode ? Colors.grey[800] : Colors
                                    .grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDarkMode ? Colors.cyan[300]! : Colors
                                      .purple[500]!,
                                ),
                                strokeWidth: 10,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$score',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'SCORE',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatRow(
                              icon: Icons.check_circle_rounded,
                              label: 'Correct',
                              value: correctAnswersCount.toString(),
                              color: Colors.green[400]!,
                              isDarkMode: isDarkMode,
                            ),
                            SizedBox(height: 12),
                            _buildStatRow(
                              icon: Icons.cancel_rounded,
                              label: 'Wrong',
                              value: wrongAnswers.toString(),
                              color: Colors.red[400]!,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28),

                  ElevatedButton(
                    onPressed: () async {
                      if(isWinner) {
                        bool isHigh = await saveScoreAndStars();

                        if (isHigh) {
                          await showHighScoreDialog(); // ⏳ shows for 2 seconds
                        }
                        Navigator.of(context).pop(true); // Go back to LevelPage
                        Navigator.of(context).pop();
                      }
                      else{
                        Navigator.of(context).pop();
                      }
                      resetGame();
                    },


                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isDarkMode ? Colors.purple[400] : Colors.amber[500],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      shadowColor: isDarkMode
                          ? Color.fromRGBO(128,0,128,0.6) // Purple
                          : Color.fromRGBO(255,193,7,0.6), // Amber
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isWinner ? Icons.check_rounded : Icons.replay_rounded,
                          size: 22,
                        ),
                        SizedBox(width: 8),
                        Text(
                          isWinner ? 'FINISHED' : 'PLAY AGAIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void resetGame() {
    setState(() {
      score = 0;
      lives = 3;
      currentQuestion = 1;
      correctAnswersCount = 0;
      wrongAnswers = 0;
      timer?.cancel();
    });
  }

  //#endregion

  //#region save Score and Start
  int calculateStars(int score) {
    if (score >= 160) return 3;
    if (score >= 120) return 2;
    if (score >= 80) return 1;
    return 0;
  }


  Future<bool> saveScoreAndStars() async {
    int stars = calculateStars(score);
    String tableName = '';

    switch (widget.title) {
      case 'Single Player':
        tableName = 'SoloPlayerLevel';
        break;
      case 'Input Answer':
        tableName = 'InputAnswerLevel';
        break;
      case 'True False':
        tableName = 'TrueFalseLevel';
        break;
      case 'Missing value':
        tableName = 'MissingValueLevel';
        break;
    }

    bool isNewHighScore = false;

    if (tableName.isNotEmpty) {
      final record = await MathBlastDatabase.instance.getRecordById(tableName, widget.level);
      int previousStars = record?['LevelStar'] ?? 0;
      int previousScore = record?['LevelScore'] ?? 0;

      int newStars = stars > previousStars ? stars : previousStars;
      int newScore = score > previousScore ? score : previousScore;

      isNewHighScore =  previousScore!=0&& score > previousScore;

      await MathBlastDatabase.instance.updateRecord(tableName, widget.level, {
        'LevelStar': newStars,
        'LevelScore': newScore,
      });

    }

    return isNewHighScore;
  }


  Future<void> showHighScoreDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade400, Colors.purple.shade800],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(128,0,128,0.5), // Purple
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trophy with particle effects
              Stack(
                alignment: Alignment.center,
                children: [
                  // Glowing background
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    builder: (context, value, _) {
                      return Opacity(
                        opacity: value * 0.8,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255,193,7,0.3), //Amber
                          ),
                        ),
                      );
                    },
                  ),
                  // Trophy with bounce animation
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.5, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Icon(Icons.emoji_events, size: 70, color: Colors.amber),
                  ),
                  // Spinning stars
                  ...List.generate(5, (index) {
                    return Positioned(
                      top: 20 * (index % 3),
                      left: 60 + (index * 15) % 30,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 500 + (index * 200)),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.rotate(
                              angle: value * 2 * 3.14,
                              child: Icon(Icons.star, size: 15, color: Colors.amber),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: 20),
              // Title with slide-in animation
              TweenAnimationBuilder<Offset>(
                tween: Tween(begin: Offset(0, -20), end: Offset.zero),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (context, offset, child) {
                  return Transform.translate(
                    offset: offset,
                    child: child,
                  );
                },
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.amber, Colors.white, Colors.amber],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    "✨ NEW HIGH SCORE! ✨",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14),
              // Score display with count-up animation
              FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 500)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 1000),
                      builder: (context, value, _) {
                        return Text(
                          "YOU'RE AMAZING! 🔥",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(255,255,255,0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
              SizedBox(height: 20),
              // Confetti animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 1000),
                builder: (context, value, _) {
                  return AnimatedOpacity(
                    duration: Duration(milliseconds: 150),
                    opacity: value,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255,255,255,0.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            "Keep playing!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    // Auto close after 3 seconds
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pop(); // Close the dialog
  }


  //#endregion

  //#region Stat Row Builder Method
  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color.fromRGBO(color.red, color.green, color.blue, 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white70 : Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
  //#endregion

  //#region Page UI
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[700] : Colors.purple[100],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode
                                        ? Color.fromRGBO(0, 0, 0, 0.3)
                                        : Color.fromRGBO(128,0,128,0.3), //Purple
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_circle_left_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.purple[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? Color.fromRGBO(0, 0, 0, 0.4)
                                : Color.fromRGBO(128,0,128,0.2), //Purple
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Level- ${widget.level}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.emoji_events, color: Colors.orange, size: 20),
                                  Text(
                                    ' $savedScore',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '$currentQuestion/',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '$totalQuestions',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w100,
                                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                                      Text(
                                        ' $correctAnswersCount',
                                        style: TextStyle(
                                          color: isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.cancel, color: Colors.red, size: 20),
                                      Text(
                                        ' $wrongAnswers',
                                        style: TextStyle(
                                          color: isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Score: $score',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                                  (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(
                                  index < lives ? Icons.favorite : Icons.favorite_outline_sharp,
                                  color: isDarkMode ? Colors.purple[300] : Colors.purple,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey[700] : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode
                                    ? Color.fromRGBO(0, 0, 0, 0.3) // Black with 30% opacity(0.3)
                                    : Color.fromRGBO(158,158,158,0.3), //Grey with 30% opacity(0.3)
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: timeLeft / maxTime,
                                  backgroundColor: isDarkMode ? Colors.grey[600] : Colors.purple[50],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDarkMode ? Colors.purple[200]! : Colors.purple,
                                  ),
                                  strokeWidth: 8,
                                ),
                              ),
                              Text(
                                '$timeLeft',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: firstNumber is String && firstNumber.toString().length > 20
                      ? Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[700] : Colors.purple[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$firstNumber => $displayedAnswer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                      : Text(
                    thirdNumber != null && forthNumber != null
                        ? '$firstNumber $sign $secondNumber $sign $thirdNumber $sign $forthNumber = $displayedAnswer'
                        : thirdNumber != null
                        ? '$firstNumber $sign $secondNumber $sign $thirdNumber = $displayedAnswer'
                        : forthNumber != null
                        ? '$firstNumber $sign $secondNumber $sign $forthNumber = $displayedAnswer'
                        : '$firstNumber $sign $secondNumber = $displayedAnswer',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 2.0,
                    children: [
                      ElevatedButton(
                        onPressed: selectedAnswer == null ? () => handleAnswer(true) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedAnswer == true
                              ? (displayedAnswer == correctAnswer ? Colors.green : Colors.red)
                              : (isDarkMode ? Colors.grey[600] : Colors.purple[200]),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          elevation: 4,
                        ),
                        child: Text(
                          'True',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: selectedAnswer == null ? () => handleAnswer(false) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedAnswer == false
                              ? (displayedAnswer != correctAnswer ? Colors.green : Colors.red)
                              : (isDarkMode ? Colors.grey[600] : Colors.purple[200]),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          elevation: 4,
                        ),
                        child: Text(
                          'False',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
}