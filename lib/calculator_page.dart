import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _display = '';
  String _result = '';
  bool _justCalculated = false;

  final List<String> _buttons = [
    '7', '8', '9', '/',
    '4', '5', '6', '*',
    '1', '2', '3', '-',
    'C', '0', '=', '+',
  ];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
        _display = '';
        _justCalculated = false;
      } else if (value == '=') {
        if (_expression.isEmpty) return;
        try {
          final exp = Expression.parse(_expression.replaceAll('x', '*').replaceAll('÷', '/'));
          final evaluator = const ExpressionEvaluator();
          final evalResult = evaluator.eval(exp, {});
          _result = evalResult.toString();
          _display = '$_expression = $_result';
          _justCalculated = true;
        } catch (e) {
            if (_expression.contains('/0')) {
            _result = 'Undefined';
            } else {
            _result = 'Error';
            }
          _display = '$_expression = $_result';
          _justCalculated = true;
        }
      } else {
        if (_justCalculated) {
          // Start new expression after calculation
          if ('+-*/'.contains(value)) {
            _expression = _result + value;
          } else {
            _expression = value;
          }
          _justCalculated = false;
        } else {
          _expression += value;
        }
        _display = _expression;
      }
    });
  }

  Widget _buildButton(String value) {
    Color bgColor;
    Color textColor = Colors.white;
    if (value == 'C') {
      bgColor = Colors.redAccent;
    } else if (value == '=') {
      bgColor = Colors.green;
    } else if ('+-*/'.contains(value)) {
      bgColor = Colors.blueAccent;
    } else {
      bgColor = Colors.grey[800]!;
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          minimumSize: const Size(30, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _onButtonPressed(value),
        child: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'GitHub Copilot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _display,
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontFamily: 'RobotoMono',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_result.isNotEmpty && _result != 'Error')
                    Text(
                      '$_result',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                  if (_result == 'Error')
                    const Text(
                      'Error',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                height: 300, // adjust as needed
                width: 300,  // adjust as needed
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // prevent scrolling
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: _buttons.length,
                  itemBuilder: (context, index) {
                    return _buildButton(_buttons[index]);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}