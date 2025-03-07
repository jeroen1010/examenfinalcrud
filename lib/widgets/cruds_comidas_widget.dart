import 'package:flutter/material.dart';
import 'package:app_dietas/theme/app_theme.dart';

class FormularioComida extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController descripcionController;
  final TextEditingController urlImagenController;
  final TextEditingController caloriasController; 
  final Function agregarComida;
  final Function modificarComida;
  final Function borrarComida;
  final List<Map<String, dynamic>> comidas;
  final int selectedIndex;

  const FormularioComida({
    Key? key,
    required this.nombreController,
    required this.descripcionController,
    required this.urlImagenController,
    required this.caloriasController, 
    required this.agregarComida,
    required this.modificarComida,
    required this.borrarComida,
    required this.comidas,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nombreController,
            decoration: InputDecoration(
              labelText: 'Nombre',
              border: const OutlineInputBorder(),
              labelStyle: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descripcionController,
            decoration: InputDecoration(
              labelText: 'Descripción',
              border: const OutlineInputBorder(),
              labelStyle: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: urlImagenController,
            decoration: InputDecoration(
              labelText: 'URL Imagen',
              border: const OutlineInputBorder(),
              labelStyle: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: caloriasController,
            decoration: InputDecoration(
              labelText: 'Calorías',
              border: const OutlineInputBorder(),
              labelStyle: TextStyle(color: AppTheme.primaryColor),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: agregarComida as void Function()?,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.backgroundLight,
                ),
                child: const Text('Añadir'),
              ),
              ElevatedButton(
                onPressed: selectedIndex != -1 ? modificarComida as void Function()? : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.backgroundLight,
                ),
                child: const Text('Modificar'),
              ),
              ElevatedButton(
                onPressed: borrarComida as void Function()?,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: AppTheme.backgroundLight,
                ),
                child: const Text('Limpiar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}