import 'package:app_dietas/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:app_dietas/services/firebase_services.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List usuarios = [];

  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  void obtenerUsuarios() async {
    List usuariosObtenidos = await getUsuariosNormales();
    setState(() {
      usuarios = usuariosObtenidos;
    });
  }

  void mostrarVentanaAdmin(String usuarioId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sección Administrador'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.fastfood),
                label: const Text("CRUD Comidas"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CrudComidasScreen(usuarioId: usuarioId)),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: usuarios.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return ListTile(
                  title: Text('${usuario['nombre']} ${usuario['apellidos']}'),
                  subtitle: Text(usuario['correo']),
                  trailing: IconButton(
                    icon: const Icon(Icons.admin_panel_settings),
                    onPressed: () => mostrarVentanaAdmin(
                        usuario['uid']), 
                  ),
                );
              },
            ),
    );
  }
}
