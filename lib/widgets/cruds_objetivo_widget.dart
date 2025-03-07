import 'package:flutter/material.dart';
import 'package:app_dietas/theme/app_theme.dart';

class FormularioObjetivo extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController descripcionController;
  final TextEditingController pesoObjetivoController;
  final Function agregarObjetivo;
  final Function modificarObjetivo;
  final Function borrarObjetivo;
  final List<Map<String, String>> objetivos;

  const FormularioObjetivo({
    Key? key,
    required this.nombreController,
    required this.descripcionController,
    required this.pesoObjetivoController,
    required this.agregarObjetivo,
    required this.modificarObjetivo,
    required this.borrarObjetivo,
    required this.objetivos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nombreController,
          decoration: InputDecoration(
            labelText: 'Nombre del Objetivo',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: AppTheme.primaryColor),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.secondaryColor),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: descripcionController,
          decoration: InputDecoration(
            labelText: 'Descripción del Objetivo',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: AppTheme.primaryColor),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.secondaryColor),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: pesoObjetivoController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Peso Objetivo (kg)',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: AppTheme.primaryColor),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.secondaryColor),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: agregarObjetivo as void Function()?,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.backgroundLight,
              ),
              child: const Text('Añadir Objetivo'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nombreController.text.isNotEmpty && descripcionController.text.isNotEmpty) {
                  int selectedIndex = objetivos.length - 1;
                  modificarObjetivo(selectedIndex);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.backgroundLight,
              ),
              child: const Text('Modificar Objetivo'),
            ),
          ],
        ),
      ],
    );
  }
}
