import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../Setting.dart';

class OperationsForm extends StatefulWidget {
  final String title;
  final Function generateNumbers;

  const OperationsForm({required this.title, required this.generateNumbers, super.key});

  @override
  _OperationsFormState createState() => _OperationsFormState();
}

class _OperationsFormState extends State<OperationsForm> with SingleTickerProviderStateMixin {
  //#region Variables
  dynamic number1, number2, number3, number4, correctAnswer;
  String? sign;
  int _wrongAnswerCount = 0;
  static const int _maxWrongAttempts = 3;

  final TextEditingController _answerController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final player = AudioPlayer();

  late bool _isSoundOn = false;
  late bool _isVibrationOn = false;

  //#endregion

  //#region Initial State, Dispose, and Load Preferences
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
    _loadPreferences();
    Future.delayed(const Duration(milliseconds: 100), _generateNumbers);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoundOn = prefs.getBool('isSoundOn') ?? false;
      _isVibrationOn = prefs.getBool('isVibrationOn') ?? false;
    });
  }

  //#endregion

  //#region Generate Numbers
  void _generateNumbers() {
    setState(() {
      final numbers = widget.generateNumbers();
      number1 = numbers["number1"].toString();
      number2 = numbers["number2"];
      number3 = numbers["number3"];
      number4 = numbers["number4"];
      sign = numbers["sign"];
      correctAnswer = numbers["result"].toString();
      _wrongAnswerCount = 0;
      _answerController.clear();
      _animationController.forward().then((_) => _animationController.reverse());
    });
  }
  //#endregion

  //#region Problem Box Builder method
  Widget _buildProblemBox(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isNightModeOn;
    final isFractionProblem = widget.title == "Fraction Addition";
    final isComplexProblem = widget.title == "Complex Number Addition";
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 0.08; // Responsive font size
    final containerWidth = screenWidth * 1.2; // Responsive container width
    final textFieldWidth = screenWidth * 0.40; // Responsive TextField width

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: containerWidth,
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [Colors.teal.shade700, Colors.blueGrey.shade800]
                    : [Colors.teal.shade400, Colors.teal.shade700],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: sign == "/"
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      number1,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      width: screenWidth * 0.2,
                      height: 2,
                      color: Colors.white,
                    ),
                    Text(
                      number2.toString(),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  child: Text(
                    "=",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: textFieldWidth,
                  child: TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submitAnswer(),
                    textAlign: TextAlign.center,
                    autofocus: true,
                  ),
                ),
              ],
            )
                : isFractionProblem
                ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                  ),
                  _buildFractionDisplay(number1, fontSize, screenWidth),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    child: Text(
                      sign ?? "+",
                      style: TextStyle(
                        fontSize: fontSize * 0.8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _buildFractionDisplay(number2.toString(), fontSize, screenWidth),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: Text(
                      "=",
                      style: TextStyle(
                        fontSize: fontSize * 0.8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: textFieldWidth * 0.7,
                    child: TextField(
                      controller: _answerController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "a/b",
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      style: TextStyle(
                        fontSize: fontSize * 0.9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submitAnswer(),
                      textAlign: TextAlign.center,
                      autofocus: true,
                    ),
                  ),
                ],
              ),
            )
                : isComplexProblem
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  number1,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "$sign ${number2.toString()}",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 2,
                  height: 20,
                ),
                SizedBox(
                  width: textFieldWidth * 0.65,
                  child: TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "a+bi",
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submitAnswer(),
                    textAlign: TextAlign.center,
                    autofocus: true,
                  ),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (number1 != null)
                  Text(
                    number1.length > 10 ? number1 : number1,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (number2 != null)
                  Text(
                    "$sign  $number2",
                    style: TextStyle(
                      fontSize: fontSize, // Corrected from fontSize
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (number3 != null)
                  Text(
                    "$sign  $number3",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (number4 != null)
                  Text(
                    "$sign  $number4",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                const Divider(
                  color: Colors.white,
                  thickness: 2,
                  height: 20,
                ),
                SizedBox(
                  width: textFieldWidth,
                  child: TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submitAnswer(),
                    textAlign: TextAlign.end,
                    autofocus: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
//#endregion

  //#region Helper method to display fractions
  Widget _buildFractionDisplay(String fractionString, double fontSize, double screenWidth) {
    final parts = fractionString.split('/');
    if (parts.length != 2) return Text(fractionString);

    return Column(
      children: [
        Text(
          parts[0],
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Container(
          width: screenWidth * 0.20,
          height: 2,
          color: Colors.white,
        ),
        Text(
          parts[1],
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
  //#endregion\

  //#region Submit Answer
  void _submitAnswer() {
    final userInput = _answerController.text.trim();

    if (userInput.isEmpty) {
      _showEmptyAnswerDialog();
      return;
    }

    bool isCorrect = false;

    final userInputNormalized = userInput.replaceAll(' ', '');
    final correctAnswerStr = correctAnswer.toString().replaceAll(' ', '');

    final userNum = double.tryParse(userInputNormalized);
    final correctNum = double.tryParse(correctAnswerStr);

    if (userNum != null && correctNum != null) {
      isCorrect = (userNum - correctNum).abs() < 0.001;
    } else {
      isCorrect = userInputNormalized.toLowerCase() == correctAnswerStr.toLowerCase();
    }

    if (isCorrect) {
      if (_isSoundOn) {
        player.play(AssetSource('sounds/correct.mp3'));
      }
      _showResultDialog(true);
    } else {
      if (_isSoundOn) {
        player.play(AssetSource('sounds/wrong.mp3'));
      }

      if (_isVibrationOn) {
        Vibration.hasVibrator().then((hasVibrator) {
          if (hasVibrator) {
            Vibration.vibrate(duration: 200);
          }
        });
      }

      setState(() => _wrongAnswerCount++);
      if (_wrongAnswerCount >= _maxWrongAttempts) {
        _showMaxAttemptsReachedDialog();
      } else {
        _showResultDialog(false);
      }
    }
  }
  //#endregion

  //#region Show Empty Answer Dialog
  void _showEmptyAnswerDialog() {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDarkMode ? Color(0xFF252525) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDarkMode
                ? Color.fromRGBO(128, 255, 219, 0.3)  // Colors.tealAccent
                : Color.fromRGBO(0, 150, 136, 0.3),   // Colors.teal
            width: 2,
          ),
        ),
        title: Text(
          "Hey There!",
          style: TextStyle(
            color: isDarkMode ? Colors.tealAccent : Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/Gif/empty.gif',
              height: screenWidth * 0.25,
              width: screenWidth * 0.25,
            ),
            SizedBox(height: screenWidth * 0.04),
            Text(
              "Please enter an answer!",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.tealAccent : Colors.teal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              foregroundColor: isDarkMode ? Colors.black : Colors.white,
            ),
            child: Text("OK", style: TextStyle(fontSize: screenWidth * 0.04)),
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Show Result Dialog
  void _showResultDialog(bool isValid) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (_) {
        // Auto-dismiss after 1 second
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && Navigator.of(context).canPop()) {
            // Navigator.pop(context);
            if (isValid) {
              _generateNumbers();
              _answerController.clear();
            }
          }
        });
        return AlertDialog(
          backgroundColor: isDarkMode ? Color(0xFF252525) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isValid
                  ? (isDarkMode
                  ? Color.fromRGBO(185, 246, 202, 0.5) // Colors.greenAccent
                  : Color.fromRGBO(76, 175, 80, 0.3))  // Colors.green
                  : (isDarkMode
                  ? Color.fromRGBO(255, 82, 82, 0.5)   // Colors.redAccent
                  : Color.fromRGBO(244, 67, 54, 0.3)), // Colors.red

              width: 2,
            ),
          ),
          title: Text(
            isValid ? "🎉 Correct!" : "❌ Oops!",
            style: TextStyle(
              color: isValid
                  ? (isDarkMode ? Colors.greenAccent : Colors.green)
                  : (isDarkMode ? Colors.redAccent : Colors.red),
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isValid
                  ? Image.asset(
                'assets/Gif/happy5.gif',
                height: screenWidth * 0.30,
                width: screenWidth * 0.30,
              )
                  : Image.asset(
                'assets/Gif/wrong.gif',
                height: screenWidth * 0.30,
                width: screenWidth * 0.30,
              ),
              SizedBox(height: screenWidth * 0.05),
              Text(
                isValid ? 'Great job!' : 'Try again!',
                style: TextStyle(
                  fontSize: screenWidth * 0.050,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isValid)
                Text(
                  "\nAttempts: $_wrongAnswerCount/$_maxWrongAttempts",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        );
      },
    );
  }
  //#endregion

  //#region Show Max Attempts Reached Dialog
  void _showMaxAttemptsReachedDialog() {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDarkMode ? Color(0xFF252525) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDarkMode
                ? Color.fromRGBO(255, 82, 82, 0.5)   // Colors.redAccent
                : Color.fromRGBO(244, 67, 54, 0.3),  // Colors.red
            width: 2,
          ),
        ),
        title: Text(
          "Maximum Attempts Reached!",
          style: TextStyle(
            color: isDarkMode ? Colors.redAccent : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/Gif/wrong2.gif',
              height: screenWidth * 0.25,
              width: screenWidth * 0.25,
            ),
            SizedBox(height: screenWidth * 0.025),
            Text(
              "You've used all your attempts!",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Correct Answer: ${correctAnswer.toString()}',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _generateNumbers();
              _answerController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.tealAccent : Colors.teal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              foregroundColor: isDarkMode ? Colors.black : Colors.white,
            ),
            child: Text("Next", style: TextStyle(fontSize: screenWidth * 0.04)),
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Show Exit Confirmation Dialog
  Future<bool> _showExitConfirmationDialog() async {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;
    final screenWidth = MediaQuery.of(context).size.width;

    return await showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: screenWidth * 0.9,
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF252525) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0,0,0,0.2),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: isDarkMode
                  ? Color.fromRGBO(244, 67, 54, 0.2)  // Colors.red
                  : Color.fromRGBO(244, 67, 54, 0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Leave Page?",
                style: TextStyle(
                  color: isDarkMode ? Colors.red[300] : Colors.red[600],
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.050,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenWidth * 0.03),
              Text(
                "Are you sure you want to leave?",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenWidth * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenWidth * 0.025,
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.red[400] : Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenWidth * 0.025,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Leave",
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ?? false;
  }
//#endregion

  //#region Page UI
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isNightModeOn;
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.08;
    final padding = screenWidth * 0.04;

    return SafeArea(
      child: WillPopScope(
        onWillPop: _showExitConfirmationDialog,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.blueGrey.shade900, Colors.black87]
                    : [ Color.fromRGBO(0, 150, 136, 0.8),  // Colors.teal
                        Color.fromRGBO(33, 150, 243, 0.8), // Colors.blue
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              image: DecorationImage(
                image: const AssetImage('assets/BackGround/Background.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  isDarkMode ? Color.fromRGBO(0,0,0,0.7) : Color.fromRGBO(0,0,0,0.2),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Column(
              children: [
                // Custom AppBar
                Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDarkMode
                          ? [Colors.black87, Colors.blueGrey.shade900]
                          : [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
                    ),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0,0,0,0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (await _showExitConfirmationDialog()) Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(padding * 0.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                          ),
                          child: Icon(
                            Icons.close,
                            color: isDarkMode ? Colors.tealAccent : Colors.deepPurple,
                            size: fontSize * 0.8,
                          ),
                        ),
                      ),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            widget.title,
                            key: ValueKey(widget.title),
                            style: TextStyle(
                              fontSize: fontSize * 0.8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(width: padding * 2),
                    ],
                  ),
                ),
                // Attempts Indicator
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      _maxWrongAttempts,
                          (index) => Icon(
                        index < _wrongAnswerCount ? Icons.close : Icons.favorite,
                        color: index < _wrongAnswerCount ? Colors.red : Colors.red,
                        size: fontSize * 1.3,
                      ),
                    ),
                  ),
                ),
                // Main Content
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            children: [
                              if (number1 != null) _buildProblemBox(context),
                              Padding(
                                padding: EdgeInsets.all(padding),
                                child: GestureDetector(
                                  onTap: _submitAnswer,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: padding,
                                      horizontal: padding,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? Colors.tealAccent : Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5,
                                          offset: Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      'assets/icons/next.png',
                                      width: fontSize * 1.3,
                                      height: fontSize * 1.3,
                                      color: isDarkMode ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

}