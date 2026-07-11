import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_collections.dart';
import '../models/hospital_model.dart';

class HospitalRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<HospitalModel>> getAvailableHospitalsStream() {
    return _firestore
        .collection(FirestoreCollections.hospitales)
        .where('activo', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final hospitales = snapshot.docs
          .map((doc) => HospitalModel.fromMap(doc.id, doc.data()))
          .toList();

      return hospitales.where((hospital) {
        return hospital.habitacionesLibres > 0 || hospital.uciLibres > 0;
      }).toList();
    });
  }
}