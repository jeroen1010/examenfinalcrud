import 'package:app_dietas/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:app_dietas/theme/app_theme.dart';
import 'package:app_dietas/widgets/widgets.dart';
import 'package:app_dietas/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DietaDiaScreen extends StatefulWidget {
  final DateTime selectedDay;

  const DietaDiaScreen({Key? key, required this.selectedDay}) : super(key: key);

  @override
  _DietaDiaScreenState createState() => _DietaDiaScreenState();
}

class _DietaDiaScreenState extends State<DietaDiaScreen> {
  int estadoIndex = 0;
  List<Map<String, dynamic>> comidasDelDia = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarComidasDelDia();
  }

  Future<void> _cargarComidasDelDia() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print("Usuario ID: ${user.uid}");
      print("Fecha seleccionada: ${widget.selectedDay}");

      final comidas =
          await obtenerComidasDeUsuarioPorFecha(user.uid, widget.selectedDay);
      print("Comidas recuperadas: ${comidas.length}");

      setState(() {
        comidasDelDia = comidas;
        isLoading = false;
      });
    }
  }

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

  Map<String, List<Map<String, dynamic>>> _agruparComidasPorCategoria() {
    Map<String, List<Map<String, dynamic>>> comidasAgrupadas = {};

    for (var comida in comidasDelDia) {
      String categoria = comida['categoria'] ?? 'Sin categoría';
      if (!comidasAgrupadas.containsKey(categoria)) {
        comidasAgrupadas[categoria] = [];
      }
      comidasAgrupadas[categoria]!.add(comida);
    }

    return comidasAgrupadas;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = AppTheme.primaryColor;
    final Color secondaryColor = AppTheme.secondaryColor;
    final Color backgroundColor = AppTheme.backgroundLight;

    final comidasAgrupadas = _agruparComidasPorCategoria();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Dieta del ${widget.selectedDay.day}/${widget.selectedDay.month}/${widget.selectedDay.year}'),
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (comidasDelDia.isEmpty)
              Center(
                child: Text(
                  'No hay comidas asignadas para este día.',
                  style: TextStyle(
                    fontSize: 18,
                    color: secondaryColor,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView(
                  children: comidasAgrupadas.entries.map((entry) {
                    String categoria = entry.key;
                    List<Map<String, dynamic>> comidas = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoria,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comidas.length,
                          itemBuilder: (context, index) {
                            final comida = comidas[index];
                            final nombreComida = comida['nombre'] ?? 'Sin nombre';
                            final descripcion =
                                comida['descripcion'] ?? 'Sin descripción';
                            final imageUrl = comida['imagen'] ?? '';
                            final calorias = comida['calorias']?.toString() ?? '0';

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nombreComida,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Calorías: $calorias',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (imageUrl.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    child: Image.network(
                                      imageUrl,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          height: 120,
                                          color: Colors.grey[200],
                                          child: const Center(
                                              child: CircularProgressIndicator()),
                                        );
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Text(
                                  descripcion,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: tapBar(
        currentIndex: estadoIndex,
        onTap: itemSeleccionado,
        primaryColor: primaryColor,
        backgroundLight: backgroundColor,
        textColor: backgroundColor,
      ),
    );
  }
}