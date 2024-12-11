// IM-2021-072 - M.M. Sanjitha Manchanayaka

// Class containing button constants for a calculator application
class Btn {
  // Constants for special operations and symbols
  static const String del = "D"; // Delete the last character or entry
  static const String clr = "AC"; // Clear all inputs and reset the calculator
  static const String per = "%"; // Percentage operation
  static const String multiply = "×"; // Multiplication operator
  static const String divide = "÷"; // Division operator
  static const String add = "+"; // Addition operator
  static const String subtract = "-"; // Subtraction operator
  static const String calculate = "="; // Equals operator for calculating results
  static const String dot = "."; // Decimal point for floating-point numbers
  static const String squareRoot = '√'; // Square root operation

  // Constants for numeric buttons
  static const String n0 = "0"; 
  static const String n1 = "1"; 
  static const String n2 = "2"; 
  static const String n3 = "3"; 
  static const String n4 = "4"; 
  static const String n5 = "5"; 
  static const String n6 = "6"; 
  static const String n7 = "7"; 
  static const String n8 = "8"; 
  static const String n9 = "9";

  // List of all button values in the order they should appear on the calculator
  static const List<String> buttonValues = [
    clr,          // Clear button
    del,          // Delete button
    per,          // Percentage button
    multiply,     // Multiplication button
    n7,           // Numeric button 7
    n8,           // Numeric button 8
    n9,           // Numeric button 9
    divide,       // Division button
    n4,           // Numeric button 4
    n5,           // Numeric button 5
    n6,           // Numeric button 6
    subtract,     // Subtraction button
    n1,           // Numeric button 1
    n2,           // Numeric button 2
    n3,           // Numeric button 3
    add,          // Addition button
    n0,           // Numeric button 0
    dot,          // Decimal point button
    squareRoot,   // Square root button
    calculate,    // Equals button for calculation
  ];
}
