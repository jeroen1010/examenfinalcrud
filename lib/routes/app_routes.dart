import 'package:flutter/material.dart';
import '../screens/screens.dart';
import '../models/models.dart';

class AppRoutes {
  static const String initialRoute = 'login';

  static final List<MenuOption> menuOptions = [
    MenuOption(
        route: 'user',
        name: 'Usuarios',
        screen: UsuariosScreen(),
        icon: Icons.people),
    MenuOption(
        route: 'home',
        name: 'Home',
        screen: const HomeScreen(),
        icon: Icons.home),
    MenuOption(
        route: 'login',
        name: 'Login',
        screen: const LoginScreen(),
        icon: Icons.login),
    MenuOption(
        route: 'progreso',
        name: 'Progreso',
        screen: const PesoGraficoScreen(),
        icon: Icons.show_chart),
    MenuOption(
        route: 'recomendaciones',
        name: 'Recomendaciones',
        screen: const RecipeScreen(),
        icon: Icons.recommend),
    MenuOption(
        route: 'registro',
        name: 'Registro',
        screen: const RegistroScreen(),
        icon: Icons.person_add),
    MenuOption(
        route: 'calendario',
        name: 'Calendario',
        screen: const CalendarioScreen(),
        icon: Icons.calendar_today),
    MenuOption(
        route: 'crud_objetivos',
        name: 'CRUD Objetivos',
        screen: const CrudObjetivosScreen(),
        icon: Icons.flag),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final option in menuOptions) {
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    }

    return appRoutes;
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == 'crud_comidas') {
      final args = settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('usuarioId')) {
        return MaterialPageRoute(
          builder: (context) => CrudComidasScreen(usuarioId: args['usuarioId']),
        );
      } else {
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      }
    }

    return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}
