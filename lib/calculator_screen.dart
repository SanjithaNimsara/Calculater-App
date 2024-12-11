// IM-2021-072 - M.M. Sanjitha Manchanayaka

// Import required packages
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'button_values.dart';
import 'history_screen.dart';

// Main Calculator Screen Widget
class CalculatorScreen extends StatefulWidget { 
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Variables for calculator functionality
  String _displayValue = ''; // Stores the value displayed to the user
  String _expression = ''; // Stores the input expression
  String _result = ''; // Stores the result of the calculation
  bool _showResultOnly = false; // Flag to toggle result-only display mode
  List<String> _history = []; // List to store the history of calculations

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive button sizing
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        backgroundColor: Colors.black, // Black app bar to match theme
        actions: [
          IconButton(
            icon: const Icon(Icons.history), // History icon button
            onPressed: () {
              // Navigate to HistoryScreen when history button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(
                    history: _history,
                    onClearHistory: _clearHistory,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display area for input expression and result
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight, // Align text to bottom-right
                padding: const EdgeInsets.all(24), // Add padding around display
                color: Colors.black, // Match background color
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // Place text at bottom
                  crossAxisAlignment: CrossAxisAlignment.end, // Align text to right
                  children: [
                    // Display input expression unless in result-only mode
                    if (!_showResultOnly)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // Horizontal scrolling for long expressions
                        reverse: true, // Keep focus at the end of the expression
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _expression.isEmpty ? " " : _expression,
                              style: const TextStyle(fontSize: 36, color: Colors.white),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8), // Add spacing between expression and result
                    // Display result or input value
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _displayValue.isNotEmpty ? _displayValue : _result,
                            style: TextStyle(
                              fontSize: _showResultOnly ? 64 : 48, // Adjust size based on mode
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button layout using a Wrap widget
            Wrap(
              children: Btn.buttonValues.map(
                (value) => SizedBox(
                  width: screenSize.width / 4, // 4 buttons per row
                  height: screenSize.width / 4.5, // Responsive button height
                  child: buildButton(value), // Build each button
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a button widget with the specified value
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(3.0), // Add spacing around the button
      child: Material(
        color: getBtnColor(value), // Set button color based on type
        clipBehavior: Clip.hardEdge, // Clip edges of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Create round buttons
        ),
        child: InkWell(
          onTap: () => _onButtonPressed(value), // Handle button press event
          child: Center(
            child: Text(
              value, // Display button value
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26, // Font size for button text
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Handles button press events
  void _onButtonPressed(String value) {
    setState(() {
      if (_showResultOnly) {
        // Handle result-only mode actions
        if (value == Btn.clr) {
          _onClear(); // Clear everything if "clear" is pressed
          return;
        }
        if (value == Btn.del) {
          _onClearEntry(); // Clear last entry if "delete" is pressed
          return;
        }
        if (isOperator(value)) {
          _expression = _result + value; // Start new expression with result
          _showResultOnly = false;
        } else if (value == Btn.squareRoot) {
          _expression = 'sqrt($_result'; // Start square root of result
          _showResultOnly = false;
        } else {
          _expression = value; // Start new expression with button value
          _showResultOnly = false;
        }
        _result = ''; // Reset result
        return;
      }

      // Handle regular button actions
      if (value == Btn.clr) {
        _onClear(); // Clear everything
      } else if (value == Btn.del) {
        _onClearEntry(); // Clear last entry
      } else if (value == Btn.calculate) {
        _onEnter(); // Perform calculation
      } else if (value == Btn.squareRoot) {
        _expression += 'sqrt('; // Add square root function
      } else {
        // Prevent invalid input such as misplaced or consecutive operators
        if (value == '.' &&
            (_expression.isEmpty || _expression.endsWith('.') || isOperator(_expression[_expression.length - 1]))) {
          return; // Ignore invalid decimal placement
        }
        if (value == '.' && _expression.split(RegExp(r'[^0-9.]')).last.contains('.')) {
          return; // Ignore multiple decimals in a single number
        }
        if (_expression.isNotEmpty && isOperator(value) && isOperator(_expression[_expression.length - 1])) {
          _expression = _expression.substring(0, _expression.length - 1) + value; // Replace last operator
        } else {
          _expression += value; // Append button value to expression
        }
      }
    });
  }

  // Checks if the given value is an operator
  bool isOperator(String value) {
    return value == Btn.add ||
        value == Btn.subtract ||
        value == Btn.multiply ||
        value == Btn.divide ||
        value == Btn.per;
  }

  // Evaluates the current expression and calculates the result
  void _onEnter() {
    try {
      if (_expression.isEmpty || _expression.trim().split('').every((char) => isOperator(char))) {
        throw Exception('Error'); // Throw error for invalid expressions
      }

      // Balance any unclosed parentheses
      int openParens = 'sqrt('.allMatches(_expression).length;
      int closeParens = ')'.allMatches(_expression).length;
      _expression += ')' * (openParens - closeParens);

      // Replace custom operators with valid math symbols
      String parsedExpression = _expression
          .replaceAll(Btn.multiply, '*')
          .replaceAll(Btn.divide, '/')
          .replaceAll(Btn.per, '/100');

      // Check for invalid square root inputs
      if (RegExp(r'sqrt\((\s*-.*?\s*)\)').hasMatch(parsedExpression)) {
        throw Exception('Error: Negative square root');
      }

      // Check for division by zero
      if (RegExp(r'/\s*0(\s|$|\))').hasMatch(parsedExpression)) {
        throw Exception('Error: Division by zero');
      }

      // Evaluate the parsed expression
      Parser parser = Parser();
      Expression exp = parser.parse(parsedExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Format the result for display
      String formattedResult = eval.toStringAsFixed(6);
      if (formattedResult.contains('.')) {
        formattedResult = formattedResult.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      }
      if (formattedResult.length > 10) {
        formattedResult = eval.toStringAsExponential(6);
      }

      // Update state with the result
      setState(() {
        _history.add("$_expression = $formattedResult"); // Save both expression and result
        _result = formattedResult;  // Show result in the display value
        _displayValue = _result;    // Display the result
        _expression = '';           // Clear the expression
        _showResultOnly = true;

      });
    } catch (e) {
      print("Error caught: $e");
      // Handle errors
      setState(() {
        _displayValue = 'Error'; // Display "Error"
        _result = '';            // Clear any previous result
        _expression = '';        // Clear the expression
        _showResultOnly = true;  // Ensure result mode is activated
      });
    }
  }


  // Clears all input and result
  void _onClear() {
    setState(() {
      _displayValue = '';
      _expression = '';
      _result = '';
      _showResultOnly = false;
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  // Deletes the last character of the current expression
  void _onClearEntry() {
    setState(() {
      if (_expression.length > 1) {
        _expression = _expression.substring(0, _expression.length - 1);
      } else {
        _onClear();// Clear everything if only one character remains
      }
    });
  }

// Determines button color based on type
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [Btn.per, Btn.multiply, Btn.subtract, Btn.divide, Btn.calculate, Btn.add, Btn.squareRoot].contains(value)
        ?  const Color.fromARGB(255, 70, 34, 169)
        : const Color.fromARGB(255, 213, 212, 220);
  }
}