import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/colors.dart';
import '../../services/auth_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final AuthService _auth = AuthService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final usuario = await _auth.getUsuario(user.uid);
      final formulario = await _auth.getFormulario(user.uid);

      if (mounted) {
        setState(() {
          _userData = {...?usuario, ...?formulario};
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? _buildSemDados()
              : _buildPerfil(),
    );
  }

  Widget _buildSemDados() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            'Nenhum dado encontrado',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Preencha o formulário para aparecer aqui',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }

  Widget _buildPerfil() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _userData?['nome'] ?? 'Usuário',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userData?['email'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          _buildInfoItem('CPF', _userData?['cpf'] ?? 'Não informado'),
          _buildInfoItem('Telefone', _userData?['telefone'] ?? 'Não informado'),
          _buildInfoItem('Tipo Sanguíneo', _userData?['tipoSanguineo'] ?? 'Não informado'),
          _buildInfoItem('Alergias', _userData?['alergias'] ?? 'Não informado'),
          _buildInfoItem('Plano de Saúde', _userData?['planoSaude'] ?? 'Não informado'),
          _buildInfoItem('Contato Emergência', _userData?['contatoEmergencia'] ?? 'Não informado'),
          _buildInfoItem('Peso', _userData?['peso'] ?? 'Não informado'),
          _buildInfoItem('Altura', _userData?['altura'] ?? 'Não informado'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}