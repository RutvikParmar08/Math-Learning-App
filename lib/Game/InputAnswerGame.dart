import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Database.dart';
import '../Math/Operations.dart';

class InputAnswerGame extends StatefulWidget {
  final int grade;
  final int level;
  final String title;

  const InputAnswerGame({
    super.key,
    required this.grade,
    required this.level,
    required this.title,
  });

  @override
  _InputAnswerState createState() => _InputAnswerState();
}

class _InputAnswerState extends State<InputAnswerGame> with TickerProviderStateMixin {
  //#region Variables
  int score = 0;
  int currentQuestion = 1;
  int totalQuestions = 10;
  int wrongAnswers = 0;

  late int timeLeft;
  late int maxTime;
  late int levelScore;
  int savedScore = 0;
  late int scoreIncrement;
  late int scoreDecrement;

  dynamic correctAnswer;
  int correctAnswersCount = 0;
  Timer? timer;
  int lives = 3;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late AnimationController _feedbackAnimationController;
  dynamic selectedAnswer;
  final TextEditingController _textAnswerController = TextEditingController();

  dynamic firstNumber;
  dynamic secondNumber;
  dynamic thirdNumber;
  dynamic forthNumber;
  late String sign;

  //endregion

  //#region Init State , Dispose , Load Score and Timer
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _feedbackAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    setMaxTimeForGrade();
    setLevelScoreForGrade();
    loadScoreFromDatabase();
    generateQuestion();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    _feedbackAnimationController.dispose();
    _textAnswerController.dispose();
    super.dispose();
  }

  Future<void> loadScoreFromDatabase() async {
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

    if (tableName.isNotEmpty) {
      final record = await MathBlastDatabase.instance.getRecordById(
          tableName, widget.level);
      setState(() {
        savedScore = record?['LevelScore'] ?? 0;
      });
    }
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
      _textAnswerController.clear();
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
    print("Generating question with operation type: $operationType");

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
      thirdNumber=null;
      forthNumber=null;
      correctAnswer = firstNumber + secondNumber;
      timeLeft = maxTime;
      _textAnswerController.clear();
      return;
    }

    int operationIndex = Random().nextInt(operations.length);
    final currentOperation = operations[operationIndex];
    final numbers = currentOperation["generateNumbers"]();

    if (currentOperation["title"] == "Binary Addition" ||
        _isBinary(numbers["number1"]) || _isBinary(numbers["number2"])) {
      generateQuestion();
      return;
    }
    else if (currentOperation["title"] == "Complex Number Addition") {
      firstNumber = numbers["number1"];
      secondNumber = numbers["number2"];
      thirdNumber = null;
      forthNumber = null;
      sign = numbers["sign"] ?? "+";
      correctAnswer = numbers["result"];
    }
    else if (currentOperation["title"] == "Fraction Addition") {
      firstNumber = numbers["number1"];
      secondNumber = numbers["number2"];
      thirdNumber = null;
      forthNumber = null;
      sign = numbers["sign"] ?? "+";
      correctAnswer = numbers["result"];
    }
    else {
      isWordProblem = currentOperation["title"] == "Word Problem" ||
          (numbers["number1"] is String && numbers["number1"].toString().length > 20);

      if (isWordProblem) {
        firstNumber = numbers["number1"];
        secondNumber = "";
        thirdNumber = null;
        forthNumber = null;
        sign = "";
        correctAnswer = _parseNumber(numbers["result"]);
      }
      else {
        double num1 = _parseNumber(numbers["number1"]);
        double num2 = _parseNumber(numbers["number2"]);
        double? num3 = numbers["number3"] == null ? null : _parseNumber(numbers["number3"]) ;
        double? num4 = numbers["number4"] == null ? null : _parseNumber(numbers["number4"]) ;
        double result = _parseNumber(numbers["result"]);

        if (operationType == 3 && num2 == 0) {
          num2 = Random().nextInt(9) + 1.0;
        }

        firstNumber = num1 == num1.roundToDouble() ? num1.toInt() : num1;
        secondNumber = num2 == num2.roundToDouble() ? num2.toInt() : num2;
        thirdNumber = num3 == null ? null : (num3 == num3.roundToDouble() ? num3.toInt() : num3);
        forthNumber = num4 == null ? null : (num4 == num4.roundToDouble() ? num4.toInt() : num4);
        correctAnswer = result == result.roundToDouble() ? result.toInt() : result;
      }
    }

    timeLeft = maxTime;
    _textAnswerController.clear();
  }
  //#endregion

  //#region Check Binary Helper Method
  bool _isBinary(dynamic value) {
    return value is String && RegExp(r'^[01]+$').hasMatch(value);
  }
  //#endregion

  //#region Number Datatype Change
  double _parseNumber(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) {
      if (_isBinary(value)) return int.parse(value, radix: 2).toDouble();
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
  //#endregion

  //#region Manual Answer
  void handleManualAnswer() {
    final String textAnswer = _textAnswerController.text.replaceAll(' ', '');
    if (textAnswer.isEmpty) return;

    timer?.cancel();

    bool isCorrect = false;
    double? userDouble = double.tryParse(textAnswer);

    if (userDouble != null && correctAnswer is double) {
      isCorrect = (correctAnswer - userDouble).abs() < 0.1;
    }
    else if (userDouble != null && correctAnswer is int) {
      isCorrect = correctAnswer.toDouble() == userDouble;
    }
    else if (correctAnswer is int && int.tryParse(textAnswer) != null) {
      isCorrect = correctAnswer == int.parse(textAnswer);
    }
    else if (correctAnswer is double && double.tryParse(textAnswer) != null) {
      isCorrect = (correctAnswer - double.parse(textAnswer)).abs() < 0.1;
    }
    else if (correctAnswer is String) {
      isCorrect = correctAnswer.trim() == textAnswer.trim();
    }
    else {
      isCorrect = textAnswer == correctAnswer.toString();
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
    }
    else {
      setState(() {
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
          final isDarkMode = Theme
              .of(context)
              .brightness == Brightness.dark;
          final bool isWinner = score >= levelScore*0.4; // Check if Score is above 40% or not

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
                        ? Colors.black.withOpacity(0.6)
                        : Colors.blue.withOpacity(0.3),
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
                          ? Colors.black.withOpacity(0.4)
                          : Colors.white.withOpacity(0.2),
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
                          ? Colors.purple.withOpacity(0.6)
                          : Colors.amber.withOpacity(0.6),
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
              colors: [Colors.blue.shade400, Colors.blue.shade800],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5),
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
                            color: Colors.amber.withOpacity(0.3),
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
                            color: Colors.white.withOpacity(0.9),
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
                    duration: Duration(milliseconds: 300),
                    opacity: value,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
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

  //#region Stat Row  Builder Method
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
            color: color.withOpacity(0.2),
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

  //#region Show Error Dialog For Wrong Input
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.blue, size: 28),
            SizedBox(width: 10),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.shade50,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Page UI
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [Colors.grey[900]!, Colors.blueGrey[900]!]
                : [Colors.blue[100]!, Colors.purple[100]!],
          ),
          image: DecorationImage(
            image: AssetImage('assets/BackGround/MathBackGround1.jpeg'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(isDarkMode ? 0.4 : 0.2),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[700] : Colors.blue[100],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_circle_left_outlined, color: Colors.white),
                      ),
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicSans',
                        color: isDarkMode ? Colors.white : Colors.blue[900],
                        shadows: [
                          Shadow(
                            color: isDarkMode ? Colors.black26 : Colors.blue[100]!,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
                SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 70),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.blue.withOpacity(0.2),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Level-${widget.level}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.emoji_events, color: Colors.orange, size: 20),
                                  Text('$savedScore', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '$currentQuestion/',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '10',
                                    style: TextStyle(
                                      fontSize: 16,
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
                                      Icon(Icons.check_circle, color: Colors.blue, size: 20),
                                      Text(' $correctAnswersCount', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(Icons.cancel, color: Colors.red, size: 20),
                                      Text(' $wrongAnswers', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Score: $score',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                                  (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: AnimatedScale(
                                  scale: index < lives ? 1.1 : 1.0,
                                  duration: Duration(milliseconds: 200),
                                  child: Icon(
                                    index < lives ? Icons.favorite : Icons.favorite_outline_sharp,
                                    color: isDarkMode ? Colors.blue[300] : Colors.blue,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[700] : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(
                                value: timeLeft / maxTime,
                                backgroundColor: isDarkMode ? Colors.grey[600] : Colors.blue[50],
                                valueColor: AlwaysStoppedAnimation<Color>(isDarkMode ? Colors.blue[200]! : Colors.blue),
                                strokeWidth: 10,
                              ),
                            ),
                            Text(
                              '$timeLeft',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                AnimatedScale(
                  scale: _scaleAnimation.value,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.blue.withOpacity(0.2),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      thirdNumber != null && forthNumber != null
                          ? '$firstNumber $sign $secondNumber $sign $thirdNumber $sign $forthNumber = ?'
                          : thirdNumber != null
                          ? '$firstNumber $sign $secondNumber $sign $thirdNumber = ?'
                          : forthNumber != null
                          ? '$firstNumber $sign $secondNumber $sign $forthNumber = ?'
                          : '$firstNumber $sign $secondNumber = ?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                        shadows: [
                          Shadow(
                            color: isDarkMode ? Colors.black26 : Colors.blue[100]!,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.blue.withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textAnswerController,
                          decoration: InputDecoration(
                            hintText: 'Enter your answer (e.g., 5, 1/2, 3+4i)',
                            hintStyle: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDarkMode ? Colors.grey[700] : Colors.white,
                          ),
                          style: TextStyle(
                            fontSize: 20,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => handleManualAnswer(),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: handleManualAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? Colors.grey[600] : Colors.blue[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          elevation: 6,
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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