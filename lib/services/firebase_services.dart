import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
Future<List> getUsuariosNormales() async {
  List usuarios = [];
  CollectionReference collectionReferenceUsuarios = db.collection('usuarios');

  QuerySnapshot queryUsuarios = await collectionReferenceUsuarios
      .where('administrador', isEqualTo: false)
      .get();

  for (var documento in queryUsuarios.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final usuario = {
      "uid": documento.id,
      "nombre": data['nombre'],
      "apellidos": data['apellidos'],
      "correo": data['correo']
    };

    usuarios.add(usuario);
  }

  return usuarios;
}

Future<void> asignarComidaAUsuario(
    String usuarioId, String comidaId, DateTime fecha) async {
  try {
    await db.collection('usuarios_comidas').add({
      'usuario_id': usuarioId,
      'comida_id': comidaId,
      'fecha': Timestamp.fromDate(fecha),
    });
  } catch (e) {
    print("Error al asignar comida: $e");
  }
}

Future<List<Map<String, dynamic>>> obtenerComidasDeUsuarioPorFecha(
    String usuarioId, DateTime fecha) async {
  List<Map<String, dynamic>> comidas = [];

  try {
    DateTime fechaInicio = DateTime.utc(fecha.year, fecha.month, fecha.day);
    DateTime fechaFin = DateTime.utc(fecha.year, fecha.month, fecha.day + 1);

    QuerySnapshot snapshot = await db
        .collection('usuarios_comidas')
        .where('usuario_id', isEqualTo: usuarioId)
        .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(fechaInicio))
        .where('fecha', isLessThan: Timestamp.fromDate(fechaFin))
        .get();

    for (var doc in snapshot.docs) {
      var comidaSnapshot = await db.collection('comidas').doc(doc['comida_id']).get();
      if (comidaSnapshot.exists) {
        var data = comidaSnapshot.data();
        comidas.add({
          "id": comidaSnapshot.id,
          "nombre": data?['nombre'] ?? "Desconocido",
          "descripcion": data?['descripcion'] ?? "Sin descripción",
          "imagen": data?['imagen'] ?? "",
          "categoria": data?['categoria'] ?? "Otra",
          "calorias": data?['calorias'] ?? 0, 
        });
      }
    }
  } catch (e) {
    print("Error al obtener comidas: $e");
  }

  return comidas;
}

Future<String> agregarComidaFirebase(Map<String, dynamic> comidaData) async {
  DocumentReference docRef = await db.collection('comidas').add(comidaData);
  return docRef.id;
}

Future<void> actualizarComida(
    String comidaId, Map<String, dynamic> comidaData) async {
  try {
    await db.collection('comidas').doc(comidaId).update(comidaData);
  } catch (e) {
    print("Error al actualizar comida: $e");
  }
}

Future<void> eliminarComidaDeUsuario(
    String usuarioId, String comidaId, DateTime fecha) async {
  try {
    QuerySnapshot snapshot = await db
        .collection('usuarios_comidas')
        .where('usuario_id', isEqualTo: usuarioId)
        .where('comida_id', isEqualTo: comidaId)
        .where('fecha', isEqualTo: Timestamp.fromDate(fecha))
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  } catch (e) {
    print("Error al eliminar comida: $e");
  }
}
