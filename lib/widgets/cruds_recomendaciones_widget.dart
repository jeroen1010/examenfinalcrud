import 'package:flutter/material.dart';
import 'package:app_dietas/theme/app_theme.dart';

class FormularioRecomendacion extends StatelessWidget {
  final TextEditingController tituloController;
  final TextEditingController descripcionController;
  final TextEditingController imagenUrlController;
  final Function agregarRecomendacion;
  final Function modificarRecomendacion;
  final Function borrarRecomendacion;
  final List<Map<String, String>> recomendaciones;

  const FormularioRecomendacion({
    Key? key,
    required this.tituloController,
    required this.descripcionController,
    required this.imagenUrlController,
    required this.agregarRecomendacion,
    required this.modificarRecomendacion,
    required this.borrarRecomendacion,
    required this.recomendaciones,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: tituloController,
          decoration: InputDecoration(
            labelText: 'Título de la Recomendación',
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
            labelText: 'Descripción de la Recomendación',
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: AppTheme.primaryColor),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.secondaryColor),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: imagenUrlController,
          decoration: InputDecoration(
            labelText: 'URL de la Imagen',
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
              onPressed: agregarRecomendacion as void Function()?,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.backgroundLight,
              ),
              child: const Text('Añadir'),
            ),
            ElevatedButton(
              onPressed: () {
                if (tituloController.text.isNotEmpty && descripcionController.text.isNotEmpty && imagenUrlController.text.isNotEmpty) {
                  int selectedIndex = recomendaciones.length - 1;
                  modificarRecomendacion(selectedIndex);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.backgroundLight,
              ),
              child: const Text('Modificar'),
            ),
          ],
        ),
      ],
    );
  }
}