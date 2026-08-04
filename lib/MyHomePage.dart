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

  int? editingSNo;

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
  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now());


      if(picked != null){
        timeController.text = picked.format(context);
      }
  }

  void saveNote() async {
    if(timeController.text.trim().isEmpty){
      setState(() {
        errorMge = "Title can't be empty";
      });
      return;
    }
    if(timeController.text.trim().isEmpty){
      setState(() {
        errorMge = "Please pick a time"; 
      });
      return;
    }

    Map<String, dynamic> note = {
      Dbhelper.NOTE_COLUMN_TITLE : timeController.text.trim(),
      Dbhelper.NOTE_COLUMN_DESC : descController.text.trim(),
      Dbhelper.NOTE_COLUMN_TIME : timeController.text.trim()
    };

    if(editingSNo == null)  {
      note[Dbhelper.NOTE_COLUMN_STATUS] = 0;
      await dbRef!.addNote(note);
    } else{
      await dbRef!.updateNote(editingSNo!, note);
    }

    clearFields();
    Navigator.of(context).pop();
    getNotes();
  }

  void deleteNote(int sNo)async{
    await dbRef!.deleteNote(sNo);
    getNotes();
  }

  void toggleeStatus(Map<Strinf, dynamic>note, bool? value) async {
    Map<String, dynamic> updated = {
      Dbhelper.NOTE_COLUMN_TITLE : note[Dbhelper.NOTE_COLUMN_TITLE],
      Dbhelper.NOTE_COLUMN_DESC : note[Dbhelper.NOTE_COLUMN_DESC],
      Dbhelper.NOTE_COLUMN_TIME : note[Dbhelper.NOTE_COLUMN_TIME],
      Dbhelper.NOTE_COLUMN_STATUS : (value == true) ? 1 : 0,

    };

    await dbRef!.updateNote(note[Dbhelper.NOTE_COLUMN_S_NO], updated);
    getNotes();
  }

  void clearFields(){
    timeController.clear();
    descController.clear();
    timeController.clear();
    errorMge = "";
    editingSNo = null;
  }

void openBottomSheetForNew(){
  clearFields();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top : Radius.circular(16)),
    ),
    builder: (_) => getBottomSheetWidget(),
    ).whenComplete((){
      setState(() {
        
      });
    });
}

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

  void openBottomSheetForEdit(Map<String, dynamic> note) {
    editingSNo = note[Dbhelper.NOTE_COLUMN_S_NO];
    titleController.text = note[Dbhelper.NOTE_COLUMN_TITLE] ?? "";
    descController.text = note[Dbhelper.NOTE_COLUMN_DESC] ?? "";
    timeController.text = note[Dbhelper.NOTE_COLUMN_TIME] ?? "";
    errorMge = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => getBottomSheetWidget(),
    );
  }

  Widget getBottomSheetWidget()

}






