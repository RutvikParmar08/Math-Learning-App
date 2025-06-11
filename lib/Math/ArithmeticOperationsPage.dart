import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'OperationsForm.dart';
import '../Setting.dart';
import 'MathHelpPage.dart';
import 'Operations.dart';

class ArithmeticOperationsPage extends StatefulWidget {
  final int grade;
  final String operation;

  const ArithmeticOperationsPage({super.key, required this.grade, required this.operation});

  @override
  _OperationsPageState createState() => _OperationsPageState();
}

class _OperationsPageState extends State<ArithmeticOperationsPage> {
  final TextEditingController _filterController = TextEditingController();
  late List<Map<String, dynamic>> filteredOperations;

  //#region Init State  , dispose , operation initialize
  @override
  void initState() {
    super.initState();
    _initializeOperations();
    _filterController.addListener(_filterOperations);
  }

  @override
  void dispose() {
    _filterController.removeListener(_filterOperations);
    _filterController.dispose();
    super.dispose();
  }

  void _initializeOperations() {
    final operationData = _getOperationData();
    filteredOperations = operationData['operations']
        .where((op) => op["Grade"] == widget.grade)
        .toList();
  }
  //#endregion

  void _filterOperations() {
    final query = _filterController.text.toLowerCase();
    setState(() {
      final operationData = _getOperationData();
      filteredOperations = operationData['operations']
          .where((op) =>
      op["Grade"] == widget.grade &&
          op["title"].toString().toLowerCase().contains(query))
          .toList();
    });
  }


  //#region Get Operations Method
  Map<String, dynamic> _getOperationData() {
    final operationsMap = {
      'Addition': {
        'operations': Operations.getSumOperations(widget.grade),
        'helpPage': MathHelpPage(grade: widget.grade, operation: 'Addition'),
      },
      'Subtraction': {
        'operations': Operations.getSubtractionOperations(widget.grade),
        'helpPage': MathHelpPage(grade: widget.grade, operation: 'Subtraction'),
      },
      'Multiplication': {
        'operations': Operations.getMultiplicationOperations(widget.grade),
        'helpPage': MathHelpPage(grade: widget.grade, operation: 'Multiplication'),
      },
      'Division': {
        'operations': Operations.getDivisionOperations(widget.grade),
        'helpPage': MathHelpPage(grade: widget.grade, operation: 'Division'),
      },
    };

    return operationsMap[widget.operation] ?? {
      'operations': [],
      'helpPage': const SizedBox(),
    };
  }
  //#endregion

  //#region Page UI
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Color.fromRGBO(255,255,255,0.2)
                : Color.fromRGBO(255,255,255,0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
            splashRadius: 20,
          ),
        ),
        iconTheme: IconThemeData(
          color: themeProvider.isNightModeOn
              ? Color.fromRGBO(255,255,255,0.8)
              : Color.fromRGBO(0,0,0,0.8),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: themeProvider.isNightModeOn
                  ? [Colors.black, Colors.black]
                  : [Colors.blue.shade200, Colors.blue.shade800],
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calculate_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.operation,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Grade ${widget.grade}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(255, 255, 255,0.85),
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.help_outline_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _getOperationData()['helpPage'],
                  ),
                );
              },
              tooltip: "Help",
            ),
          ),
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            WaveBackground(isDarkMode: isDarkMode),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _filterController,
                    decoration: InputDecoration(
                      labelText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isTablet = constraints.maxWidth > 600;
                      return isTablet
                          ? GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3.5,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                        itemCount: filteredOperations.length,
                        itemBuilder: (context, index) {
                          final operation = filteredOperations[index];
                          return _buildCard(context, operation);
                        },
                      )
                          : ListView.builder(
                        itemCount: filteredOperations.length,
                        itemBuilder: (context, index) {
                          final operation = filteredOperations[index];
                          return _buildCard(context, operation);
                        },
                      );
                    },
                  ),
                ),
        
              ],
            ),
          ],
        ),
      ),
    );
  }
  //#endregion

  //#region card Build Method
  Widget _buildCard(BuildContext context, Map<String, dynamic> operation) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
            const Color(0xFF2C2C2E), // Dark gray
            const Color(0xFF1C1C1E), // Darker gray
          ]
              : [
            Colors.white,
            Colors.grey[100]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Color.fromRGBO(0, 0, 0,0.3)
                : Color.fromRGBO(158,158,158,0.2),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            final title = operation["title"];
            final numbers = operation["generateNumbers"];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OperationsForm(
                  title: title,
                  generateNumbers: numbers,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 20 : 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    operation["title"],
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 600 ? 18 : 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? Color.fromRGBO(103, 58, 183, 0.2) // Deep Purple with 20% opacity
                        : Color.fromRGBO(103, 58, 183, 0.1) // Deep Purple with 10% opacity

                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isDarkMode ? Colors.deepPurple[200] : Colors.deepPurple,
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

//#region  WaveBackground, DoubleWaveClipper, and AnimatedWaveClipper

//#region WaveBackground Class
class WaveBackground extends StatefulWidget {
  final bool isDarkMode;

  const WaveBackground({super.key, this.isDarkMode = false});

  @override
  _WaveBackgroundState createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.width > 600 ? 250 : MediaQuery.of(context).size.height * 0.35,
      child: Stack(
        children: [
          ClipPath(
            clipper: DoubleWaveClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isDarkMode
                      ? [
                    const Color(0xFF1a237e),
                    const Color(0xFF311b92),
                  ]
                      : [
                    const Color(0xFF2196F3),
                    const Color(0xFF1E88E5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ClipPath(
                clipper: AnimatedWaveClipper(_controller.value),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.isDarkMode
                          ? [
                        Color.fromRGBO(81, 45, 168, 0.7),
                        Color.fromRGBO(103, 58, 183, 0.5)
                      ]
                          : [
                        Color.fromRGBO(100, 181, 246, 0.7),
                        Color.fromRGBO(144, 202, 249, 0.5)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              );
            },
          ),
          if (!widget.isDarkMode)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(255,255,255,0.2),
                      Color.fromRGBO(255,255,255,0.1),
                      Color.fromRGBO(255,255,255,0),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
//#endregion

//#region DoubleWaveClipper Class
class DoubleWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.7);
    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.85);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.65);
    var secondEndPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
//#endregion

//#region AnimatedWaveClipper Class
class AnimatedWaveClipper extends CustomClipper<Path> {
  final double animation;

  AnimatedWaveClipper(this.animation);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.75);
    for (int i = 0; i < size.width.toInt(); i++) {
      path.lineTo(
          i.toDouble(),
          size.height * 0.75 +
              sin((i / size.width * 2 * pi) + (animation * 2 * pi)) * 20);
    }
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

//#endregion

//#endregion