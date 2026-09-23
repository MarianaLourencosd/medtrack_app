import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../login/login_screen.dart';
import '../../screens/home_screen.dart';
import '../../constants/colors.dart';
import '../../styles/text_styles.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _auth = AuthService();

  final TextEditingController _nome = TextEditingController();
  final TextEditingController _cpf = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();
  final TextEditingController _confirmaSenha = TextEditingController();

  bool _loading = false;
  bool _isDarkMode = false;

  Future<void> _signup() async {
    if (_nome.text.isEmpty ||
        _cpf.text.isEmpty ||
        _email.text.isEmpty ||
        _senha.text.isEmpty ||
        _confirmaSenha.text.isEmpty) {
      _showSnackbar('Preencha todos os campos!');
      return;
    }

    if (_senha.text != _confirmaSenha.text) {
      _showSnackbar('Senhas não coincidem!');
      return;
    }

    if (_senha.text.length < 6) {
      _showSnackbar('Senha deve ter pelo menos 6 caracteres!');
      return;
    }

    setState(() => _loading = true);

    try {
      await _auth.signup(
        _nome.text,
        _email.text,
        _senha.text,
        _cpf.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );

      _showSnackbar(
        'Cadastro realizado! Faça login.',
        isSuccess: true,
      );
    } catch (e) {
      _showSnackbar(e.toString());
      setState(() => _loading = false);
    }
  }

  void _showSnackbar(
    String msg, {
    bool isSuccess = false,
  }) {
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
        backgroundColor: isSuccess ? Colors.green : Colors.red,
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
                          Icons.person_add_alt_1,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      'Crie sua conta',
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
                      'Preencha seus dados para criar sua conta no MedTrack.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: secondaryTextColor,
                        fontFamily: AppTextStyles.fontMontserrat,
                      ),
                    ),

                    const SizedBox(height: 30),

                    _buildLabel(
                      'Nome Completo',
                      primaryTextColor,
                    ),

                    const SizedBox(height: 7),

                    _buildTextField(
                      controller: _nome,
                      hint: 'Digite seu nome completo',
                      icon: Icons.person_outline,
                      inputColor: inputColor,
                      borderColor: borderColor,
                      primaryTextColor: primaryTextColor,
                    ),

                    const SizedBox(height: 18),

                    _buildLabel(
                      'CPF',
                      primaryTextColor,
                    ),

                    const SizedBox(height: 7),

                    _buildTextField(
                      controller: _cpf,
                      hint: 'Digite seu CPF',
                      icon: Icons.badge_outlined,
                      keyboardType: TextInputType.number,
                      inputColor: inputColor,
                      borderColor: borderColor,
                      primaryTextColor: primaryTextColor,
                    ),

                    const SizedBox(height: 18),

                    _buildLabel(
                      'E-mail',
                      primaryTextColor,
                    ),

                    const SizedBox(height: 7),

                    _buildTextField(
                      controller: _email,
                      hint: 'Digite seu e-mail',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      inputColor: inputColor,
                      borderColor: borderColor,
                      primaryTextColor: primaryTextColor,
                    ),

                    const SizedBox(height: 18),

                    _buildLabel(
                      'Senha',
                      primaryTextColor,
                    ),

                    const SizedBox(height: 7),

                    _buildTextField(
                      controller: _senha,
                      hint: 'Digite sua senha',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      inputColor: inputColor,
                      borderColor: borderColor,
                      primaryTextColor: primaryTextColor,
                    ),

                    const SizedBox(height: 18),

                    _buildLabel(
                      'Confirmar Senha',
                      primaryTextColor,
                    ),

                    const SizedBox(height: 7),

                    _buildTextField(
                      controller: _confirmaSenha,
                      hint: 'Digite sua senha novamente',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      inputColor: inputColor,
                      borderColor: borderColor,
                      primaryTextColor: primaryTextColor,
                    ),

                    const SizedBox(height: 26),

                    ElevatedButton(
                      onPressed: _loading ? null : _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(
                          double.infinity,
                          52,
                        ),
                        elevation: 3,
                        shadowColor:
                            AppColors.primary.withValues(alpha: 0.30),
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
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_add_alt_1,
                                  size: 20,
                                ),
                                SizedBox(width: 9),
                                Text(
                                  'Cadastrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        AppTextStyles.fontKarla,
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
                              fontFamily:
                                  AppTextStyles.fontMontserrat,
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
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
                        'Já tem conta? Entrar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily:
                              AppTextStyles.fontMontserrat,
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

  Widget _buildLabel(
    String text,
    Color color,
  ) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: color,
        fontFamily: AppTextStyles.fontMontserrat,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color inputColor,
    required Color borderColor,
    required Color primaryTextColor,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        fontSize: 14.5,
        color: primaryTextColor,
        fontFamily: AppTextStyles.fontMontserrat,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: _isDarkMode
              ? Colors.white54
              : Colors.grey.shade400,
          fontSize: 14,
          fontFamily: AppTextStyles.fontMontserrat,
        ),
        prefixIcon: Icon(
          icon,
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
    );
  }
}