import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../OperationsForm.dart';
import '../Setting.dart';
import 'Operations.dart';
import 'SumOperations.dart';

class MultiplicationOperations extends StatefulWidget {
  final int grade;

  MultiplicationOperations({required this.grade});

  @override
  _MultiplicationOperationsState createState() =>
      _MultiplicationOperationsState();
}

class _MultiplicationOperationsState extends State<MultiplicationOperations> {
  TextEditingController _filterController = TextEditingController();

  late List<Map<String, dynamic>> filteredOperations;
  // double progress = 0.0;

  @override
  void initState() {
    super.initState();
    filteredOperations = Operations.getMultiplicationOperations(widget.grade).where((op) => op["Grade"] == widget.grade).toList();

  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  // void _filterOperations() {
  //   String keyword = _filterController.text.toLowerCase();
  //   setState(() {
  //     filteredOperations = Operations.getMultiplicationOperations(widget.grade)
  //         .where((op) =>
  //             op["title"].toLowerCase().contains(keyword) &&
  //             op["Grade"] == widget.grade)
  //         .toList();
  //   });
  // }

  // void _markComplete() {
  //   setState(() {
  //     completedCount++;
  //     progress = completedCount / filteredOperations.length;
  //   });
  //   if (completedCount == filteredOperations.length) _showSuccessAnimation();
  // }

  // void _showSuccessAnimation() {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text("Great Job!"),
  //       content:
  //           lottie.Lottie.asset("assets/Lottie/success.json", repeat: false),
  //       actions: [
  //         TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
  //       ],
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: themeProvider.isNightModeOn ? Colors.white.withOpacity(0.5) :Colors.black.withOpacity(0.3),),
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
                "Multiplication",
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

            // Navigate to a new page before popping the current screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OperationsForm(
                  title: title,
                  generateNumbers: numbers,
                ),
              ),
            ).then((_) {
              Navigator.pop(context);
            });
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
