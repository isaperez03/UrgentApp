import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_collections.dart';
import '../../domain/entities/dashboard_stats.dart';

class DashboardRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DashboardStats> getDashboardStats() {
    return _firestore.collection(FirestoreCollections.pacientes).snapshots().asyncMap(
          (pacientesSnapshot) async {
        final hospitalesSnapshot =
        await _firestore.collection(FirestoreCollections.hospitales).get();

        final pacientesDocs = pacientesSnapshot.docs;
        final hospitalesDocs = hospitalesSnapshot.docs;

        final totalPacientes = pacientesDocs.length;

        final emergenciasActivas = pacientesDocs
            .where((doc) => (doc.data()['estado'] ?? '') == 'pendiente')
            .length;

        final pacientesEnAtencion = pacientesDocs
            .where((doc) => (doc.data()['estado'] ?? '') == 'en_atencion')
            .length;

        final pacientesEgresados = pacientesDocs
            .where((doc) => (doc.data()['estado'] ?? '') == 'egresado')
            .length;

        final hospitalesActivos = hospitalesDocs
            .where((doc) => (doc.data()['activo'] ?? false) == true)
            .length;

        int habitacionesLibresTotales = 0;

        for (final doc in hospitalesDocs) {
          final data = doc.data();
          habitacionesLibresTotales += (data['habitacionesLibres'] ?? 0) as int;
        }

        return DashboardStats(
          totalPacientes: totalPacientes,
          emergenciasActivas: emergenciasActivas,
          pacientesEnAtencion: pacientesEnAtencion,
          pacientesEgresados: pacientesEgresados,
          hospitalesActivos: hospitalesActivos,
          habitacionesLibresTotales: habitacionesLibresTotales,
        );
      },
    );
  }
}