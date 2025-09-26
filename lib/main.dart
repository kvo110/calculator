import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(Calculator());

// main app widget
class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

// light/dark mode widget
class _CalculatorState extends State<Calculator> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: isDark   
        // Dark mode 
        ? ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            primaryColor: Colors.orange,
            textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.orange)),
          )
        // Light mode
        : ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.grey[200],
            primaryColor: Colors.black,
            textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black)),
          ), 
      
      // Home screen of calculator app
      home: CalculatorScreen(
        isDark: isDark,
        toggleTheme: () {
          // Change theme when button is pressed
          setState(() {
            isDark = !isDark;
          });
        },
      ),
    );
  }
}

// Calculator widget
class CalculatorScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback toggleTheme; // Switches theme

  CalculatorScreen({required this.isDark, required this.toggleTheme});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = ''; // Stores the user's input
  String result = ''; // Stores the calculation results
  
  // Handles which buttons are pressed 
  void _buttonPressed(String value) {
    setState(() {
      // Clears input and results if 'C' is pressed
      if (value == 'C') {
        input = '';
        result = '';
      // Calculate the result of the equation
      } else if (value == '=') {
        _calculateResult();
      } else {
        // Adds the pressed button's value to the input string
        input += value;
      }
    });
  }

  // Operations based on the operator used in the equation
  void _calculateResult() {
    try {
      Parser p = Parser();
      // Replace displayed symbols with math symbols for calculation
      Expression exp = p.parse(
        input.replaceAll('×', '*').replaceAll('÷', '/'),
      );
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      result = eval.toStringAsFixed(3); // Rounds the result to 3 decimal places
    } catch (e) {
      // Handles any invalid inputs
      result = 'Invalid Input(s)';
    }
  }

  // Build calculator buttons
  Widget _buildButton(String text) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1, // Makes the shape of the button a square
        child: InkWell(
          onTap: () => _buttonPressed(text), // Handles the buttons being pressed
          child: Container(
            margin: EdgeInsets.all(4), // Reduced margin to prevent overflow
            decoration: BoxDecoration(
              color: widget.isDark ? Colors.grey[900] : Colors.grey[200],
              borderRadius: BorderRadius.circular(15), // Creates the rounded corners of the button
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.isDark ? Colors.orange : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.orange : Colors.black;

    return Scaffold(
      // App bar w/ theme toggle
      appBar: AppBar(
        title: Text('Calculator', style: TextStyle(color: textColor)),
        backgroundColor: widget.isDark ? Colors.black : Colors.grey[200],
        actions: [
          IconButton(
            icon: Icon(
              widget.isDark ? Icons.wb_sunny : Icons.nights_stay,
              color: textColor,
            ),
            onPressed: widget.toggleTheme, // Switch between themes
          ),
        ],
      ),

      body: Column(
        children: [
          // Displays the area for input and result
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input, style: TextStyle(fontSize: 28, color: textColor)),
                  SizedBox(height: 10),
                  Text(
                    result,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.08), // Adjusts the placement of the buttons so they do not overflow off the edge of the screen

          // Arrange the calculator buttons in rows and columns
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Added horizontal padding to prevent buttons going off the screen
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('÷'), // Display division symbol
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('×'), // Display multiplication symbol
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('-'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _buildButton('C'),
                      _buildButton('0'),
                      _buildButton('='),
                      _buildButton('+'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}