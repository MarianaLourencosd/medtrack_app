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
          _buildSection(
            icon: Icons.badge_outlined,
            title: 'Dados Pessoais',
            initiallyExpanded: true,
            children: [
              _buildInfoItem('CPF', _valor('cpf')),
              _buildInfoItem('Data de Nascimento', _valor('dataNascimento')),
              _buildInfoItem('Idade', _idadeTexto(_userData?['idade'])),
              _buildInfoItem('Sexo', _valor('sexo')),
              _buildInfoItem('Telefone', _valor('telefone')),
              _buildInfoItem('Cartão SUS', _valor('cartaoSus')),
            ],
          ),
          _buildSection(
            icon: Icons.monitor_weight_outlined,
            title: 'Dados Biométricos',
            children: [
              _buildInfoItem('Peso', _valor('peso')),
              _buildInfoItem('Altura', _valor('altura')),
              _buildInfoItem('IMC', _valor('imc')),
              _buildInfoItem('Classificação', _valor('imcClassificacao')),
              _buildInfoItem('Tipo Sanguíneo', _valor('tipoSanguineo')),
            ],
          ),
          _buildSection(
            icon: Icons.medical_information_outlined,
            title: 'Informações Médicas',
            children: [
              _buildInfoItem('Plano de Saúde', _valor('planoSaude')),
              _buildInfoItem('Alergias', _valor('alergias')),
              _buildInfoItem('Condições Preexistentes', _valor('condicoesPreexistentes')),
            ],
          ),
          _buildSection(
            icon: Icons.emergency_outlined,
            title: 'Contato de Emergência',
            children: [
              _buildInfoItem('Nome', _valor('contatoEmergencia')),
              _buildInfoItem('Parentesco', _valor('contatoEmergenciaParentesco')),
              _buildInfoItem('Telefone', _valor('contatoEmergenciaTelefone')),
            ],
          ),
          _buildSection(
            icon: Icons.medication_outlined,
            title: 'Medicamentos e Observações',
            children: [
              _buildInfoItem('Medicamentos', _valor('medicamentos')),
              _buildInfoItem('Observações', _valor('observacoes')),
            ],
          ),
        ],
      ),
    );
  }

  String _valor(String chave) {
    final valor = _userData?[chave];
    if (valor == null) return 'Não informado';
    final texto = '$valor'.trim();
    return texto.isEmpty ? 'Não informado' : texto;
  }

  String _idadeTexto(dynamic idade) {
    if (idade == null) return 'Não informado';
    return '$idade anos';
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          initiallyExpanded: initiallyExpanded,
          leading: Icon(icon, color: AppColors.primary),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
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