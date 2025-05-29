import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../OperationsForm.dart';
import '../Setting.dart';
import 'Operations.dart';

class SumOperations extends StatefulWidget {
  final int grade;

  const SumOperations({super.key, required this.grade});

  @override
  _SumOperationsState createState() => _SumOperationsState();


}

class _SumOperationsState extends State<SumOperations> {
  final TextEditingController _filterController = TextEditingController();
  late List<Map<String, dynamic>> filteredOperations;

  // double progress = 0.0;

  @override
  void initState() {
    super.initState();
    filteredOperations = Operations.getSumOperations(widget.grade).where((op) => op["Grade"] == widget.grade).toList();
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: themeProvider.isNightModeOn ? Colors.white.withOpacity(0.8) :Colors.black.withOpacity(0.8),),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: themeProvider.isNightModeOn ? [Colors.black,Colors.black]: [Colors.blue.shade200, Colors.blue.shade800],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calculate_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Addition",
                    style: TextStyle(
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
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ],
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Show help or instructions
                },
                tooltip: "Help",
              ),
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
      body: Stack(
        children: [
          WaveBackground(isDarkMode: isDarkMode),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _filterController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(16.0),
              //   child: LinearProgressIndicator(
              //       value: progress,
              //       backgroundColor: Colors.grey.shade300,
              //       color: Colors.green),
              // ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredOperations.length,
                  itemBuilder: (context, index) {
                    final operation = filteredOperations[index];
                    return _buildCard(context, operation);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> operation) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
            Color(0xFF2C2C2E), // Dark gray
            Color(0xFF1C1C1E), // Darker gray
          ]
              : [
            Colors.white,
            Colors.grey[100]!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            var title = operation["title"];
            var numbers = operation["generateNumbers"];

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
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    operation["title"],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDarkMode
                        ? Colors.deepPurple.withOpacity(0.2)
                        : Colors.deepPurple.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: isDarkMode
                        ? Colors.deepPurple[200]
                        : Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WaveBackground extends StatefulWidget {
  final bool isDarkMode;

  const WaveBackground({super.key, this.isDarkMode = false});

  @override
  _WaveBackgroundState createState() => _WaveBackgroundState();
}

class _WaveBackgroundState extends State<WaveBackground>
    with SingleTickerProviderStateMixin {
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
      height: MediaQuery.of(context).size.height * 0.35,
      child: Stack(
        children: [
          ClipPath(
            clipper: DoubleWaveClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isDarkMode
                      ? [
                    Color(0xFF1a237e),
                    Color(0xFF311b92),
                  ]
                      : [
                    Color(0xFF2196F3),
                    Color(0xFF1E88E5),
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
                        Color(0xFF512DA8).withOpacity(0.7),
                        Color(0xFF673AB7).withOpacity(0.5),
                      ]
                          : [
                        Color(0xFF64B5F6).withOpacity(0.7),
                        Color(0xFF90CAF9).withOpacity(0.5),
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
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0),
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
//
// class WaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, size.height - 50);
//     path.quadraticBezierTo(
//         size.width / 4, size.height, size.width / 2, size.height - 40);
//     path.quadraticBezierTo(
//         3 / 4 * size.width, size.height - 80, size.width, size.height - 40);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

class DoubleWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height * 0.7);
    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.85);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.75);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.65);
    var secondEndPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

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