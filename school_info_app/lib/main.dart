import 'package:flutter/material.dart';
import 'widgets/app_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Info Escuela',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- HomeScreen Actualizada ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // --- Datos de ejemplo de la escuela ---
  // En una app real, estos datos podrían venir de una base de datos,
  // un archivo de configuración, o una API.
  final String schoolName = "Colegio Flutterista";
  final String schoolAddress = "Calle Falsa 123, Springfield";
  final String schoolPhone = "+1 234 567 890";
  final String schoolDescription =
      "Una institución dedicada a la enseñanza del desarrollo móvil "
      "con Flutter. Ofrecemos cursos desde nivel básico hasta avanzado, "
      "fomentando un ambiente de aprendizaje colaborativo y práctico.";
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(schoolName),
      ),

      drawer:
          const AppDrawer(), // Aquí le decimos al Scaffold que use nuestro drawer// Usamos SingleChildScrollView para que el contenido sea desplazable
      // si no cabe en pantallas pequeñas.
      body: SingleChildScrollView(
        // Padding añade espacio alrededor del contenido principal.
        child: Padding(
          padding: const EdgeInsets.all(
              16.0), // 16 píxeles de espacio en todos los lados
          // Column organiza sus hijos verticalmente.
          child: Column(
            // crossAxisAlignment.start alinea los hijos a la izquierda.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Placeholder para una futura imagen (opcional)
              Center(
                child: Icon(
                  Icons.school, // Icono de escuela
                  size: 80.0, // Tamaño grande
                  color: Theme.of(context)
                      .primaryColor, // Usa el color primario del tema
                ),
              ),
              // SizedBox añade un espacio vertical fijo.
              const SizedBox(height: 24.0),

              // Nombre de la escuela (ya está en la AppBar, pero lo ponemos aquí también)
              Center(
                child: Text(
                  schoolName,
                  // textAlign: TextAlign.center, // Centra el texto
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall, // Estilo predefinido para títulos
                ),
              ),
              const SizedBox(height: 16.0), // Más espacio

              // Sección de Dirección
              _buildInfoRow(
                  icon: Icons.location_on, // Icono de ubicación
                  text: schoolAddress,
                  context: context),
              const SizedBox(height: 12.0), // Espacio entre filas

              // Sección de Teléfono
              _buildInfoRow(
                  icon: Icons.phone, // Icono de teléfono
                  text: schoolPhone,
                  context: context),
              const SizedBox(height: 24.0), // Espacio antes de la descripción

              // Descripción de la escuela
              Text(
                'Descripción:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold // Título de sección en negrita
                    ),
              ),
              const SizedBox(height: 8.0),
              Text(
                schoolDescription,
                textAlign:
                    TextAlign.justify, // Justifica el texto para mejor lectura
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium, // Estilo para cuerpo de texto
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Esto ayuda a no repetir código y mantenerlo limpio.
  Widget _buildInfoRow(
      {required IconData icon,
      required String text,
      required BuildContext context}) {
    // Row organiza sus hijos horizontalmente.
    return Row(
      // crossAxisAlignment.start alinea los elementos al inicio verticalmente
      // si tienen diferentes alturas.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          color: Theme.of(context).primaryColor, // Color del icono
          size: 24.0, // Tamaño del icono
        ),
        const SizedBox(width: 12.0), // Espacio horizontal entre icono y texto
        // Expanded asegura que el texto use el espacio horizontal restante
        // y se ajuste (wrap) si es muy largo.
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyLarge, // Estilo para info principal
          ),
        ),
      ],
    );
  }
}
