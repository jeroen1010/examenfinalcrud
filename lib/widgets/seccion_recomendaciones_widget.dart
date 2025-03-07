import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_dietas/widgets/recomendaciones_widget.dart';

import '../screens/recomendations_screen.dart';

Widget seccionRecomendaciones(Color secondaryColor, Color textColor) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recomendaciones',
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        const SizedBox(height: 16), 
        SizedBox(
          height: 250, 
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('comidas')
                .where('recomendado', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No hay recomendaciones disponibles'));
              }
              
              var recetas = snapshot.data!.docs;
              return ListView(
                scrollDirection: Axis.horizontal,
                children: recetas.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeScreen(),
                        ),
                      );
                    },
                    child: recomendaciones(
                      data['nombre'] ?? 'Sin nombre',
                      data['imagen'] ?? '',
                      secondaryColor,
                      textColor,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    ),
  );
}
