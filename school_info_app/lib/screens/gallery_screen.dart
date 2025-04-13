import 'dart:typed_data'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Lista inicial solo con las rutas de assets
  final List<String> _initialImageAssets = const [
    'assets/images/aula.jpg',
    'assets/images/clase.jpg',
    'assets/images/deporte.jpg',
    'assets/images/escuela.jpg',
    'assets/images/escuelapatio.jpg',
    'assets/images/mesas.jpg',
    'assets/images/patio.jpg',
    'assets/images/school.jpg',
    
  ];

  // Lista dinámica que contendrá objetos:
  // - String para rutas de assets
  // - Uint8List para datos de imágenes seleccionadas
  late List<dynamic> _galleryItems;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inicializamos la lista dinámica con las rutas de assets
    _galleryItems = List.from(_initialImageAssets);
  }

  Future<void> _pickImage(ImageSource source) async {
    // No necesitamos el try-catch aquí si image_picker maneja errores internamente
    // y devuelve null. Pero es bueno tenerlo para otros posibles errores.
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1080,
      );

      if (pickedFile != null) {
        // LEEMOS LOS BYTES de la imagen seleccionada
        final Uint8List imageBytes = await pickedFile.readAsBytes();

        setState(() {
          // Añadimos los BYTES (Uint8List) a nuestra lista
          _galleryItems.add(imageBytes);
        });

        // Cerramos el diálogo de selección de fuente si estaba abierto
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print("Error al seleccionar imagen: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: ${e.toString()}')),
      );
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  void _showImageSourceDialog() {
    // En web, la cámara puede ser menos fiable o no estar disponible.
    // Podríamos deshabilitarla si kIsWeb es true, pero image_picker
    // debería manejarlo (puede que no muestre la opción o falle).
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Seleccionar origen"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(
                    'Galería/Archivo'), // Texto más genérico para web
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              // Opcional: Deshabilitar cámara en web si causa problemas
              // if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Cámara'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería de Fotos'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        itemCount: _galleryItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _galleryItems[index];

          // Determinamos si el item es un asset (String) o datos (Uint8List)
          Widget imageWidget;
          bool isAssetItem = false;

          if (item is String) {
            // Es una ruta de asset
            imageWidget = Image.asset(
              item,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSyncLoaded) =>
                  frame == null ? Container(color: Colors.grey[300]) : child,
              errorBuilder: (context, error, stack) => const Icon(Icons.error),
            );
            isAssetItem = true;
          } else if (item is Uint8List) {
            // Son bytes de una imagen seleccionada
            imageWidget = Image.memory(
              // <--- USAMOS Image.memory
              item,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSyncLoaded) =>
                  frame == null ? Container(color: Colors.grey[300]) : child,
              errorBuilder: (context, error, stack) => const Icon(Icons.error),
            );
          } else {
            // Caso inesperado, mostramos un placeholder
            imageWidget = Container(
                color: Colors.red.shade100, child: const Icon(Icons.error));
          }

          return GestureDetector(
            onTap: () {
              // Pasamos el item (String o Uint8List) al diálogo
              _showImageDialog(context, item, isAssetItem);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: imageWidget, // Usamos el widget que determinamos arriba
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showImageSourceDialog,
        tooltip: 'Añadir Imagen',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  // Modificamos _showImageDialog para aceptar 'dynamic' y el flag isAssetItem
  void _showImageDialog(BuildContext context, dynamic item, bool isAssetItem) {
    Widget imageDialogWidget;
    if (isAssetItem && item is String) {
      imageDialogWidget = Image.asset(item, fit: BoxFit.contain);
    } else if (!isAssetItem && item is Uint8List) {
      imageDialogWidget = Image.memory(item, fit: BoxFit.contain);
    } else {
      // Fallback por si acaso
      imageDialogWidget = const Center(child: Text("Error al mostrar imagen"));
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: InteractiveViewer(
              maxScale: 4.0,
              child:
                  imageDialogWidget, // Usamos el widget de imagen determinado
            ),
          ),
        );
      },
    );
  }
}
