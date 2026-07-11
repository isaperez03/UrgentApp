import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_collections.dart';
import '../models/habitacion_model.dart';

class HabitacionRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<HabitacionModel>> getHabitacionesStream() {
    return _firestore
        .collection(FirestoreCollections.habitaciones)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => HabitacionModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Stream<List<HabitacionModel>> getHabitacionesByHospital(String hospitalId) {
    return _firestore
        .collection(FirestoreCollections.habitaciones)
        .where('idHospital', isEqualTo: hospitalId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => HabitacionModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> actualizarEstadoHabitacion({
    required String habitacionId,
    required String nuevoEstado,
  }) async {
    await _firestore
        .collection(FirestoreCollections.habitaciones)
        .doc(habitacionId)
        .update({
      'estado': nuevoEstado,
      'fechaActualizacion': Timestamp.fromDate(DateTime.now()),
    });
  }
}