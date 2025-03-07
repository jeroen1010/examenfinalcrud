import 'package:app_dietas/screens/screens.dart';
import 'package:app_dietas/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:app_dietas/widgets/widgets.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({Key? key}) : super(key: key);

  @override
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late final DateTime _firstDay;
  late final DateTime _lastDay;

  int estadoIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.utc(2022, 1, 1);
    _lastDay = DateTime.utc(2030, 12, 31);
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

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = AppTheme.primaryColor;
    final Color secondaryColor = AppTheme.secondaryColor;
    final Color accentColor = AppTheme.accentColor;
    final Color backgroundColor = AppTheme.backgroundLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Dietas'),
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              locale: 'es_ES', 
              firstDay: _firstDay,
              lastDay: _lastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DietaDiaScreen(selectedDay: selectedDay),
                  ),
                );
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: accentColor,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: accentColor,
                ),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: secondaryColor,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
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