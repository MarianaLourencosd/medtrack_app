import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    await _db.collection('usuarios').doc(user.user!.uid).set({
      'nome': nome.trim(),
      'email': email.trim(),
      'cpf': cpf.trim(),
      'formularioPreenchido': false,
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}