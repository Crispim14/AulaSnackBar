import 'package:flutter/material.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({Key? key}) : super(key: key);

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  final TextEditingController _nomeController = TextEditingController();
  final List<TextEditingController> _notasControllers =
      List.generate(4, (_) => TextEditingController());

  void _calcularMedia() {
    double somaNotas = 0;
    bool camposPreenchidos = _nomeController.text.isNotEmpty;

    for (var controller in _notasControllers) {
      String notaTexto = controller.text.replaceAll(',', '.');
      double? nota = double.tryParse(notaTexto);
      if (nota != null) {
        somaNotas += nota;
      } else {
        camposPreenchidos = false;
        break;
      }
    }

    if (!camposPreenchidos) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Preencha todos os campos!'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ));
      return;
    }

    double media = somaNotas / _notasControllers.length;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(media >= 6.0 ? 'Aprovado' : 'Reprovado'),
      action: SnackBarAction(
        label: 'Limpar',
        onPressed: () {
          _nomeController.clear();
          for (var controller in _notasControllers) {
            controller.clear();
          }
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Média'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do aluno'),
            ),
            ..._notasControllers.asMap().entries.map((entry) {
              return TextField(
                controller: entry.value,
                decoration: InputDecoration(labelText: 'Nota ${entry.key + 1}'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              );
            }).toList(),
            ElevatedButton(
              onPressed: _calcularMedia,
              child: const Text('Calcular Média'),
            ),
          ],
        ),
      ),
    );
  }
}
