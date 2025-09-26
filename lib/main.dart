import 'package: flutter/material.dart';

void main() => runApp(Calculator());

class Calculator extends StatelessWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: isDark   
        ? ThemeDark(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.orange,
          textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.orange),
          ),
        )
        : ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.grey[200],
          primaryColor: Colors.black,
          textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.black),
          ),
        )
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(
        isDark: isDark,
        toggleTheme: () {
          setState(() {
            isDark = !isDark;
          });
        },
      ),
    );
  }
}

