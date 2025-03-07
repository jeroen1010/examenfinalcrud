import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_dietas/theme/app_theme.dart';

class PesoGraficoScreen extends StatefulWidget {
  const PesoGraficoScreen({super.key});

  @override
  _PesoGraficoScreenState createState() => _PesoGraficoScreenState();
}

class _PesoGraficoScreenState extends State<PesoGraficoScreen> {
  late Future<List<BarChartGroupData>> _barChartData;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      _barChartData = _getWeeklyCalories(userId!);
    }
  }

  Future<List<BarChartGroupData>> _getWeeklyCalories(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)); 

    Map<int, double> weeklyCalories = {}; // Mapea cada día con su total de calorías

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      Timestamp startOfDay = Timestamp.fromDate(DateTime(day.year, day.month, day.day, 0, 0, 0));
      Timestamp endOfDay = Timestamp.fromDate(DateTime(day.year, day.month, day.day, 23, 59, 59));

      // Obtener comidas asignadas al usuario en `usuarios_comidas`
      QuerySnapshot userMealsSnapshot = await firestore
          .collection('usuarios_comidas')
          .where('usuario_id', isEqualTo: userId)
          .where('fecha', isGreaterThanOrEqualTo: startOfDay)
          .where('fecha', isLessThanOrEqualTo: endOfDay)
          .get();

      double totalCalories = 0;

      for (var userMealDoc in userMealsSnapshot.docs) {
        String comidaId = userMealDoc['comida_id'];

        // Obtener la comida en `comidas`
        DocumentSnapshot comidaDoc = await firestore.collection('comidas').doc(comidaId).get();
        if (comidaDoc.exists && comidaDoc.data() != null) {
          totalCalories += (comidaDoc['calorias'] as num).toDouble();
        }
      }

      weeklyCalories[i] = totalCalories;
    }

    return weeklyCalories.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: AppTheme.accentColor,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    List<String> days = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"];
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        days[value.toInt()],
        style: TextStyle(color: AppTheme.primaryColor, fontSize: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Progreso de Calorías")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calorías totales diarias de sus platos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: userId == null
                  ? const Center(child: Text("Usuario no autenticado"))
                  : FutureBuilder<List<BarChartGroupData>>(
                      future: _barChartData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("No hay datos disponibles"));
                        }

                        return BarChart(
                          BarChartData(
                            gridData: FlGridData(show: true, drawVerticalLine: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 500,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(fontSize: 12),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: _bottomTitles,
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: AppTheme.primaryColor),
                            ),
                            barGroups: snapshot.data!,
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
