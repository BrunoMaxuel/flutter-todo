import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

MaterialColor criarMaterialColor(Color cor) {
  final Map<int, Color> swatch = {
    50: cor.withOpacity(0.1),
    100: cor.withOpacity(0.2),
    200: cor.withOpacity(0.3),
    300: cor.withOpacity(0.4),
    400: cor.withOpacity(0.5),
    500: cor.withOpacity(0.6),
    600: cor.withOpacity(0.7),
    700: cor.withOpacity(0.8),
    800: cor.withOpacity(0.9),
    900: cor.withOpacity(1.0),
  };
  return MaterialColor(cor.value, swatch);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const cor = Color.fromRGBO(210, 35, 207, 1);
    final cor_rosa = criarMaterialColor(cor);
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: cor_rosa,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TaskListScreen(),
        '/addTask': (context) => const AddTaskScreen(),
      },
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<String> tasks; // Lista de tarefas inicializada

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = prefs.getStringList('tasks') ??
          []; // Obtemos a lista de tarefas salva
    });
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks); // Salvamos a lista de tarefas
  }

  void addTask(String newTask) {
    setState(() {
      tasks.add(newTask);
      _saveTasks(); // Após adicionar, salvamos a lista atualizada
    });
  }

  void editTask(int index, String editedTask) {
    setState(() {
      tasks[index] = editedTask;
      _saveTasks(); // Após editar, salvamos a lista atualizada
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      _saveTasks(); // Após excluir, salvamos a lista atualizada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final editedTask = await Navigator.pushNamed(
                        context, '/addTask',
                        arguments:
                            TaskScreenArguments(tasks[index], "Editar Tarefa"));
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.pushNamed(context, '/addTask',
              arguments: TaskScreenArguments("", "Adicionar Tarefa"));
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

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController texto = TextEditingController();
    final args =
        ModalRoute.of(context)!.settings.arguments as TaskScreenArguments?;
    texto.text = args?.task ?? '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(args?.title ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: texto,
              decoration: const InputDecoration(
                labelText: 'Nova Tarefa',
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.length >= 4) {
                  Navigator.pop(context, value);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(top: 90.0),
                      padding: EdgeInsets.all(30.0),
                      content: Text('A tarefa deve ter pelo menos 4 caracteres.'),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final task = texto.text;
                if (task.length > 3) {
                  Navigator.pop(context, task);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(top: 90.0),
                      padding: EdgeInsets.all(30.0),
                      content: Text('A tarefa deve ter pelo menos 4 caracteres.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                padding:
                    const EdgeInsets.symmetric(vertical: 19, horizontal: 22),
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
