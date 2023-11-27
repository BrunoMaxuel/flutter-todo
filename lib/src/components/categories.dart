import 'package:flutter/material.dart';
import '../helpers/suprimentos.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'add_task_screen.dart';
// import 'home_screen.dart';
suprimentos supri = suprimentos();

class categories extends StatefulWidget {
  const categories({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class Task {
  String title;
  Task({required this.title});
}

class _TaskListScreenState extends State<categories> {
  late List<Task> categoriesList = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      categoriesList =
          (prefs.getStringList('categoriesList') ?? []).map((taskData) {
        List<String> taskValues = taskData.split(',');
        return Task(
          title: taskValues[0],
        );
      }).toList();
    });
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'categoriesList',
        categoriesList.map((task) {
          return task.title;
        }).toList());
  }

  void addTask(String newTask) {
    setState(() {
      categoriesList.add(Task(title: newTask));
      _saveTasks();
    });
  }

  void editTask(int index, String editedTask) {
    setState(() {
      categoriesList[index].title = editedTask;
      _saveTasks();
    });
  }

  void deleteTask(int index) {
    setState(() {
      categoriesList.removeAt(index);
      _saveTasks();
    });
  }

  void deleteFullTask() {
    setState(() {
      categoriesList.clear();
      _saveTasks();
    });
  }

  void dialogDenger(
      BuildContext context, int index, String method, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tarefas'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (method == "Deletar item") {
                  deleteTask(index);
                }
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text(method),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: supri.rosaEscuro,
        centerTitle: true,
        title: const Text('Lista de Categorias'),
      ),
      body: ListView.builder(
        itemCount: categoriesList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              tileColor: supri.rosaClaro,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Text(
                categoriesList[index].title,
                style: const TextStyle(color: Colors.black),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final editedTask = await Navigator.pushNamed(
                        context,
                        '/addTask',
                        arguments: TaskScreenArguments(
                            categoriesList[index].title, "Editar Tarefa"),
                      );
                      if (editedTask != null) {
                        editTask(index, editedTask as String);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      String method = "Deletar item";
                      String text =
                          "Tem certeza que deseja excluir esta tarefa?";
                      dialogDenger(context, index, method, text);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: supri.rosaEscuro,
          onPressed: () async {
            final newTask = await Navigator.pushNamed(
              context,
              '/addTask',
              arguments: TaskScreenArguments("asd", "Adicionar categoria"),
            );
            if (newTask != null) {
              addTask(newTask as String);
            }
          },
          tooltip: 'Adicionar Tarefa',
          child: const Icon(Icons.add),
        ),
    );
  }
}

class TaskScreenArguments {
  final String task;
  final String title;
  TaskScreenArguments(this.task, this.title);
}
