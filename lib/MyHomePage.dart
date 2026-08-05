import 'package:flutter/material.dart';
import 'package:to_do_app/DbHelper.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  String errorMge = "";
  int? editingSNo;

  List<Map<String, dynamic>> allNotes = [];
  Dbhelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = Dbhelper.getInstance;
    getNotes();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    timeController.dispose();
    super.dispose();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {});
  }

  //----------- time picker --------------//
  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      timeController.text = picked.format(context);
    }
  }

  void saveNote() async {
    // FIX: Checked titleController instead of timeController
    if (titleController.text.trim().isEmpty) {
      setState(() {
        errorMge = "Title can't be empty";
      });
      return;
    }
    if (timeController.text.trim().isEmpty) {
      setState(() {
        errorMge = "Please pick a time";
      });
      return;
    }

    // FIX: Assigned titleController.text to NOTE_COLUMN_TITLE
    Map<String, dynamic> note = {
      Dbhelper.NOTE_COLUMN_TITLE: titleController.text.trim(),
      Dbhelper.NOTE_COLUMN_DESC: descController.text.trim(),
      Dbhelper.NOTE_COLUMN_TIME: timeController.text.trim(),
    };

    if (editingSNo == null) {
      note[Dbhelper.NOTE_COLUMN_STATUS] = 0;
      await dbRef!.addNote(note);
    } else {
      await dbRef!.updateNote(editingSNo!, note);
    }

    clearFields();
    if (mounted) Navigator.of(context).pop();
    getNotes();
  }

  void deleteNote(int sNo) async {
    await dbRef!.deleteNote(sNo);
    getNotes();
  }

  // FIX: Fixed typo 'Strinf' -> 'String'
  void toggleStatus(Map<String, dynamic> note, bool? value) async {
    Map<String, dynamic> updated = {
      Dbhelper.NOTE_COLUMN_TITLE: note[Dbhelper.NOTE_COLUMN_TITLE],
      Dbhelper.NOTE_COLUMN_DESC: note[Dbhelper.NOTE_COLUMN_DESC],
      Dbhelper.NOTE_COLUMN_TIME: note[Dbhelper.NOTE_COLUMN_TIME],
      Dbhelper.NOTE_COLUMN_STATUS: (value == true) ? 1 : 0,
    };

    await dbRef!.updateNote(note[Dbhelper.NOTE_COLUMN_S_NO], updated);
    getNotes();
  }

  void clearFields() {
    titleController.clear();
    descController.clear();
    timeController.clear();
    errorMge = "";
    editingSNo = null;
  }

  void openBottomSheetForNew() {
    clearFields();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => getBottomSheetWidget(),
    ).whenComplete(() {
      setState(() {});
    });
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => getBottomSheetWidget(),
    );
  }

  // FIX: Removed duplicate build() method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
        backgroundColor: Colors.amber,
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                final note = allNotes[index];
                final bool isDone =
                    (note[Dbhelper.NOTE_COLUMN_STATUS] ?? 0) == 1;

                return Dismissible(
                  key: Key(note[Dbhelper.NOTE_COLUMN_S_NO].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    deleteNote(note[Dbhelper.NOTE_COLUMN_S_NO]);
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: isDone,
                      onChanged: (value) => toggleStatus(note, value),
                    ),
                    title: Text(
                      '${note[Dbhelper.NOTE_COLUMN_TITLE]}',
                      style: TextStyle(
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text('${note[Dbhelper.NOTE_COLUMN_TIME]}'),
                    onTap: () => openBottomSheetForEdit(note),
                  ),
                );
              },
            )
          : const Center(child: Text("No Data yet")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: openBottomSheetForNew,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetWidget() {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              editingSNo == null ? "Add Task" : "Edit Task",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Description (optional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              readOnly: true,
              onTap: pickTime,
              decoration: const InputDecoration(
                labelText: "Time",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
            ),
            if (errorMge.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(errorMge, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: saveNote,
              child: Text(editingSNo == null ? "Save" : "Update"),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}