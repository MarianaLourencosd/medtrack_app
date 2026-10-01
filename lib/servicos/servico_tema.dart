import 'package:shared_preferences/shared_preferences.dart';

class ServicoTema {
  static const String _chave = 'tema_escuro';

  static Future<bool> carregarTemaEscuro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chave) ?? false;
  }

  static Future<void> salvarTemaEscuro(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chave, isDark);
  }
}