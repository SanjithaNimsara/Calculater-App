//IM-2021-072 - M.M. Sanjitha Manchanayaka

import 'package:flutter/material.dart';
import 'calculator_screen.dart';

// The entry point of the Flutter application
void main() {
  runApp(const MyApp()); // Calls the main widget of the application
}

// The root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor for the MyApp widget

  // Builds the UI structure for the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator', // Title of the application
      theme: ThemeData.dark(), // Sets the theme to a dark mode
      debugShowCheckedModeBanner: false, // Hides the debug banner in the top-right corner
      home: const CalculatorScreen(), // Sets CalculatorScreen as the home screen
    );
  }
}
