 import 'package:flutter/material.dart';
import 'package:to_do_app/DbHelper.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePage();
  }
}

class _MyHomePage extends State<MyHomePage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  String errorMge = "";

  List<Map<String, dynamic>> allNotes = [];
  Dbhelper? dbRef;

  @override
  void initState(){
    super.initState();
    dbRef = Dbhelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {
      
    });
  }

  //-----------time picked--------------//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
        backgroundColor: Colors.amber,
      ),
      body:allNotes.isNotEmpty ? ListView.builder(
        itemCount: allNotes.length,
        itemBuilder: (_, index){
            return ListTile(
              leading:  Text('${allNotes[index][Dbhelper.NOTE_COLUMN_S_NO]}'),
              title: Text('${allNotes[index][Dbhelper.NOTE_COLUMN_TITLE]}'),
              subtitle: Text('${allNotes[index][Dbhelper.NOTE_COLUMN_TIME]}'),
            );
          },
        ) : Center(child: Text("No Data yet"),),
        floatingActionButton: FloatingActionButton(
          onPressed: ),
    );
  }

  Widget getBottomSheetWidget()

}






