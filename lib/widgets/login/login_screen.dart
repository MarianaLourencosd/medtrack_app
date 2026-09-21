import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../cadastro/signup_screen.dart';
import '../../screens/home_screen.dart';
import '../../constants/colors.dart';
import '../../styles/text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  bool _loading = false;
  bool _isDarkMode = false;

  Future<void> _login() async {
    if (_email.text.isEmpty || _senha.text.isEmpty) {
      _showSnackbar('Preencha todos os campos!');
      return;
    }

    setState(() => _loading = true);

    try {
      await _auth.login(_email.text, _senha.text);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (e) {
      _showSnackbar(e.toString());
      setState(() => _loading = false);
    }
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
            fontFamily: AppTextStyles.fontMontserrat,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _isDarkMode ? const Color(0xFF121B18) : Colors.grey.shade50;

    final cardColor =
        _isDarkMode ? const Color(0xFF1A2622) : Colors.white;

    final primaryTextColor =
        _isDarkMode ? Colors.white : AppColors.textPrimary;

    final secondaryTextColor =
        _isDarkMode ? Colors.white70 : AppColors.textSecondary;

    final inputColor =
        _isDarkMode ? const Color(0xFF24332E) : Colors.grey.shade50;

    final borderColor =
        _isDarkMode ? Colors.white12 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              ),
            );
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-claro.png',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'MedTrack',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontFamily: AppTextStyles.fontKarla,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _isDarkMode
                ? 'Modo claro'
                : 'Modo escuro',
            icon: Icon(
              _isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 460,
              ),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: _isDarkMode ? 0.25 : 0.06,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Bem-vindo de volta!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: primaryTextColor,
                        fontFamily: AppTextStyles.fontSpectral,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Entre na sua conta para acessar suas informações de saúde.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: secondaryTextColor,
                        fontFamily: AppTextStyles.fontMontserrat,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'E-mail',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                        fontFamily: AppTextStyles.fontMontserrat,
                      ),
                    ),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: primaryTextColor,
                        fontFamily: AppTextStyles.fontMontserrat,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Digite seu e-mail',
                        hintStyle: TextStyle(
                          color: _isDarkMode
                              ? Colors.white54
                              : Colors.grey.shade400,
                          fontSize: 14,
                          fontFamily: AppTextStyles.fontMontserrat,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: inputColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: borderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Senha',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                        fontFamily: AppTextStyles.fontMontserrat,
                      ),
                    ),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _senha,
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: primaryTextColor,
                        fontFamily: AppTextStyles.fontMontserrat,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Digite sua senha',
                        hintStyle: TextStyle(
                          color: _isDarkMode
                              ? Colors.white54
                              : Colors.grey.shade400,
                          fontSize: 14,
                          fontFamily: AppTextStyles.fontMontserrat,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: inputColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: borderColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    ElevatedButton(
                      onPressed: _loading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(
                          double.infinity,
                          52,
                        ),
                        elevation: 3,
                        shadowColor: AppColors.primary.withValues(alpha: 0.30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 23,
                              height: 23,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.login,
                                  size: 20,
                                ),
                                SizedBox(width: 9),
                                Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppTextStyles.fontKarla,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: _isDarkMode
                                ? Colors.white24
                                : Colors.grey.shade300,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          child: Text(
                            'ou',
                            style: TextStyle(
                              fontSize: 12,
                              color: _isDarkMode
                                  ? Colors.white54
                                  : Colors.grey.shade500,
                              fontFamily: AppTextStyles.fontMontserrat,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: _isDarkMode
                                ? Colors.white24
                                : Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Não tem conta? Cadastre-se',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppTextStyles.fontMontserrat,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}