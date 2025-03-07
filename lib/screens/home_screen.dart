import 'package:app_dietas/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:app_dietas/theme/app_theme.dart'; // No modifiques AppTheme
import 'package:app_dietas/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int estadoIndex = 0;
  bool isDarkMode = false; // Variable para controlar el modo oscuro

  void itemSeleccionado(int index) {
    setState(() {
      estadoIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalendarioScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PesoGraficoScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RecipeScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = AppTheme.primaryColor;
    final Color secondaryColor = AppTheme.secondaryColor;

    final Color accentColor =
        isDarkMode ? Colors.grey[700]! : AppTheme.accentColor;
    final Color backgroundColor =
        isDarkMode ? Colors.black : AppTheme.backgroundLight;

    return MaterialApp(
      theme: isDarkMode
          ? ThemeData.dark().copyWith(
              primaryColor: primaryColor,
              colorScheme: ColorScheme.dark(
                primary: primaryColor,
                secondary: accentColor,
                background: secondaryColor,
              ),
            )
          : ThemeData.light().copyWith(
              primaryColor: primaryColor,
              colorScheme: ColorScheme.light(
                primary: primaryColor,
                secondary: accentColor,
                background: backgroundColor,
              ),
            ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nutri O´'),
          centerTitle: true,
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: PopupMenuButton<int>(
                icon: ClipOval(
                  child: Image.network(
                    'https://wallpapers.com/images/featured/hasbulla-zlghwkpfa1k6njh0.jpg',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                        const SizedBox(width: 10),
                        Text(isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        isDarkMode = !isDarkMode;
                      });
                    },
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text('Cerrar sesión'),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginScreen()), 
                      );
                    },
                  ),
                ],
                onSelected: (int value) {
                  switch (value) {
                    case 0:
                      break;
                    case 1:
                      break;
                  }
                },
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dietasDiarias(
                  secondaryColor, accentColor, backgroundColor, context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gráfico Progreso",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PesoGraficoScreen()),
                          );
                        },
                        child: const Text(
                          'Ver Gráficos',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              seccionRecomendaciones(secondaryColor, backgroundColor),
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
      ),
    );
  }
}
