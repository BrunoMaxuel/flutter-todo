import 'package:flutter/material.dart';
import '../helpers/suprimentos.dart';
import 'package:shared_preferences/shared_preferences.dart';

suprimentos supri = suprimentos();

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

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> taskList = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      taskList = (prefs.getStringList('taskList') ?? []).map((taskData) {
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
        'taskList',
        taskList.map((task) {
          return '${task.title},${task.isChecked}';
        }).toList());
  }

  void addTask(String newTask) {
    setState(() {
      taskList.add(Task(title: newTask));
      _saveTasks();
    });
  }

  void editTask(int index, String editedTask) {
    setState(() {
      taskList[index].title = editedTask;
      _saveTasks();
    });
  }

  void deleteTask(int index) {
    setState(() {
      taskList.removeAt(index);
      _saveTasks();
    });
  }

  void deleteFullTask() {
    setState(() {
      taskList.clear();
      _saveTasks();
    });
  }

  void updateTaskStatus(int index, bool value) {
    setState(() {
      taskList[index].isChecked = value;
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
                } else if (method == "Deletar tudo") {
                  deleteFullTask();
                } else if (method == "Marcar tudo") {
                  for (var i = 0; i < taskList.length; i++) {
                    updateTaskStatus(i, true);
                  }
                } else if (method == "Desmarcar tudo") {
                  for (var i = 0; i < taskList.length; i++) {
                    updateTaskStatus(i, false);
                  }
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
        title: const Text('Lista de Tarefas'),
      ),
      drawer: Drawer(
        backgroundColor: supri.rosaClaro,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              onTap: () =>
                  {Navigator.popUntil(context, ModalRoute.withName('/'))},
              tileColor: supri.rosaEscuro,
              title: Container(
                height: 80,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 35,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
              width: 10,
            ),
            ListTile(
              tileColor: supri.rosaEscuro,
              title: Container(
                child: const Row(
                  children: [
                    Icon(Icons.home, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Principal", style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
              onTap: () async{
                await Navigator.pushNamed(
                        context,
                        '/',
                        arguments: TaskScreenArguments(
                            "asd", "Categorias Criada"),
                      );
              },
            ),const SizedBox(
              height: 20,
              width: 10,
            ),
            ListTile(
              tileColor: supri.rosaEscuro,
              title: Container(
                child: const Row(
                  children: [
                    Icon(Icons.dashboard, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Mudar tema", style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
              onTap: () {
                
              },
            ),const SizedBox(
              height: 20,
              width: 10,
            ),
            ListTile(
              tileColor: supri.rosaEscuro,
              title: Container(
                child: const Row(
                  children: [
                    Icon(Icons.category, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Minhas categorias", style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
              onTap: () async{
                await Navigator.pushNamed(
                        context,
                        '/categories',
                        arguments: TaskScreenArguments(
                            "asd", "Categorias Criada"),
                      );
              },
            ),const SizedBox(
              height: 20,
              width: 10,
            ),
            ListTile(
              tileColor: supri.rosaEscuro,
              title: Container(
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_box,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      height: 20,
                      width: 10,
                    ),
                    Text(
                      "Marcar todos itens",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              onTap: () {
                int index = -1;
                String method = "Marcar tudo";
                String text = "Deseja realmente marcar TODOS?";
                dialogDenger(context, index, method, text);
              },
            ),
            const SizedBox(
              height: 20,
              width: 10,
            ),
            ListTile(
              tileColor: supri.rosaEscuro,
              title: Container(
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      height: 20,
                      width: 10,
                    ),
                    Text(
                      "Desmarcar todos itens",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              onTap: () {
                int index = -1;
                String method = "Desmarcar tudo";
                String text = "Deseja realmente desmarcar TODOS?";
                dialogDenger(context, index, method, text);
              },
            ),
            const SizedBox(
              height: 20,
              width: 10,
            ),
            ListTile(
              tileColor: supri.rosaEscuro,
              title: Container(
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      height: 20,
                      width: 10,
                    ),
                    Text(
                      "Deletar lista completa",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              onTap: () {
                int index = -1;
                String method = "Deletar tudo";
                String text =
                    "Tem certeza que deseja excluir TODA A LISTA de Tarefas?";
                dialogDenger(context, index, method, text);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              tileColor: supri.rosaClaro,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              leading: Checkbox(
                value: taskList[index].isChecked,
                onChanged: (bool? value) {
                  if (value != null) {
                    updateTaskStatus(index, value);
                  }
                },
              ),
              title: Text(
                taskList[index].title,
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
                            taskList[index].title, "Editar Tarefa"),
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
