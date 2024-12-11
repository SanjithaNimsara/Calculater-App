//IM-2021-072 - M.M. Sanjitha Manchanayaka

import 'package:flutter/material.dart';

// A screen to display the calculation history
class HistoryScreen extends StatelessWidget {
  // List of calculation history passed as a parameter
  final List<String> history;

  // Callback function to clear the history
  final VoidCallback onClearHistory;

  // Constructor to initialize required fields
  const HistoryScreen({
    Key? key,
    required this.history, // History list is required
    required this.onClearHistory, // Callback to clear history is required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar for the history screen
      appBar: AppBar(
        title: const Text('History'), // Title displayed in the app bar
        backgroundColor: Colors.black, // Black background color for the app bar
        actions: [
          // Icon button to clear history
          IconButton(
            icon: const Icon(Icons.delete), // Trash can icon
            onPressed: () {
              onClearHistory(); // Clear history when pressed
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
        ],
      ),

      // Body of the history screen
      body: history.isEmpty
          ? const Center(
              // Display message if history is empty
              child: Text(
                'No history available',
                style: TextStyle(color: Colors.white), // Text color is white for better visibility
              ),
            )
          : ListView.builder(
              // Display the history items in a scrollable list
              itemCount: history.length, // Number of items in the history list
              itemBuilder: (context, index) {
                return ListTile(
                  // Display each history entry
                  title: Text(
                    history[index], // The history item at the given index
                    style: const TextStyle(color: Colors.white), // White text color
                  ),
                );
              },
            ),
    );
  }
}
