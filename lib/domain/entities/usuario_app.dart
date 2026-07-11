class UsuarioApp {
  final String uid;
  final String nombre;
  final String correo;
  final String rol;
  final bool activo;
  final String hospitalId;
  final String especialidad;
  final String unidad;
  final DateTime fechaRegistro;

  UsuarioApp({
    required this.uid,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.activo,
    required this.hospitalId,
    required this.especialidad,
    required this.unidad,
    required this.fechaRegistro,
  });
}