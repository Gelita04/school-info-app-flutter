import 'package:flutter/material.dart';
import '../screens/map_screen.dart';
import '../screens/gallery_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // ListView asegura que el contenido del drawer sea desplazable si hay muchos elementos.
      child: ListView(
        // Es importante quitar cualquier padding del ListView para que el DrawerHeader se ajuste bien.
        padding: EdgeInsets.zero,
        children: <Widget>[
          // DrawerHeader proporciona un espacio estándar en la parte superior del drawer.
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .primaryColor, // Color de fondo igual al de la AppBar
            ),
            child: const Text(
              'Menú Principal',
              style: TextStyle(
                color: Colors.white, // Texto blanco para contraste
                fontSize: 24,
              ),
            ),
          ),
          // ListTile es un widget estándar para filas en listas o menús.
          ListTile(
            leading: const Icon(Icons.home), // Icono a la izquierda
            title: const Text('Inicio'), // Texto principal
            onTap: () {
              // Acción al tocar:
              // 1. Cierra el drawer.
              Navigator.pop(context);
              // 2. (Opcional) Navega a la pantalla de inicio si ya no estamos en ella.
              // Como ya estamos en HomeScreen, solo cerramos el drawer.
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Mapa de Ubicación'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer primero
              // --- NAVEGACIÓN REAL ---
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
              // -----------------------
              // print('Ir a la pantalla del Mapa'); // Ya no necesitamos esto
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galería de Fotos'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer primero
              // --- NAVEGACIÓN REAL ---
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GalleryScreen()),
              );
              // -----------------------
              // print('Ir a la pantalla de Galería'); // Ya no necesitamos esto
            },
          ),
          // Puedes añadir más ListTiles para otras secciones si es necesario
        ],
      ),
    );
  }
}
