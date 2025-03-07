import 'package:app_dietas/services/firebase_services.dart';
import 'package:app_dietas/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_dietas/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CrudComidasScreen extends StatefulWidget {
  final String usuarioId;

  const CrudComidasScreen({Key? key, required this.usuarioId})
      : super(key: key);

  @override
  _CrudComidasScreenState createState() => _CrudComidasScreenState();
}

class _CrudComidasScreenState extends State<CrudComidasScreen> {
  List<Map<String, dynamic>> comidas = [];
  DateTime fechaSeleccionada = DateTime.now();
  int selectedIndex = -1;

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController urlImagenController = TextEditingController();
  final TextEditingController caloriasController = TextEditingController();

  String? categoriaSeleccionada;
  List<String> categorias = ['Desayuno', 'Almuerzo', 'Cena'];

  @override
  void initState() {
    super.initState();
    _cargarComidas();
    Intl.defaultLocale = 'es_ES';
  }

  Future<void> _cargarComidas() async {
    List<Map<String, dynamic>> comidasObtenidas = await obtenerComidas();
    setState(() {
      comidas = comidasObtenidas;
    });
  }

  Future<List<Map<String, dynamic>>> obtenerComidas() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('comidas').get();
    return snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
        .toList();
  }

  Future<void> agregarComida() async {
    if (nombreController.text.isEmpty || categoriaSeleccionada == null) return;

    try {
      String nuevaComidaId = await agregarComidaFirebase({
        'nombre': nombreController.text,
        'descripcion': descripcionController.text,
        'imagen': urlImagenController.text,
        'calorias': int.tryParse(caloriasController.text) ?? 300,
        'categoria': categoriaSeleccionada,
        'recomendado': false,
        'fecha': FieldValue.serverTimestamp(),
      });

      await asignarComidaAUsuario(
          widget.usuarioId, nuevaComidaId, fechaSeleccionada);
      await _cargarComidas();
      _limpiarCampos();
    } catch (e) {
      print("Error al agregar: $e");
    }
  }

  Future<void> modificarComida() async {
    if (selectedIndex == -1 || categoriaSeleccionada == null) return;

    try {
      await actualizarComida(comidas[selectedIndex]['id'], {
        'nombre': nombreController.text,
        'descripcion': descripcionController.text,
        'imagen': urlImagenController.text,
        'calorias': int.tryParse(caloriasController.text) ?? 300,
        'categoria': categoriaSeleccionada,
        'recomendado': comidas[selectedIndex]['recomendado'] ?? false,
      });

      await _cargarComidas();
      _limpiarCampos();
    } catch (e) {
      print("Error al modificar: $e");
    }
  }

  Future<void> borrarComida(int index) async {
    if (index < 0 || index >= comidas.length) return;

    try {
      await FirebaseFirestore.instance
          .collection('comidas')
          .doc(comidas[index]['id'])
          .delete();
      setState(() {
        comidas.removeAt(index);
      });
      print('Comida eliminada correctamente');
    } catch (e) {
      print("Error al borrar: $e");
    }
  }

  Future<void> toggleRecomendado(int index) async {
    if (index < 0 || index >= comidas.length) return;
    bool nuevoEstado = !(comidas[index]['recomendado'] ?? false);
    try {
      await FirebaseFirestore.instance
          .collection('comidas')
          .doc(comidas[index]['id'])
          .update({
        'recomendado': nuevoEstado,
      });
      setState(() {
        comidas[index]['recomendado'] = nuevoEstado;
      });
    } catch (e) {
      print("Error al actualizar el estado recomendado: $e");
    }
  }

  void _limpiarCampos() {
    nombreController.clear();
    descripcionController.clear();
    urlImagenController.clear();
    caloriasController.clear();
    setState(() => selectedIndex = -1);
    categoriaSeleccionada = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comidas del Día'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundLight,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormularioComida(
                nombreController: nombreController,
                descripcionController: descripcionController,
                urlImagenController: urlImagenController,
                caloriasController: caloriasController,
                agregarComida: agregarComida,
                modificarComida: modificarComida,
                borrarComida: _limpiarCampos,
                comidas: comidas,
                selectedIndex: selectedIndex,
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                hint: Text('Selecciona una categoría'),
                value: categoriaSeleccionada,
                onChanged: (String? newValue) {
                  setState(() {
                    categoriaSeleccionada = newValue;
                  });
                },
                items: categorias.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fecha: ${DateFormat('dd/MM/yyyy').format(fechaSeleccionada)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? nuevaFecha = await showDatePicker(
                        context: context,
                        initialDate: fechaSeleccionada,
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2030),
                      );
                      if (nuevaFecha != null) {
                        setState(() => fechaSeleccionada = nuevaFecha);
                        _cargarComidas();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 450,
                child: TableCalendar(
                  locale: 'es_ES',
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: fechaSeleccionada,
                  selectedDayPredicate: (day) =>
                      isSameDay(day, fechaSeleccionada),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      fechaSeleccionada = selectedDay;
                      _cargarComidas();
                    });
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: AppTheme.accentColor,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: AppTheme.accentColor,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: TextStyle(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                    defaultTextStyle: TextStyle(
                      color: AppTheme.secondaryColor,
                    ),
                    outsideTextStyle: TextStyle(
                      color: AppTheme.secondaryColor.withOpacity(0.5),
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    weekendStyle: TextStyle(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 300, 
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  physics:
                      const AlwaysScrollableScrollPhysics(), 
                  padding:
                      const EdgeInsets.all(8.0),
                  itemCount: comidas.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 8), 
                      color: AppTheme.accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: comidas[index]["imagen"]?.isNotEmpty == true
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  comidas[index]["imagen"],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image_not_supported,
                                        size: 50);
                                  },
                                ),
                              )
                            : const Icon(Icons.fastfood, size: 50),
                        title: Text(
                          comidas[index]["nombre"] ?? "Sin nombre",
                          style: TextStyle(color: AppTheme.backgroundLight),
                        ),
                        subtitle: Text(
                          comidas[index]["categoria"] ?? "Sin categoría",
                          style: TextStyle(color: AppTheme.backgroundLight),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                comidas[index]["recomendado"] == true
                                    ? Icons.star
                                    : Icons.star_border,
                                color: AppTheme.primaryColor,
                              ),
                              onPressed: () => toggleRecomendado(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: AppTheme.primaryColor,
                              onPressed: () => borrarComida(index),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            nombreController.text =
                                comidas[index]['nombre'] ?? '';
                            descripcionController.text =
                                comidas[index]['descripcion'] ?? '';
                            urlImagenController.text =
                                comidas[index]['imagen'] ?? '';
                            caloriasController.text =
                                comidas[index]['calorias']?.toString() ?? '';
                            categoriaSeleccionada = comidas[index]['categoria'];
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
