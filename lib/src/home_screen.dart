import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class Task {
  String title;
  bool isChecked;
  Task({required this.title, this.isChecked = false});
}

Color corRosa = const Color.fromRGBO(210, 35, 207, 1);
Color corAzul = Color.fromARGB(255, 38, 108, 178);


class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = (prefs.getStringList('tasks') ?? []).map((taskData) {
        List<String> taskValues = taskData.split(',');
        return Task(
          title: taskValues[0],
          isChecked: taskValues[1] == 'true',
        );
      }).toList();
    });
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'tasks',
        tasks.map((task) {
          return '${task.title},${task.isChecked}';
        }).toList());
  }

  void addTask(String newTask) {
    setState(() {
      tasks.add(Task(title: newTask));
      _saveTasks();
    });
  }

  void editTask(int index, String editedTask) {
    setState(() {
      tasks[index].title = editedTask;
      _saveTasks();
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      _saveTasks();
    });
  }

  void updateTaskStatus(int index, bool value) {
    setState(() {
      tasks[index].isChecked = value;
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corRosa,
        centerTitle: true,
        title: const Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          // List<Color> cores = [Color.fromARGB(255, 163, 163, 163), Color.fromARGB(255, 120, 120, 120)];
          //  Color corAtual = cores[index % cores.length];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: ListTile(
              tileColor: Color.fromRGBO(255, 213, 255, 1),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: Checkbox(
                value: tasks[index].isChecked,
                onChanged: (bool? value) {
                  if (value != null) {
                    updateTaskStatus(index, value);
                  }
                },
              ),
              title: Text(
                tasks[index].title,
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
                            tasks[index].title, "Editar Tarefa"),
                      );
                      if (editedTask != null) {
                        editTask(index, editedTask as String);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmar exclusão'),
                            content: const Text(
                                'Tem certeza de que deseja excluir esta tarefa?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteTask(index);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Excluir'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: corRosa,
        onPressed: () async {
          final newTask = await Navigator.pushNamed(
            context,
            '/addTask',
            arguments: TaskScreenArguments("", "Adicionar Tarefa"),
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
