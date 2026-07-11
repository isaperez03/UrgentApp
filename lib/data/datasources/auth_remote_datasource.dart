import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/constants/firestore_collections.dart';
import '../models/usuario_app_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> register({
    required String nombre,
    required String email,
    required String password,
    required String rol,
    String hospitalId = '',
    String especialidad = '',
    String unidad = '',
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final uid = credential.user!.uid;

    final usuario = UsuarioAppModel(
      uid: uid,
      nombre: nombre.trim(),
      correo: email.trim(),
      rol: rol.trim().toLowerCase(),
      activo: true,
      hospitalId: hospitalId,
      especialidad: especialidad,
      unidad: unidad,
      fechaRegistro: DateTime.now(),
    );

    await _firestore
        .collection(FirestoreCollections.usuarios)
        .doc(uid)
        .set(usuario.toMap());
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UsuarioAppModel?> getCurrentUserData() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    final snapshot = await _firestore
        .collection(FirestoreCollections.usuarios)
        .doc(user.uid)
        .get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return UsuarioAppModel.fromMap(user.uid, snapshot.data()!);
  }
}