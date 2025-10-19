import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_exam/services/firestore.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  // Open dialog box to add or update a note (for the floating action bar)
  void openNotebox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          docID == null ? "Add a New Note" : "Update Note",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800]),
        ),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: "Enter your note here...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[600]!),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          // Cancel button
          OutlinedButton(
            onPressed: () {
              textController.clear();
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.green[600]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Cancel", style: TextStyle(color: Colors.green[600])),
          ),
          // Save button
          ElevatedButton(
            onPressed: () {
              // Add a new note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              }
              // Update an existing note
              else {
                firestoreService.updateNote(docID, textController.text);
              }

              // Clear the text controller
              textController.clear();

              // Close the box
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.green[700], // Primary green for consistency
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green[700],
          secondary: Colors.green[400], // Accent green
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[700],
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green[600],
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.assignment, color: Colors.white), //assignment Icon
              SizedBox(width: 8),
              Text("Flutter CRUD"), // Updated title to tie into capstone
            ],
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: openNotebox,
          tooltip: "Add a new note",
          child: Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            // If we have data, get all the docs
            if (snapshot.hasData) {
              List noteList = snapshot.data!.docs;
              // Display the list
              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: noteList.length,
                itemBuilder: (context, index) {
                  // Get each individual doc
                  DocumentSnapshot document = noteList[index];
                  String docID = document.id;
                  // Get note from each doc
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String noteText = data['note'];

                  // Display as a styled card with list tile
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.note, color: Colors.green[600]), // Note icon
                      title: Text(
                        noteText,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Update button
                          IconButton(
                            onPressed: () => openNotebox(docID: docID),
                            icon: Icon(Icons.edit, color: Colors.green[600]),
                            tooltip: "Edit note",
                          ),
                          // Delete button
                          IconButton(
                            onPressed: () => firestoreService.deleteNote(docID),
                            icon: Icon(Icons.delete, color: Colors.red[400]),
                            tooltip: "Delete note",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            // If there is no data, return a styled empty state
            else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.grass, size: 64, color: Colors.green[300]), // Themed icon
                    SizedBox(height: 16),
                    Text(
                      "No notes yet!\nTap the + button to add your first herbal note.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}