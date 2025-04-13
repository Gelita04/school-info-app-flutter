import 'dart:async'; // Necesario para Completer
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  // Completer se usa para obtener el GoogleMapController una vez que el mapa está listo.
  final Completer<GoogleMapController> _controllerCompleter = Completer();

  // Coordenadas de la escuela (¡Reemplaza con las coordenadas reales!)
  // Puedes obtenerlas buscando la dirección en Google Maps y haciendo clic derecho -> "¿Qué hay aquí?".
  static const LatLng schoolLocation =
      LatLng(40.416775, -3.703790); // Ejemplo: Puerta del Sol, Madrid

  // Posición inicial de la cámara del mapa
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: schoolLocation,
    zoom: 16.0, // Nivel de zoom (más alto = más cerca)
  );

  // Conjunto de marcadores para mostrar en el mapa
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // Añadimos el marcador de la escuela cuando el estado se inicializa
    _addSchoolMarker();
  }

  void _addSchoolMarker() {
    setState(() {
      _markers.add(
        Marker(
          markerId:
              const MarkerId('school_location'), // ID único para el marcador
          position: schoolLocation, // Posición del marcador
          infoWindow: const InfoWindow(
            // Información que aparece al tocar el marcador
            title: 'Colegio Flutterista',
            snippet:
                'Calle Falsa 123, Springfield', // Puedes usar la dirección real
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure), // Color del marcador
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación de la Escuela'),
        // El botón de retroceso se añade automáticamente por Navigator.push
      ),
      body: GoogleMap(
        mapType: MapType.normal, // Tipos: normal, satellite, hybrid, terrain
        initialCameraPosition: _initialCameraPosition, // Posición inicial
        markers: _markers, // Marcadores a mostrar
        onMapCreated: (GoogleMapController controller) {
          // Cuando el mapa se crea, completamos el Completer con el controller.
          if (!_controllerCompleter.isCompleted) {
            _controllerCompleter.complete(controller);
          }
        },
        myLocationButtonEnabled:
            false, // Oculta el botón de "mi ubicación" por ahora
        zoomControlsEnabled: true, // Muestra los controles de zoom +/-
      ),
      // (Opcional) FloatingActionButton para volver a centrar el mapa
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToSchool,
        label: const Text('Centrar Escuela'),
        icon: const Icon(Icons.school),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // Posición del botón
    );
  }

  // Función para animar la cámara de vuelta a la posición de la escuela
  Future<void> _goToSchool() async {
    final GoogleMapController controller = await _controllerCompleter.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
  }
}
