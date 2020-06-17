import 'package:ToDo_App/main.dart';
import 'package:ToDo_App/note.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  void delete(int index) {
    setState(() {
      taskBox.deleteAt(index);
    });
  }

  void update(int index, String newTitle, String newDes) {
    setState(() {
      final updatedTask = Note(newTitle, newDes);
      taskBox.putAt(index, updatedTask);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final taskBox = Hive.box<Note>('tasks');
    var now = DateTime.now();
    String day = DateFormat('EEEE').format(now);
    String date = DateFormat('d').format(now);
    String date2 = DateFormat('MMM\n y').format(now);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "$date",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(),
                  Text(
                    " $date2",
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Text(
                "${day.toUpperCase()}",
                style: TextStyle(
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 5,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: taskBox.length,
            itemBuilder: (BuildContext context, int index) {
              final task = taskBox.getAt(index);
              return ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.arrow_right),
                  backgroundColor: Colors.amber,
                ),
                title: Text(
                  "${task.title}",
                  style: TextStyle(fontSize: 24),
                ),
                subtitle: Text("${task.description}"),
                onTap: () => {
                  dialogBox(context, index),
                },
                trailing: Checkbox(
                  value: false,
                  onChanged: (newValue) {
                    delete(index);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void dialogBox(BuildContext context, int index) {
    TextEditingController title = TextEditingController()
      ..text = '${taskBox.getAt(index).title}';
    TextEditingController des = TextEditingController()
      ..text = '${taskBox.getAt(index).description}';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(),
          child: Container(
            height: 215,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: "Task",
                      icon: Icon(Icons.track_changes),
                    ),
                    controller: title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      labelText: "Description",
                      icon: Icon(
                        Icons.description,
                      ),
                    ),
                    controller: des,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FlatButton(
                    child: Text("Update"),
                    onPressed: () {
                      update(index, title.text, des.text);
                    },
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
