import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_dietas/theme/app_theme.dart';
import 'package:app_dietas/screens/screens.dart';
import 'package:app_dietas/widgets/widgets.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int estadoIndex = 2;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void itemSeleccionado(int index) {
    if (index == estadoIndex) return;

    setState(() {
      estadoIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CalendarioScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PesoGraficoScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RecipeScreen()),
        );
        break;
      case 3:
        Navigator.pop(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platos para preparar'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recetas que te recomendamos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('comidas').where('recomendado', isEqualTo: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No hay recetas disponibles'));
                  }

                  var recetas = snapshot.data!.docs;

                  return PageView(
                    scrollDirection: Axis.horizontal,
                    children: recetas.map((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return _recomendacionesConMateriales(
                        data['nombre'] ?? 'Nombre no disponible',
                        data['imagen'] ?? '',
                        data['descripcion']?.split(', ') ?? [],
                        data['calorias']?.toString() ?? '0',
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: tapBar(
        currentIndex: estadoIndex,
        onTap: itemSeleccionado,
        primaryColor: AppTheme.primaryColor,
        backgroundLight: AppTheme.backgroundLight,
        textColor: AppTheme.backgroundLight,
      ),
    );
  }

  Widget _recomendacionesConMateriales(
      String nombre, String imagenUrl, List<String> materiales, String calorias) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                nombre,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.network(imagenUrl, width: double.infinity, height: 250, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calorías: $calorias kcal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...materiales.map((ingrediente) => Text(
                        '- $ingrediente',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.secondaryColor,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
