import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final TextEditingController textController = TextEditingController();

//oopen dialog box to add a note para ini sa yadtung floating action bar
void openNotebox(){
  showDialog(context: context, 
  builder: (context) => AlertDialog(
    content: TextField(
      controller: textController,
    ),
    actions: [
      ElevatedButton(onPressed: () {}, child: Text("Add"))
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
    );
  }
}