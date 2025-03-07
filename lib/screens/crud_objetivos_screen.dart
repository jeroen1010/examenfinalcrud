import 'package:app_dietas/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_dietas/theme/app_theme.dart';

class CrudObjetivosScreen extends StatefulWidget {
  const CrudObjetivosScreen({Key? key}) : super(key: key);

  @override
  _CrudObjetivosScreenState createState() => _CrudObjetivosScreenState();
}

class _CrudObjetivosScreenState extends State<CrudObjetivosScreen> {
  List<Map<String, String>> objetivos = [];

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController pesoObjetivoController = TextEditingController();

  void agregarObjetivo() {
    setState(() {
      objetivos.add({
        "nombre": nombreController.text,
        "descripcion": descripcionController.text,
        "pesoObjetivo": pesoObjetivoController.text,
      });
    });

    nombreController.clear();
    descripcionController.clear();
    pesoObjetivoController.clear();
  }

  void modificarObjetivo(int index) {
    setState(() {
      objetivos[index] = {
        "nombre": nombreController.text,
        "descripcion": descripcionController.text,
        "pesoObjetivo": pesoObjetivoController.text,
      };
    });
    nombreController.clear();
    descripcionController.clear();
    pesoObjetivoController.clear();
  }

  void borrarObjetivo(int index) {
    setState(() {
      objetivos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Objetivos'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundLight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormularioObjetivo(
              nombreController: nombreController,
              descripcionController: descripcionController,
              pesoObjetivoController: pesoObjetivoController,
              agregarObjetivo: agregarObjetivo,
              modificarObjetivo: modificarObjetivo,
              borrarObjetivo: borrarObjetivo,
              objetivos: objetivos,
            ),
            const SizedBox(height: 20),
            const Text(
              'Lista de Objetivos:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.secondaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: objetivos.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    color: AppTheme.accentColor,
                    child: ListTile(
                      title: Text(
                        objetivos[index]["nombre"] ?? "Sin nombre",
                        style: TextStyle(color: AppTheme.backgroundLight),
                      ),
                      subtitle: Text(
                        "Descripción: ${objetivos[index]["descripcion"] ?? "Sin descripción"}\n"
                        "Peso Objetivo: ${objetivos[index]["pesoObjetivo"] ?? "No especificado"} kg",
                        style: TextStyle(color: AppTheme.backgroundLight),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: AppTheme.primaryColor,
                        onPressed: () => borrarObjetivo(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
