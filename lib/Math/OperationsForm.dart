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

  //#region Initial State , Dispose and Load Preferences
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 10),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadPreferences();
    Future.delayed(const Duration(milliseconds: 5), _generateNumbers);
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
  Widget _buildProblemBox() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isNightModeOn;
    final isFractionProblem = widget.title == "Fraction Addition";
    final isComplexProblem = widget.title == "Complex Number Addition";

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.all(20),
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
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: sign == "/"
                ? Column(
              children: [
                // For division, show in row-like division layout
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          number1,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          width: 100,
                          height: 2,
                          color: Colors.white,
                        ),
                        Text(
                          number2.toString(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        "=",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        style: const TextStyle(
                          fontSize: 28,
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
                ),
              ],
            )
                : isFractionProblem
                ? Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Allows scrolling if content overflows
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // First fraction
                      _buildFractionDisplay(number1),

                      // Operation sign
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8), // Reduce spacing for better fit
                        child: Text(
                          sign ?? "+",
                          style: const TextStyle(
                            fontSize: 24, // Slightly smaller font size for better fit
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Second fraction
                      _buildFractionDisplay(number2.toString()),

                      // Equal sign
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "=",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Answer input formatted as fraction
                      SizedBox(
                        width: 80, // Adjust width for better responsiveness
                        child: TextField(
                          controller: _answerController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "a/b",
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          style: const TextStyle(
                            fontSize: 24, // Slightly smaller font
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
                ),
              ],
            )

                : isComplexProblem
                ? Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // First complex number
                    Text(
                      number1,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // // Operation sign
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 12),
                    //   child: Text(
                    //     sign ?? "+",
                    //     style: const TextStyle(
                    //       fontSize: 28,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),

                    // Second complex number
                    Text(
                      "$sign ${number2.toString()}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // Equal sign
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 12),
                    //   child: Text(
                    //     "=",
                    //     style: const TextStyle(
                    //       fontSize: 28,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                      height: 20,
                    ),
                    // Answer input formatted as complex number
                    SizedBox(
                      width: 65,
                      child: TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "a+bi",
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        style: const TextStyle(
                          fontSize: 28,
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
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Original layout for other operations
                if (number1 != null)
                  Text(
                    number1.length > 10 ? number1 : number1,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (number2 != null)
                  Text(
                    "$sign  $number2",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (number3 != null)
                  Text(
                    "$sign  $number3",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (number4 != null)
                  Text(
                    "$sign  $number4",
                    style: const TextStyle(
                      fontSize: 28,
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
                  width: 100,
                  child: TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    style: const TextStyle(
                      fontSize: 28,
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
  Widget _buildFractionDisplay(String fractionString) {
    final parts = fractionString.split('/');
    if (parts.length != 2) return Text(fractionString);

    return Column(
      children: [
        Text(
          parts[0],
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Container(
          width: 50,
          height: 2,
          color: Colors.white,
        ),
        Text(
          parts[1],
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
  //#endregion

  //#region Page UI
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isNightModeOn;

    return WillPopScope(
      onWillPop: _showExitConfirmationDialog,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.blueGrey.shade900, Colors.black87]
                    : [Colors.teal.withOpacity(0.8), Colors.blue.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              image: DecorationImage(
                image: const AssetImage('assets/BackGround/Background.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    isDarkMode ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.2),
                    BlendMode.darken
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Custom AppBar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [Colors.black87, Colors.blueGrey.shade900]
                            : [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
                      ),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
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
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                            ),
                            child: Icon(
                                Icons.close,
                                color: isDarkMode ? Colors.tealAccent : Colors.deepPurple
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 50),
                            child: Text(
                              widget.title,
                              key: ValueKey(widget.title),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40), // Balance
                      ],
                    ),
                  ),
                  // Attempts Indicator
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: List.generate(
                        _maxWrongAttempts,
                            (index) => Icon(
                          index < _wrongAnswerCount ? Icons.close : Icons.favorite,
                          color: index < _wrongAnswerCount ? Colors.red : Colors.red,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                  // Main Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            if (number1 != null) _buildProblemBox(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTap: _submitAnswer,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                                    width: 32,
                                    height: 32,
                                    color: isDarkMode ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Sticky Submit Button
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: ElevatedButton(
                  //     onPressed: _submitAnswer,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: isDarkMode ? Colors.tealAccent : Colors.deepPurple,
                  //       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //       elevation: 5,
                  //     ),
                  //     child: Text(
                  //       "Submit",
                  //       style: TextStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //           color: isDarkMode ? Colors.black : Colors.white
                  //       ),
                  //     ),
                  //   ),
                  // ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  //#endregion

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
      // Fallback to string comparison (case-insensitive)
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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDarkMode ? Color(0xFF252525) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDarkMode ? Colors.tealAccent.withOpacity(0.3) : Colors.teal.withOpacity(0.3),
            width: 2,
          ),
        ),
        title: Text(
          "Hey There!",
          style: TextStyle(
              color: isDarkMode ? Colors.tealAccent : Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // GIF above the text
            Image.asset(
              'assets/Gif/empty.gif',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 16),
            Text(
              "Please enter an answer!",
              style: TextStyle(
                fontSize: 18,
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
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Show Result Dialog
  void _showResultDialog(bool isValid) {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDarkMode ? Color(0xFF252525) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isValid
                ? (isDarkMode ? Colors.greenAccent.withOpacity(0.5) : Colors.green.withOpacity(0.3))
                : (isDarkMode ? Colors.redAccent.withOpacity(0.5) : Colors.red.withOpacity(0.3)),
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
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // GIF above the text
            isValid
                ? Image.asset(
              'assets/Gif/happy5.gif',
              height: 100,
              width: 100,
            )
                : Image.asset(
              'assets/Gif/wrong.gif',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),
            Text(
              isValid ? 'Great job!' : 'Try again!',
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            if (!isValid)
              Text(
                "\nAttempts: $_wrongAnswerCount/$_maxWrongAttempts",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black87
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (isValid) {
                _generateNumbers();
                _answerController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isValid
                  ? (isDarkMode ? Colors.greenAccent : Colors.green)
                  : (isDarkMode ? Colors.tealAccent : Colors.teal),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              foregroundColor: isDarkMode ? Colors.black : Colors.white,
            ),
            child: Text(isValid ? "Next" : "OK"),
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Show Max Attempts Reached Dialog
  void _showMaxAttemptsReachedDialog() {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDarkMode ? Color(0xFF252525) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDarkMode ? Colors.redAccent.withOpacity(0.5) : Colors.red.withOpacity(0.3),
            width: 2,
          ),
        ),
        title: Text(
          "OOOHHHHHHHH!",
          style: TextStyle(
              color: isDarkMode ? Colors.redAccent : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/Gif/wrong2.gif',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 10),
            Text(
              'You have reached the maximum number of attempts.',
              style: TextStyle(
                fontSize: 20,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Correct Answer is : ${correctAnswer.toString()}',
              style: TextStyle(
                fontSize: 18,
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
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }
  //#endregion

  //#region Show Exit Confirmation Dialog
  Future<bool> _showExitConfirmationDialog() async {
    final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;

    return await showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF252525) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: isDarkMode
                  ? Colors.red.withOpacity(0.2)
                  : Colors.red.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                "Leave Page?",
                style: TextStyle(
                  color: isDarkMode ? Colors.red[300] : Colors.red[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12),

              // Description
              Text(
                "Are you sure you want to leave?",
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  // Leave Button
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.red[400] : Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Leave",
                      style: TextStyle(fontSize: 15),
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

}


// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vibration/vibration.dart';
// import '../Setting.dart';
//
// class OperationsForm extends StatefulWidget {
//   final String title;
//   final Function generateNumbers;
//
//   const OperationsForm({required this.title, required this.generateNumbers, super.key});
//
//   @override
//   _OperationsFormState createState() => _OperationsFormState();
// }
//
// class _OperationsFormState extends State<OperationsForm> with SingleTickerProviderStateMixin {
//   // Variables
//   dynamic number1, number2, number3, number4, correctAnswer;
//   String? sign;
//   int _wrongAnswerCount = 0;
//   static const int _maxWrongAttempts = 3;
//
//   final TextEditingController _answerController = TextEditingController();
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//
//   final player = AudioPlayer();
//
//   late bool _isSoundOn = false;
//   late bool _isVibrationOn = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 100),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _loadPreferences();
//     Future.delayed(const Duration(milliseconds: 100), _generateNumbers);
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     _answerController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _isSoundOn = prefs.getBool('isSoundOn') ?? false;
//       _isVibrationOn = prefs.getBool('isVibrationOn') ?? false;
//     });
//   }
//
//   void _generateNumbers() {
//     setState(() {
//       final numbers = widget.generateNumbers();
//       number1 = numbers["number1"].toString();
//       number2 = numbers["number2"];
//       number3 = numbers["number3"];
//       number4 = numbers["number4"];
//       sign = numbers["sign"];
//       correctAnswer = numbers["result"].toString();
//       _wrongAnswerCount = 0;
//       _answerController.clear();
//       _animationController.forward().then((_) => _animationController.reverse());
//     });
//   }
//
//   Widget _buildProblemBox(BuildContext context) {
//     final isDarkMode = Provider.of<ThemeProvider>(context).isNightModeOn;
//     final isFractionProblem = widget.title == "Fraction Addition";
//     final isComplexProblem = widget.title == "Complex Number Addition";
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final fontSize = screenWidth < 400 ? 20.0 : screenWidth < 600 ? 24.0 : 28.0;
//     final containerPadding = screenWidth < 400 ? 10.0 : 20.0;
//     final textFieldWidth = screenWidth < 400 ? 60.0 : screenWidth < 600 ? 80.0 : 100.0;
//
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: _scaleAnimation.value,
//           child: Container(
//             margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
//             padding: EdgeInsets.all(containerPadding),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: isDarkMode
//                     ? [Colors.teal.shade700, Colors.blueGrey.shade800]
//                     : [Colors.teal.shade400, Colors.teal.shade700],
//               ),
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return sign == "/"
//                     ? Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           number1,
//                           style: TextStyle(
//                             fontSize: fontSize,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         Container(
//                           width: textFieldWidth,
//                           height: 2,
//                           color: Colors.white,
//                         ),
//                         Text(
//                           number2.toString(),
//                           style: TextStyle(
//                             fontSize: fontSize,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: containerPadding / 2),
//                       child: Text(
//                         "=",
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: textFieldWidth,
//                       child: TextField(
//                         controller: _answerController,
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           hintStyle: TextStyle(color: Colors.white54),
//                         ),
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.done,
//                         onSubmitted: (_) => _submitAnswer(),
//                         textAlign: TextAlign.center,
//                         autofocus: true,
//                       ),
//                     ),
//                   ],
//                 )
//                     : isFractionProblem
//                     ? SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildFractionDisplay(number1, fontSize, textFieldWidth),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: containerPadding / 2),
//                         child: Text(
//                           sign ?? "+",
//                           style: TextStyle(
//                             fontSize: fontSize * 0.9,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       _buildFractionDisplay(number2.toString(), fontSize, textFieldWidth),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: containerPadding / 2),
//                         child: Text(
//                           "=",
//                           style: TextStyle(
//                             fontSize: fontSize * 0.9,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: textFieldWidth,
//                         child: TextField(
//                           controller: _answerController,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             hintText: "a/b",
//                             hintStyle: TextStyle(color: Colors.white54),
//                           ),
//                           style: TextStyle(
//                             fontSize: fontSize,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           keyboardType: TextInputType.text,
//                           textInputAction: TextInputAction.done,
//                           onSubmitted: (_) => _submitAnswer(),
//                           textAlign: TextAlign.center,
//                           autofocus: true,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : isComplexProblem
//                     ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       number1,
//                       style: TextStyle(
//                         fontSize: fontSize,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       "$sign ${number2.toString()}",
//                       style: TextStyle(
//                         fontSize: fontSize,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Divider(
//                       color: Colors.white,
//                       thickness: 2,
//                       height: containerPadding,
//                     ),
//                     SizedBox(
//                       width: textFieldWidth * 0.8,
//                       child: TextField(
//                         controller: _answerController,
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           hintText: "a+bi",
//                           hintStyle: TextStyle(color: Colors.white54),
//                         ),
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                         keyboardType: TextInputType.text,
//                         textInputAction: TextInputAction.done,
//                         onSubmitted: (_) => _submitAnswer(),
//                         textAlign: TextAlign.center,
//                         autofocus: true,
//                       ),
//                     ),
//                   ],
//                 )
//                     : Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     if (number1 != null)
//                       Text(
//                         number1.length > 10 ? number1.substring(0, 10) + "..." : number1,
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     if (number2 != null)
//                       Text(
//                         "$sign  $number2",
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     if (number3 != null)
//                       Text(
//                         "$sign  $number3",
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     if (number4 != null)
//                       Text(
//                         "$sign  $number4",
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     Divider(
//                       color: Colors.white,
//                       thickness: 2,
//                       height: containerPadding,
//                     ),
//                     SizedBox(
//                       width: textFieldWidth,
//                       child: TextField(
//                         controller: _answerController,
//                         decoration: const InputDecoration(
//                           border: InputBorder.none,
//                           hintStyle: TextStyle(color: Colors.white54),
//                         ),
//                         style: TextStyle(
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                         keyboardType: TextInputType.number,
//                         textInputAction: TextInputAction.done,
//                         onSubmitted: (_) => _submitAnswer(),
//                         textAlign: TextAlign.end,
//                         autofocus: true,
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildFractionDisplay(String fractionString, double fontSize, double width) {
//     final parts = fractionString.split('/');
//     if (parts.length != 2) return Text(fractionString);
//
//     return Column(
//       children: [
//         Text(
//           parts[0],
//           style: TextStyle(
//             fontSize: fontSize,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         Container(
//           width: width * 0.5,
//           height: 2,
//           color: Colors.white,
//         ),
//         Text(
//           parts[1],
//           style: TextStyle(
//             fontSize: fontSize,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Provider.of<ThemeProvider>(context).isNightModeOn;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final padding = screenWidth < 400 ? 8.0 : 16.0;
//
//     return WillPopScope(
//       onWillPop: _showExitConfirmationDialog,
//       child: SafeArea(
//         child: Scaffold(
//           body: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: isDarkMode
//                     ? [Colors.blueGrey.shade900, Colors.black87]
//                     : [Colors.teal.withOpacity(0.8), Colors.blue.withOpacity(0.8)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               image: DecorationImage(
//                 image: const AssetImage('assets/BackGround/Background.jpeg'),
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                   isDarkMode ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.2),
//                   BlendMode.darken,
//                 ),
//               ),
//             ),
//             child: Column(
//               children: [
//                 // Custom AppBar
//                 Container(
//                   padding: EdgeInsets.all(padding),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: isDarkMode
//                           ? [Colors.black87, Colors.blueGrey.shade900]
//                           : [Colors.deepPurple.shade700, Colors.deepPurple.shade900],
//                     ),
//                     borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () async {
//                           if (await _showExitConfirmationDialog()) Navigator.pop(context);
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(padding / 2),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: isDarkMode ? Colors.grey.shade800 : Colors.white,
//                           ),
//                           child: Icon(
//                             Icons.close,
//                             color: isDarkMode ? Colors.tealAccent : Colors.deepPurple,
//                             size: screenWidth < 400 ? 20 : 24,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: AnimatedSwitcher(
//                           duration: const Duration(milliseconds: 300),
//                           child: Text(
//                             widget.title,
//                             key: ValueKey(widget.title),
//                             style: TextStyle(
//                               fontSize: screenWidth < 400 ? 20 : 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: screenWidth < 400 ? 20 : 40),
//                     ],
//                   ),
//                 ),
//                 // Attempts Indicator
//                 Padding(
//                   padding: EdgeInsets.all(padding),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: List.generate(
//                       _maxWrongAttempts,
//                           (index) => Icon(
//                         index < _wrongAnswerCount ? Icons.close : Icons.favorite,
//                         color: index < _wrongAnswerCount ? Colors.red : Colors.red,
//                         size: screenWidth < 400 ? 20 : 25,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Main Content
//                 Expanded(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Padding(
//                       padding: EdgeInsets.all(padding),
//                       child: Column(
//                         children: [
//                           if (number1 != null) _buildProblemBox(context),
//                           Padding(
//                             padding: EdgeInsets.all(padding),
//                             child: GestureDetector(
//                               onTap: _submitAnswer,
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: padding,
//                                   horizontal: padding,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: isDarkMode ? Colors.tealAccent : Colors.deepPurple,
//                                   borderRadius: BorderRadius.circular(100),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black26,
//                                       blurRadius: 5,
//                                       offset: Offset(2, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Image.asset(
//                                   'assets/icons/next.png',
//                                   width: screenWidth < 400 ? 24 : 32,
//                                   height: screenWidth < 400 ? 24 : 32,
//                                   color: isDarkMode ? Colors.black : Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _submitAnswer() {
//     final userInput = _answerController.text.trim();
//
//     if (userInput.isEmpty) {
//       _showEmptyAnswerDialog();
//       return;
//     }
//
//     bool isCorrect = false;
//     final userInputNormalized = userInput.replaceAll(' ', '');
//     final correctAnswerStr = correctAnswer.toString().replaceAll(' ', '');
//
//     final userNum = double.tryParse(userInputNormalized);
//     final correctNum = double.tryParse(correctAnswerStr);
//
//     if (userNum != null && correctNum != null) {
//       isCorrect = (userNum - correctNum).abs() < 0.001;
//     } else {
//       isCorrect = userInputNormalized.toLowerCase() == correctAnswerStr.toLowerCase();
//     }
//
//     if (isCorrect) {
//       if (_isSoundOn) {
//         player.play(AssetSource('sounds/correct.mp3'));
//       }
//       _showResultDialog(true);
//     } else {
//       if (_isSoundOn) {
//         player.play(AssetSource('sounds/wrong.mp3'));
//       }
//       if (_isVibrationOn) {
//         Vibration.hasVibrator().then((hasVibrator) {
//           if (hasVibrator) {
//             Vibration.vibrate(duration: 200);
//           }
//         });
//       }
//       setState(() => _wrongAnswerCount++);
//       if (_wrongAnswerCount >= _maxWrongAttempts) {
//         _showMaxAttemptsReachedDialog();
//       } else {
//         _showResultDialog(false);
//       }
//     }
//   }
//
//   void _showEmptyAnswerDialog() {
//     final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: isDarkMode ? Color(0xFF252525) : Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: BorderSide(
//             color: isDarkMode ? Colors.tealAccent.withOpacity(0.3) : Colors.teal.withOpacity(0.3),
//             width: 2,
//           ),
//         ),
//         title: Text(
//           "Hey There!",
//           style: TextStyle(
//             color: isDarkMode ? Colors.tealAccent : Colors.teal,
//             fontWeight: FontWeight.bold,
//             fontSize: screenWidth < 400 ? 18 : 20,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(
//               'assets/Gif/empty.gif',
//               height: screenWidth < 400 ? 80 : 100,
//               width: screenWidth < 400 ? 80 : 100,
//             ),
//             SizedBox(height: screenWidth < 400 ? 12 : 16),
//             Text(
//               "Please enter an answer!",
//               style: TextStyle(
//                 fontSize: screenWidth < 400 ? 16 : 18,
//                 color: isDarkMode ? Colors.white : Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isDarkMode ? Colors.tealAccent : Colors.teal,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               foregroundColor: isDarkMode ? Colors.black : Colors.white,
//             ),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showResultDialog(bool isValid) {
//     final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: isDarkMode ? Color(0xFF252525) : Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: BorderSide(
//             color: isValid
//                 ? (isDarkMode ? Colors.greenAccent.withOpacity(0.5) : Colors.green.withOpacity(0.3))
//                 : (isDarkMode ? Colors.redAccent.withOpacity(0.5) : Colors.red.withOpacity(0.3)),
//             width: 2,
//           ),
//         ),
//         title: Text(
//           isValid ? "🎉 Correct!" : "❌ Oops!",
//           style: TextStyle(
//             color: isValid
//                 ? (isDarkMode ? Colors.greenAccent : Colors.green)
//                 : (isDarkMode ? Colors.redAccent : Colors.red),
//             fontWeight: FontWeight.bold,
//             fontSize: screenWidth < 400 ? 18 : 20,
//           ),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(
//               isValid ? 'assets/Gif/happy5.gif' : 'assets/Gif/wrong.gif',
//               height: screenWidth < 400 ? 80 : 100,
//               width: screenWidth < 400 ? 80 : 100,
//             ),
//             SizedBox(height: screenWidth < 400 ? 16 : 20),
//             Text(
//               isValid ? 'Great job!' : 'Try again!',
//               style: TextStyle(
//                 fontSize: screenWidth < 400 ? 16 : 18,
//                 color: isDarkMode ? Colors.white : Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             if (!isValid)
//               Text(
//                 "\nAttempts: $_wrongAnswerCount/$_maxWrongAttempts",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: screenWidth < 400 ? 14 : 16,
//                   color: isDarkMode ? Colors.white70 : Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               if (isValid) {
//                 _generateNumbers();
//                 _answerController.clear();
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isValid
//                   ? (isDarkMode ? Colors.greenAccent : Colors.green)
//                   : (isDarkMode ? Colors.tealAccent : Colors.teal),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               foregroundColor: isDarkMode ? Colors.black : Colors.white,
//             ),
//             child: Text(isValid ? "Next" : "OK"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showMaxAttemptsReachedDialog() {
//     final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         backgroundColor: isDarkMode ? Color(0xFF252525) : Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: BorderSide(
//             color: isDarkMode ? Colors.redAccent.withOpacity(0.5) : Colors.red.withOpacity(0.3),
//             width: 2,
//           ),
//         ),
//         title: Text(
//           "OOOHHHHHHHH!",
//           style: TextStyle(
//             color: isDarkMode ? Colors.redAccent : Colors.red,
//             fontWeight: FontWeight.bold,
//             fontSize: screenWidth < 400 ? 18 : 20,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(
//               'assets/Gif/wrong2.gif',
//               height: screenWidth < 400 ? 80 : 100,
//               width: screenWidth < 400 ? 80 : 100,
//             ),
//             SizedBox(height: screenWidth < 400 ? 8 : 10),
//             Text(
//               'You have reached the maximum number of attempts.',
//               style: TextStyle(
//                 fontSize: screenWidth < 400 ? 18 : 20,
//                 color: isDarkMode ? Colors.white : Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             Text(
//               'Correct Answer is: ${correctAnswer.toString()}',
//               style: TextStyle(
//                 fontSize: screenWidth < 400 ? 16 : 18,
//                 color: isDarkMode ? Colors.white : Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _generateNumbers();
//               _answerController.clear();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: isDarkMode ? Colors.tealAccent : Colors.teal,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               foregroundColor: isDarkMode ? Colors.black : Colors.white,
//             ),
//             child: const Text("Try Again"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<bool> _showExitConfirmationDialog() async {
//     final isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isNightModeOn;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return await showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         child: Container(
//           width: screenWidth * 0.8,
//           padding: EdgeInsets.all(screenWidth < 400 ? 16 : 20),
//           decoration: BoxDecoration(
//             color: isDarkMode ? Color(0xFF252525) : Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 10,
//                 offset: Offset(0, 5),
//               ),
//             ],
//             border: Border.all(
//               color: isDarkMode ? Colors.red.withOpacity(0.2) : Colors.red.withOpacity(0.1),
//               width: 1,
//             ),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Leave Page?",
//                 style: TextStyle(
//                   color: isDarkMode ? Colors.red[300] : Colors.red[600],
//                   fontWeight: FontWeight.bold,
//                   fontSize: screenWidth < 400 ? 16 : 18,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: screenWidth < 400 ? 8 : 12),
//               Text(
//                 "Are you sure you want to leave?",
//                 style: TextStyle(
//                   fontSize: screenWidth < 400 ? 14 : 16,
//                   color: isDarkMode ? Colors.white : Colors.black87,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: screenWidth < 400 ? 16 : 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, false),
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenWidth < 400 ? 16 : 20,
//                         vertical: screenWidth < 400 ? 8 : 10,
//                       ),
//                     ),
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(
//                         color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
//                         fontSize: screenWidth < 400 ? 14 : 15,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: screenWidth < 400 ? 12 : 16),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context, true),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isDarkMode ? Colors.red[400] : Colors.red,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenWidth < 400 ? 20 : 24,
//                         vertical: screenWidth < 400 ? 8 : 10,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Text(
//                       "Leave",
//                       style: TextStyle(fontSize: screenWidth < 400 ? 14 : 15),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ) ?? false;
//   }
// }