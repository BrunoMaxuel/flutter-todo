import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textEditingController =
        TextEditingController();
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    _textEditingController.text = args ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar/Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Nova Tarefa',
              ),
              onSubmitted: (value) {
                Navigator.pop(context, value);
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _textEditingController.text);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
