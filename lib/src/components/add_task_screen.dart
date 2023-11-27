import 'package:flutter/material.dart';
import '../helpers/suprimentos.dart';
import 'home_screen.dart';

class AddTaskScreen extends StatelessWidget {
   AddTaskScreen({Key? key}) : super(key: key);

  validar(value, context) {
    if (value.length >= 4) {
      Navigator.pop(context, value);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(30.0),
          content: Text('A tarefa deve ter pelo menos 4 caracteres.'),
        ),
      );
    }
  }
  
   suprimentos supri =  suprimentos();

  @override
  Widget build(BuildContext context) {
    final TextEditingController inputValue = TextEditingController();
    final args =
        ModalRoute.of(context)!.settings.arguments as TaskScreenArguments?;
    inputValue.text = args?.task ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: supri.rosaEscuro,
        centerTitle: true,
        title: Text(args?.title ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: inputValue,
              decoration: const InputDecoration(
                labelText: 'Nova Tarefa',
                contentPadding: EdgeInsets.all(20.0),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                validar(value, context);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final task = inputValue.text;
                validar(task, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: supri.rosaEscuro,
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
