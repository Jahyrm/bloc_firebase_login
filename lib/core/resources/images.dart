/// Clase que contine información util de las imágenes.
class Imagen {
  final String path;
  late String filename;
  late String extension;

  Imagen(this.path)
      : filename = path.split('.').first.split('/').last,
        extension = path.split('.').last;
}

/// En este archivo se estableceran todas las imágenes a utilizar en el proyecto
// Generales
// Imagen imgAvatar = Imagen('assets/imgs/avatar.png');