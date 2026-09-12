import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseConfig {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError(
      'FirebaseConfig não configurado para esta plataforma. '
      'Adicione as opções de Android/iOS ou use flutterfire configure.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCZL5AMjbIDcugRZT8ICD5GL7w0WldNdUY',
    appId: '1:435824970238:web:eb558cf86bea7edd62d8af',
    messagingSenderId: '435824970238',
    projectId: 'medtrackjgf',
    authDomain: 'medtrackjgf.firebaseapp.com',
    storageBucket: 'medtrackjgf.firebasestorage.app',
  );
}