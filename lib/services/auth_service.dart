import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUsuario(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  Future<Map<String, dynamic>?> getFormulario(String uid) async {
    final doc = await _db.collection('formularios').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  Future<void> salvarFormulario(String uid, Map<String, dynamic> dados) async {
    await _db.collection('formularios').doc(uid).set({
      ...dados,
      'usuarioId': uid,
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
    await _db
        .collection('usuarios')
        .doc(uid)
        .set({'formularioPreenchido': true}, SetOptions(merge: true));
  }

  Future<void> login(String email, String senha) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
  }

  Future<void> signup(String nome, String email, String senha, String cpf) async {
    final user = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: senha,
    );
    final uid = user.user!.uid;
    await _db.collection('usuarios').doc(uid).set({
      'usuarioId': uid,
      'nome': nome.trim(),
      'email': email.trim(),
      'cpf': cpf.trim(),
      'formularioPreenchido': false,
      'criadoEm': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}