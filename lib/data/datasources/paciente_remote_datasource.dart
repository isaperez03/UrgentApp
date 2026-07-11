import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_collections.dart';
import '../models/atencion_model.dart';
import '../models/paciente_model.dart';

class PacienteRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatearId(String prefijo, int numero) {
    return '$prefijo${numero.toString().padLeft(3, '0')}';
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  Future<void> registrarPaciente({
    required String nombre,
    required int edad,
    required String tipoEmergencia,
    required String hospitalId,
    required String hospitalNombre,
  }) async {
    final hospitalRef =
    _firestore.collection(FirestoreCollections.hospitales).doc(hospitalId);

    final contadorRef = _firestore.collection('contadores').doc('pacientes');

    await _firestore.runTransaction((transaction) async {
      final hospitalSnapshot = await transaction.get(hospitalRef);
      final contadorSnapshot = await transaction.get(contadorRef);

      if (!hospitalSnapshot.exists) {
        throw Exception('El hospital no existe');
      }

      final hospitalData = hospitalSnapshot.data()!;
      final habitacionesLibres = _toInt(hospitalData['habitacionesLibres']);
      final habitacionesOcupadas = _toInt(hospitalData['habitacionesOcupadas']);

      if (habitacionesLibres <= 0) {
        throw Exception('Ya no hay habitaciones disponibles');
      }

      int ultimoNumero = 0;
      if (contadorSnapshot.exists) {
        final contadorData = contadorSnapshot.data()!;
        ultimoNumero = _toInt(contadorData['ultimoNumero']);
      }

      final nuevoNumero = ultimoNumero + 1;
      final pacienteId = _formatearId('PAC', nuevoNumero);

      final pacienteRef = _firestore
          .collection(FirestoreCollections.pacientes)
          .doc(pacienteId);

      final paciente = PacienteModel(
        id: pacienteId,
        nombre: nombre,
        edad: edad,
        tipoEmergencia: tipoEmergencia,
        hospitalId: hospitalId,
        hospitalNombre: hospitalNombre,
        estado: 'pendiente',
        fechaRegistro: DateTime.now(),
      );

      transaction.set(pacienteRef, paciente.toMap());

      transaction.update(hospitalRef, {
        'habitacionesLibres': habitacionesLibres - 1,
        'habitacionesOcupadas': habitacionesOcupadas + 1,
      });

      transaction.set(
        contadorRef,
        {'ultimoNumero': nuevoNumero},
        SetOptions(merge: true),
      );
    });
  }

  Stream<List<PacienteModel>> getPacientesStream() {
    return _firestore
        .collection(FirestoreCollections.pacientes)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => PacienteModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Stream<List<PacienteModel>> getPacientesPorHospitalStream(String hospitalId) {
    return _firestore
        .collection(FirestoreCollections.pacientes)
        .where('hospitalId', isEqualTo: hospitalId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => PacienteModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Stream<List<PacienteModel>> getEmergenciasActivasStream() {
    return _firestore
        .collection(FirestoreCollections.pacientes)
        .where('estado', isEqualTo: 'pendiente')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => PacienteModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Stream<List<PacienteModel>> getPacientesPorHospitalYEspecialidadStream(
      String hospitalId,
      String especialidad,
      ) {
    return _firestore
        .collection(FirestoreCollections.pacientes)
        .where('hospitalId', isEqualTo: hospitalId)
        .snapshots()
        .map((snapshot) {
      final pacientes = snapshot.docs
          .map((doc) => PacienteModel.fromMap(doc.id, doc.data()))
          .toList();

      final esp = especialidad.trim().toLowerCase();

      if (esp.isEmpty || esp == 'general') {
        return pacientes;
      }

      return pacientes.where((p) {
        final tipo = p.tipoEmergencia.trim().toLowerCase();
        if (esp == 'pediatría' || esp == 'pediatria') {
          return tipo == 'pediatría' || tipo == 'pediatria';
        }
        return tipo.contains(esp);
      }).toList();
    });
  }

  Future<void> cambiarEstadoPaciente({
    required String pacienteId,
    required String nuevoEstado,
  }) async {
    await _firestore
        .collection(FirestoreCollections.pacientes)
        .doc(pacienteId)
        .update({
      'estado': nuevoEstado,
    });
  }

  Future<void> guardarAtencion({
    required String pacienteId,
    required String pacienteNombre,
    required String diagnostico,
    required String medicamentos,
    required String procedimiento,
    required String observaciones,
  }) async {
    final pacienteRef =
    _firestore.collection(FirestoreCollections.pacientes).doc(pacienteId);

    final contadorRef = _firestore.collection('contadores').doc('atenciones');

    await _firestore.runTransaction((transaction) async {
      final pacienteSnapshot = await transaction.get(pacienteRef);
      final contadorSnapshot = await transaction.get(contadorRef);

      if (!pacienteSnapshot.exists) {
        throw Exception('El paciente no existe');
      }

      int ultimoNumero = 0;
      if (contadorSnapshot.exists) {
        final contadorData = contadorSnapshot.data()!;
        ultimoNumero = _toInt(contadorData['ultimoNumero']);
      }

      final nuevoNumero = ultimoNumero + 1;
      final atencionId = _formatearId('AT', nuevoNumero);

      final atencionRef = _firestore
          .collection(FirestoreCollections.atenciones)
          .doc(atencionId);

      final atencion = AtencionModel(
        id: atencionId,
        pacienteId: pacienteId,
        pacienteNombre: pacienteNombre,
        diagnostico: diagnostico,
        medicamentos: medicamentos,
        procedimiento: procedimiento,
        observaciones: observaciones,
        fechaRegistro: DateTime.now(),
      );

      transaction.set(atencionRef, atencion.toMap());

      transaction.update(pacienteRef, {
        'estado': 'en_atencion',
      });

      transaction.set(
        contadorRef,
        {'ultimoNumero': nuevoNumero},
        SetOptions(merge: true),
      );
    });
  }

  Future<void> darEgresoPaciente({
    required String pacienteId,
    required String hospitalId,
  }) async {
    final pacienteRef =
    _firestore.collection(FirestoreCollections.pacientes).doc(pacienteId);

    final hospitalRef =
    _firestore.collection(FirestoreCollections.hospitales).doc(hospitalId);

    await _firestore.runTransaction((transaction) async {
      final pacienteSnapshot = await transaction.get(pacienteRef);
      final hospitalSnapshot = await transaction.get(hospitalRef);

      if (!pacienteSnapshot.exists) {
        throw Exception('El paciente no existe');
      }

      if (!hospitalSnapshot.exists) {
        throw Exception('El hospital no existe');
      }

      final pacienteData = pacienteSnapshot.data()!;
      final estadoActual = (pacienteData['estado'] ?? '') as String;

      if (estadoActual == 'egresado') {
        throw Exception('El paciente ya fue egresado');
      }

      final hospitalData = hospitalSnapshot.data()!;
      final habitacionesLibres = _toInt(hospitalData['habitacionesLibres']);
      final habitacionesOcupadas = _toInt(hospitalData['habitacionesOcupadas']);

      transaction.update(pacienteRef, {
        'estado': 'egresado',
      });

      transaction.update(hospitalRef, {
        'habitacionesLibres': habitacionesLibres + 1,
        'habitacionesOcupadas':
        habitacionesOcupadas > 0 ? habitacionesOcupadas - 1 : 0,
      });
    });
  }

  Stream<List<AtencionModel>> getAtencionesByPaciente(String pacienteId) {
    return _firestore
        .collection(FirestoreCollections.atenciones)
        .where('pacienteId', isEqualTo: pacienteId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => AtencionModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }
}