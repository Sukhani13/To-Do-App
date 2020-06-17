import 'package:ToDo_App/note.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'screen.dart';

var taskBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter<Note>(NoteAdapter(), 0);
  final directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  taskBox = await Hive.openBox<Note>('tasks');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do App"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          return TaskScreen();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialogBox(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void addTask(Note note) {
    setState(() {
      taskBox.add(note);
    });
  }

  void dialogBox(BuildContext context) {
    TextEditingController title = new TextEditingController();
    TextEditingController des = new TextEditingController();

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
                    child: Text("Add Task"),
                    onPressed: () {
                      final newTask = Note(title.text, des.text);
                      addTask(newTask);
                      Navigator.pop(context);
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
