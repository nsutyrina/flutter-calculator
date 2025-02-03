import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.pink[200],
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.pink[200]),
          bodyText2: TextStyle(color: Colors.pink[200]),
        ),
      ),
      home: const CalculatorHomePage(title: 'Nadia Sutyrina'),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key, required this.title});

  final String title;

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _display = '';
  String _accumulator = '';
  String _lastOperation = '';

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _display = '';
        _accumulator = '';
        _lastOperation = '';
      } else if (value == '=') {
        try {
          final expression = Expression.parse(_accumulator);
          final evaluator = const ExpressionEvaluator();
          final result = evaluator.eval(expression, {});
          _lastOperation = _accumulator;
          _display = result.toString();
          _accumulator = result.toString();
        } catch (e) {
          _display = 'Error';
          _accumulator = '';
          _lastOperation = '';
        }
      } else {
        if (_display == _accumulator) {
          _display = '';
        }
        _accumulator += value;
        _display = _accumulator;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.pink[300],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.pink[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                _lastOperation,
                style: TextStyle(color: Colors.pink[300], fontSize: 18),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                _display,
                style: TextStyle(color: Colors.pink[200], fontSize: 32),
              ),
            ),
            Expanded(
              child: Divider(),
            ),
            Column(
              children: [
                _buildButtonRow(['7', '8', '9', '/']),
                _buildButtonRow(['4', '5', '6', '*']),
                _buildButtonRow(['1', '2', '3', '-']),
                _buildButtonRow(['C', '0', '=', '+']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) {
        Color buttonColor = Colors.pink[200]!;
        if (button == 'C' || button == '=' || button == '+' || button == '-' || button == '*' || button == '/') {
          buttonColor = Colors.pink[800]!;
        }
        return ElevatedButton(
          onPressed: () => _buttonPressed(button),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.all(20),
            shape: const CircleBorder(),
            shadowColor: Colors.black,
            elevation: 5,
          ),
          child: Text(
            button,
            style: TextStyle(color: Colors.grey[900], fontSize: 24),
          ),
        );
      }).toList(),
    );
  }
}