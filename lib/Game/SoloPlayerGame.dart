import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../Math/Operations.dart';
import '../Database.dart';

class SoloPlayerGame extends StatefulWidget {
  final int grade;
  final int level;
  final String title;

  const SoloPlayerGame({
    super.key,
    required this.grade,
    required this.level,
    required this.title,
  });

  @override
  _SoloPlayerState createState() => _SoloPlayerState();
}

class _SoloPlayerState extends State<SoloPlayerGame> {
  //#region Variables
  int score = 0;
  int currentQuestion = 1;
  int totalQuestions = 10;
  int correctAnswersCount = 0;
  int wrongAnswers = 0;

  late int timeLeft;
  late int maxTime;
  late int levelScore;
  late int scoreIncrement;
  late int scoreDecrement;
  Timer? timer;
  int lives = 3;
  int savedScore = 0;

  late Map<String, dynamic> currentOperation;
  late dynamic firstNumber;
  late dynamic secondNumber;
  dynamic thirdNumber;
  dynamic fourthNumber;
  late String sign;
  late dynamic correctAnswer;
  late List<dynamic> answers;

  late bool _isVibrationOn = false;

  //#endregion

  //#region initState, Dispose, Load Score
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
    String tableName = 'SoloPlayerLevel';
    if (tableName.isNotEmpty) {
      final record = await MathBlastDatabase.instance.getRecordById(
        tableName,
        widget.level,
      );
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
        maxTime = 30;
        break;
      case 2:
        maxTime = 30;
        break;
      case 3:
        maxTime = 35;
        break;
      case 4:
        maxTime = 40;
        break;
      case 5:
        maxTime = 50;
        break;
      default:
        maxTime = 30;
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
        scoreIncrement = 20;
        scoreDecrement = 10;
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
    });
    checkGameOver();
    if (lives > 0 && currentQuestion <= 10) {
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
      fourthNumber = null;
      correctAnswer = firstNumber + secondNumber;

      int answerRounded = correctAnswer.round();
      answers = [
        answerRounded,
        answerRounded + 2,
        answerRounded - 3,
        answerRounded + 5,
      ]..shuffle();
      timeLeft = maxTime;
      return;
    }

    int operationIndex = Random().nextInt(operations.length);
    currentOperation = operations[operationIndex];
    final numbers = currentOperation["generateNumbers"]();

    if (currentOperation["title"] == "Binary Addition" ||
        _isBinary(numbers["number1"]) ||
        _isBinary(numbers["number2"])) {
      generateQuestion();
      return;
    } else if (currentOperation["title"] == "Complex Number Addition") {
      firstNumber = numbers["number1"];
      secondNumber = numbers["number2"];
      thirdNumber = null;
      fourthNumber = null;
      sign = numbers["sign"] ?? "+";
      correctAnswer = numbers["result"];
      answers = [
        correctAnswer,
        _generateComplexDistractor(correctAnswer, operationType),
        _generateComplexDistractor(correctAnswer, operationType),
        _generateComplexDistractor(correctAnswer, operationType),
      ]..shuffle();
      timeLeft = maxTime;
    } else if (currentOperation["title"] == "Fraction Addition") {
      firstNumber = numbers["number1"];
      secondNumber = numbers["number2"];
      thirdNumber = null;
      fourthNumber = null;
      sign = numbers["sign"] ?? "+";
      correctAnswer = numbers["result"];
      answers = [
        correctAnswer,
        _generateFractionDistractor(correctAnswer, operationType),
        _generateFractionDistractor(correctAnswer, operationType),
        _generateFractionDistractor(correctAnswer, operationType),
      ]..shuffle();
      timeLeft = maxTime;
    } else {
      isWordProblem =
          currentOperation["title"] == "Word Problem" ||
          (numbers["number1"] is String &&
              numbers["number1"].toString().length > 20);

      if (isWordProblem) {
        firstNumber = numbers["number1"];
        secondNumber = "";
        thirdNumber = null;
        fourthNumber = null;
        sign = "";
        correctAnswer = numbers["result"];
      } else {
        double num1 = _parseNumber(numbers["number1"]);
        double num2 = _parseNumber(numbers["number2"]);
        double? num3 =
            numbers["number3"] == null
                ? null
                : _parseNumber(numbers["number3"]);
        double? num4 =
            numbers["number4"] == null
                ? null
                : _parseNumber(numbers["number4"]);
        double result = _parseNumber(numbers["result"]);

        if (operationType == 3 && num2 == 0) {
          num2 = Random().nextInt(9) + 1.0;
        }

        firstNumber = num1 == num1.roundToDouble() ? num1.toInt() : num1;
        secondNumber = num2 == num2.roundToDouble() ? num2.toInt() : num2;
        thirdNumber =
            num3 == null
                ? null
                : (num3 == num3.roundToDouble() ? num3.toInt() : num3);
        fourthNumber =
            num4 == null
                ? null
                : (num4 == num4.roundToDouble() ? num4.toInt() : num4);
        correctAnswer =
            result == result.roundToDouble() ? result.toInt() : result;
      }

      answers = [
        correctAnswer,
        _generateDistractor(correctAnswer, operationType),
        _generateDistractor(correctAnswer, operationType, offset: -5),
        _generateDistractor(correctAnswer, operationType, offset: 12),
      ]..shuffle();
      timeLeft = maxTime;
    }
  }

  //#endregion

  //region Check Binary Helper Method
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
  dynamic _generateDistractor(
    dynamic correct,
    int operationType, {
    int offset = 10,
  }) {
    switch (operationType) {
      case 0: // Addition
        return correct is double
            ? double.parse(
              (correct + (Random().nextInt(20) - 10 + offset + 1))
                  .toStringAsFixed(2),
            )
            : correct + (Random().nextInt(20) - 10 + offset);
      case 1: // Subtraction
        return correct is double
            ? double.parse(
              (correct + (Random().nextInt(20) - 10 + offset + 1))
                  .toStringAsFixed(2),
            )
            : correct + (Random().nextInt(20) - 10 + offset);
      case 2: // Multiplication
        if (correct is int) {
          return ((correct * (1 + (Random().nextDouble() * 0.5 - 0.25))) + offset).toInt();
        } else {
          return double.parse(
            ((correct * (1 + (Random().nextDouble() * 0.5 - 0.25))) + offset)
                .toStringAsFixed(2),
          );
        }

      case 3: // Division
        return double.parse(
          ((correct * (1 + (Random().nextDouble() * 0.5 - 0.25))) + offset)
              .toStringAsFixed(2),
        );
      default:
        return correct + offset;
    }
  }

  String _generateComplexDistractor(String correctAnswer, int operationType) {
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

  String _generateFractionDistractor(String correctAnswer, int operationType) {
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

  //#region Handle Answer
  void handleAnswer(dynamic answer) {
    timer?.cancel();
    bool isCorrect = false;
    if (correctAnswer is double && answer is double) {
      isCorrect = (correctAnswer - answer).abs() < 0.1;
    } else if (correctAnswer is double && answer is int) {
      isCorrect = (correctAnswer.round() == answer);
    } else if (correctAnswer is String && answer is String) {
      isCorrect = correctAnswer == answer;
    } else {
      isCorrect = answer == correctAnswer;
    }

    if (isCorrect) {
      setState(() {
        int timeBonus = (timeLeft / maxTime * 10).round();
        score += scoreIncrement + timeBonus;
        correctAnswersCount++;
        currentQuestion++;
        generateQuestion();
      });
      HapticFeedback.lightImpact();
    } else {
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
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          final bool isWinner = score >= levelScore * 0.4;
          final screenWidth = MediaQuery.of(context).size.width;
          final fontSize = screenWidth * 0.045;

          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              width: screenWidth * 0.85,
              padding: EdgeInsets.all(screenWidth * 0.06),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors:
                      isDarkMode
                          ? [Colors.indigo[900]!, Colors.purple[900]!]
                          : [Colors.cyan[600]!, Colors.blue[400]!],
                ),
                borderRadius: BorderRadius.circular(screenWidth * 0.07),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDarkMode
                            ? Color.fromRGBO(0,0,0,0.6)
                            : Color.fromRGBO(33, 150, 243, 0.3) , // Blue with 30% opacity
                    blurRadius: screenWidth * 0.04,
                    offset: Offset(0, screenWidth * 0.02),
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
                        colors:
                            isDarkMode
                                ? [Colors.white, Colors.white]
                                : [Colors.black, Colors.black],
                      ).createShader(bounds);
                    },
                    child: Text(
                      isWinner ? 'FINISHED' : 'PLAY AGAIN',
                      style: TextStyle(
                        fontSize: fontSize * 1.6,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.06),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.04,
                      horizontal: screenWidth * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode
                              ? Color.fromRGBO(0, 0, 0, 0.4)
                              : Color.fromRGBO(255,255,255,0.2),
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      border: Border.all(
                        color:
                            isDarkMode
                                ? Colors.purple[700]!
                                : Colors.cyan[300]!,
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
                              width: screenWidth * 0.25,
                              height: screenWidth * 0.25,
                              child: CircularProgressIndicator(
                                value: score / levelScore,
                                backgroundColor:
                                    isDarkMode
                                        ? Colors.grey[800]
                                        : Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDarkMode
                                      ? Colors.cyan[300]!
                                      : Colors.purple[500]!,
                                ),
                                strokeWidth: screenWidth * 0.025,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$score',
                                  style: TextStyle(
                                    fontSize: fontSize * 1.4,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'SCORE',
                                  style: TextStyle(
                                    fontSize: fontSize * 0.7,
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
                              fontSize: fontSize,
                            ),
                            SizedBox(height: screenWidth * 0.03),
                            _buildStatRow(
                              icon: Icons.cancel_rounded,
                              label: 'Wrong',
                              value: wrongAnswers.toString(),
                              color: Colors.red[400]!,
                              isDarkMode: isDarkMode,
                              fontSize: fontSize,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.07),
                  ElevatedButton(
                    onPressed: () async {
                      if (isWinner) {
                        bool isHigh = await saveScoreAndStars();
                        if (isHigh) {
                          await showHighScoreDialog();
                        }
                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                      }
                      resetGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? Colors.purple[400] : Colors.amber[500],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenWidth * 0.04,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      ),
                      elevation: 6,
                      shadowColor:
                          isDarkMode
                              ? Color.fromRGBO(128, 0, 128, 0.6)       // Colors.purple
                              : Color.fromRGBO(255, 193, 7, 0.6)       // Colors.amber
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isWinner ? Icons.check_rounded : Icons.replay_rounded,
                          size: fontSize * 1.1,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          isWinner ? 'FINISHED' : 'PLAY AGAIN',
                          style: TextStyle(
                            fontSize: fontSize * 0.8,
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

  //#region Save Score and Stars
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
      final record = await MathBlastDatabase.instance.getRecordById(
        tableName,
        widget.level,
      );
      int previousStars = record?['LevelStar'] ?? 0;
      int previousScore = record?['LevelScore'] ?? 0;
      int newStars = stars > previousStars ? stars : previousStars;
      int newScore = score > previousScore ? score : previousScore;
      isNewHighScore = previousScore != 0 && score > previousScore;

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
      builder: (_) {
        final screenWidth = MediaQuery.of(context).size.width;
        final fontSize = screenWidth * 0.045;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.06),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.pink.shade400, Colors.pink.shade800],
              ),
              borderRadius: BorderRadius.circular(screenWidth * 0.06),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(233, 30, 99, 0.5), // Pink

                  blurRadius: screenWidth * 0.05,
                  spreadRadius: screenWidth * 0.0125,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.06,
              horizontal: screenWidth * 0.06,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 800),
                      builder: (context, value, _) {
                        return Opacity(
                          opacity: value * 0.8,
                          child: Container(
                            width: screenWidth * 0.25,
                            height: screenWidth * 0.25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(255, 193, 7, 0.3) , //Amber
                            ),
                          ),
                        );
                      },
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.5, end: 1.0),
                      duration: Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Icon(
                        Icons.emoji_events,
                        size: screenWidth * 0.175,
                        color: Colors.amber,
                      ),
                    ),
                    ...List.generate(5, (index) {
                      return Positioned(
                        top: screenWidth * 0.05 * (index % 3),
                        left:
                            screenWidth * 0.15 +
                            (index * screenWidth * 0.0375) %
                                (screenWidth * 0.075),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 500 + (index * 200)),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.rotate(
                                angle: value * 2 * 3.14,
                                child: Icon(
                                  Icons.star,
                                  size: screenWidth * 0.0375,
                                  color: Colors.amber,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: screenWidth * 0.05),
                TweenAnimationBuilder<Offset>(
                  tween: Tween(begin: Offset(0, -20), end: Offset.zero),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, offset, child) {
                    return Transform.translate(offset: offset, child: child);
                  },
                  child: ShaderMask(
                    shaderCallback:
                        (bounds) => LinearGradient(
                          colors: [Colors.amber, Colors.white, Colors.amber],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                    child: Text(
                      "✨ NEW HIGH SCORE! ✨",
                      style: TextStyle(
                        fontSize: fontSize * 0.9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.035),
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
                              fontSize: fontSize * 0.9,
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
                SizedBox(height: screenWidth * 0.05),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 1000),
                  builder: (context, value, _) {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 150),
                      opacity: value,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.025,
                          horizontal: screenWidth * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.15),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.075,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.red,
                              size: fontSize,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              "Keep playing!",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: fontSize * 0.8,
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
        );
      },
    );
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pop();
  }

  //#endregion

  //#region StatRow Builder Method
  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDarkMode,
    required double fontSize,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(fontSize * 0.2),
          decoration: BoxDecoration(
            color: Color.fromRGBO(color.red, color.green, color.blue, 0.2),
            borderRadius: BorderRadius.circular(fontSize * 0.4),
          ),
          child: Icon(icon, color: color, size: fontSize),
        ),
        SizedBox(width: fontSize * 0.5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize * 0.7,
                color: isDarkMode ? Colors.white70 : Colors.white70,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 0.045;
    final padding = screenWidth * 0.05;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(padding),
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
                                  width: screenWidth * 0.1,
                                  height: screenWidth * 0.1,
                                  decoration: BoxDecoration(
                                    color:
                                        isDarkMode
                                            ? Colors.grey[700]
                                            : Colors.pink[100],
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            isDarkMode
                                                ? Color.fromRGBO(0, 0, 0, 0.3)
                                                :Color.fromRGBO(233, 30, 99, 0.3), //Pink
                                        blurRadius: screenWidth * 0.0125,
                                        offset: Offset(0, screenWidth * 0.005),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_circle_left_outlined,
                                    color: Colors.white,
                                    size: fontSize * 1.2,
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.025),
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: fontSize * 0.9,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: screenWidth * 0.1),
                          padding: EdgeInsets.symmetric(
                            horizontal: padding * 1.5,
                            vertical: padding,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode ? Colors.grey[800] : Colors.pink[50],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(screenWidth * 0.075),
                              topRight: Radius.circular(screenWidth * 0.075),
                              bottomLeft: Radius.circular(screenWidth * 0.05),
                              bottomRight: Radius.circular(screenWidth * 0.05),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    isDarkMode
                                        ? Color.fromRGBO(0,0,0,0.4)
                                        : Color.fromRGBO(233, 30, 99, 0.2), //Pink

                                blurRadius: screenWidth * 0.03,
                                offset: Offset(0, screenWidth * 0.015),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: screenWidth * 0.05),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Level- ${widget.level}',
                                    style: TextStyle(
                                      fontSize: fontSize * 0.7,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.emoji_events,
                                        color: Colors.orange,
                                        size: fontSize,
                                      ),
                                      SizedBox(width: screenWidth * 0.01),
                                      Text(
                                        '$savedScore',
                                        style: TextStyle(
                                          color:
                                              isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontSize: fontSize * 0.7,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '$currentQuestion/',
                                        style: TextStyle(
                                          fontSize: fontSize * 0.8,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '10',
                                        style: TextStyle(
                                          fontSize: fontSize * 0.7,
                                          fontWeight: FontWeight.w100,
                                          color:
                                              isDarkMode
                                                  ? Colors.white70
                                                  : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: fontSize,
                                          ),
                                          SizedBox(width: screenWidth * 0.01),
                                          Text(
                                            '$correctAnswersCount',
                                            style: TextStyle(
                                              color:
                                                  isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: fontSize * 0.7,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: fontSize,
                                          ),
                                          SizedBox(width: screenWidth * 0.01),
                                          Text(
                                            '$wrongAnswers',
                                            style: TextStyle(
                                              color:
                                                  isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: fontSize * 0.7,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'Score: $score',
                                style: TextStyle(
                                  fontSize: fontSize * 0.9,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3,
                                  (index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.005,
                                    ),
                                    child: Icon(
                                      index < lives
                                          ? Icons.favorite
                                          : Icons.favorite_outline_sharp,
                                      color:
                                          isDarkMode
                                              ? Colors.pink[300]
                                              : Colors.pink,
                                      size: fontSize * 1.2,
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
                              width: screenWidth * 0.2,
                              height: screenWidth * 0.2,
                              decoration: BoxDecoration(
                                color:
                                    isDarkMode
                                        ? Colors.grey[700]
                                        : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        isDarkMode
                                            ? Color.fromRGBO(0,0,0,0.3)
                                            : Color.fromRGBO(158, 158, 158,0.3), //Grey
                                    spreadRadius: screenWidth * 0.0025,
                                    blurRadius: screenWidth * 0.0125,
                                    offset: Offset(0, screenWidth * 0.005),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.15,
                                    height: screenWidth * 0.15,
                                    child: CircularProgressIndicator(
                                      value: timeLeft / maxTime,
                                      backgroundColor:
                                          isDarkMode
                                              ? Colors.grey[600]
                                              : Colors.pink[50],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        isDarkMode
                                            ? Colors.pink[200]!
                                            : Colors.pink,
                                      ),
                                      strokeWidth: screenWidth * 0.02,
                                    ),
                                  ),
                                  Text(
                                    '$timeLeft',
                                    style: TextStyle(
                                      fontSize: fontSize * 0.75,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.04,
                      ),
                      constraints: BoxConstraints(maxWidth: screenWidth * 0.9),
                      child:
                          firstNumber is String &&
                                  firstNumber.toString().length > 20
                              ? Container(
                                padding: EdgeInsets.all(padding),
                                decoration: BoxDecoration(
                                  color:
                                      isDarkMode
                                          ? Colors.grey[700]
                                          : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(
                                    screenWidth * 0.03,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    firstNumber.toString(),
                                    style: TextStyle(
                                      fontSize: fontSize * 0.9,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              )
                              : Text(
                                thirdNumber != null && fourthNumber != null
                                    ? '$firstNumber $sign $secondNumber $sign $thirdNumber $sign $fourthNumber = ?'
                                    : thirdNumber != null
                                    ? '$firstNumber $sign $secondNumber $sign $thirdNumber = ?'
                                    : fourthNumber != null
                                    ? '$firstNumber $sign $secondNumber $sign $fourthNumber = ?'
                                    : '$firstNumber $sign $secondNumber = ?',
                                style: TextStyle(
                                  fontSize: fontSize * 1.2,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.35,
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: screenWidth * 0.05,
                        crossAxisSpacing: screenWidth * 0.05,
                        childAspectRatio: screenWidth / (screenHeight * 0.15),
                        children:
                            answers.asMap().entries.map((entry) {
                              final answer = entry.value;
                              return ElevatedButton(
                                onPressed: () => handleAnswer(answer),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isDarkMode
                                          ? Colors.grey[900]
                                          : Colors.pink[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      screenWidth * 0.0375,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.025,
                                    vertical: screenHeight * 0.02,
                                  ),
                                  elevation: 4,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '$answer',
                                    style: TextStyle(
                                      fontSize: fontSize * 0.9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //#endregion
}
