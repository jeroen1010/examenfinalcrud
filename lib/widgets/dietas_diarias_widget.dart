import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_dietas/screens/dieta_dia_screen.dart';

Widget dietasDiarias(Color secondaryColor, Color accentColor, Color textColor,
    BuildContext context) {
  Intl.defaultLocale = 'es_ES';

  DateTime today = DateTime.now();
  DateTime firstDay = DateTime.utc(2022, 1, 1);
  DateTime lastDay = DateTime.utc(2030, 12, 31);

  ScrollController scrollController = ScrollController();

  void scrollToToday() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (scrollController.hasClients) {
        int todayIndex = today.difference(firstDay).inDays;
        double itemWidth = 85 + 12;
        double position = (todayIndex * itemWidth) -
            (MediaQuery.of(context).size.width / 2) +
            (itemWidth / 2);

        scrollController.animateTo(
          position > 0 ? position : 0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }
    });
  }

  WidgetsBinding.instance.addPostFrameCallback((_) => scrollToToday());

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dietas Diarias',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: lastDay.difference(firstDay).inDays + 1,
            itemBuilder: (context, index) {
              DateTime day = firstDay.add(Duration(days: index));

              bool isToday = DateFormat('yyyy-MM-dd').format(day) ==
                  DateFormat('yyyy-MM-dd').format(today);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DietaDiaScreen(
                        selectedDay:
                            day, 
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 85,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isToday ? Colors.orange : accentColor,
                    borderRadius: BorderRadius.circular(16),
                    border: isToday
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: isToday
                            ? Colors.orangeAccent.withOpacity(0.6)
                            : Colors.black.withOpacity(0.1),
                        blurRadius: isToday ? 10 : 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.EEEE().format(day),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isToday ? Colors.white : textColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat.d().format(day),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: isToday ? Colors.white : textColor,
                        ),
                      ),
                      Text(
                        DateFormat.MMMM().format(day),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isToday
                              ? Colors.white.withOpacity(0.9)
                              : textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
