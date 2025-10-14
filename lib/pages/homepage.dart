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

//oopen dialog box to add a note para ini sa yadtung floating action bar
void openNotebox(){
  showDialog(context: context, 
  builder: (context) => AlertDialog(
    content: TextField(
      controller: textController,
    ),
    actions: [
      //button to save
      ElevatedButton(onPressed: () {
        //add a new note
        firestoreService.addNote(textController.text);

        //clear the text controller
        textController.clear();

        //close the box
        Navigator.pop(context);
      }, child: Text("Add"))
    ],
  ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: Center(child: Text("Noting")),),
     floatingActionButton: FloatingActionButton(onPressed: openNotebox,
     child: Icon(Icons.add),),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot){
          // if we have a data get all the docs
          if(snapshot.hasData){
            List noteList = snapshot.data!.docs;
            //display the list
            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index){
                //get each individual doc 
                DocumentSnapshot document = noteList[index];
                String docID = document.id;
                //get note from each doc
                Map<String, dynamic> data=
                  document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                // displa as a list tile 
                return ListTile(
                  title: Text(noteText),
                );
              }
            );
          }
          
          // if there is no data return nothing
          else{
            return const Text("No notes ");
          }
        },
      ),
    );
  }
}