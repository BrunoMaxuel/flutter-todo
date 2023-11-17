import 'package:flutter/material.dart';
import 'src/home_screen.dart';
import 'src/add_task_screen.dart';

void main() => runApp(MeuApp());

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const TaskListScreen(),
        '/addTask': (context) => const AddTaskScreen(),
      },
    );
  }
}




// import 'package:flutter/material.dart';

// void main() => runApp(const CheckboxExampleApp());

// class CheckboxExampleApp extends StatelessWidget {
//   const CheckboxExampleApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Checkbox Sample')),
//         body: const Center(
//           child: CheckboxExample(),
//         ),
//       ),
//     );
//   }
// }

// class CheckboxExample extends StatefulWidget {
//   const CheckboxExample({Key? key}) : super(key: key);

//   @override
//   State<CheckboxExample> createState() => _CheckboxExampleState();
// }

// class _CheckboxExampleState extends State<CheckboxExample> {
//   bool isChecked = false;

//   Color getColor(Set<MaterialState> states) {
//     if (states.contains(MaterialState.pressed)) {
//       // Se estiver pressionado, retorna a cor azul para o fundo
//       return Colors.blue;
//     } else if (states.contains(MaterialState.selected)) {
//       // Se estiver selecionado, retorna a cor azul para o fundo
//       return Colors.blue;
//     } else {
//       // Retorna a borda preta e o fundo branco quando não estiver pressionado nem selecionado
//       return Colors.white;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Checkbox(
//       checkColor: Colors.white,
//       fillColor: MaterialStateProperty.resolveWith(getColor),
//       value: isChecked,
//       onChanged: (bool? value) {
//         setState(() {
//           isChecked = value!;
//         });
//       },
//     );
//   }
// }

