import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constantes/cores.dart';
import '../../servicos/servico_autenticacao.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final ServicoAutenticacao _auth = ServicoAutenticacao();

  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _corFundo => _isDark
      ? Theme.of(context).scaffoldBackgroundColor
      : const Color(0xFFF6F5FA);

  Color get _corTexto =>
      _isDark ? CoresApp.darkTextPrimary : const Color(0xFF2A2738);

  Color get _corSecundaria =>
      _isDark ? CoresApp.darkTextSecondary : const Color(0xFF7A7690);

  Color get _corSuperficie => _isDark ? CoresApp.darkSurfaceAlt : Colors.white;

  Color get _corBorda =>
      _isDark ? CoresApp.darkBorder : const Color(0xFFECE9F3);

  Color get _corDivisor =>
      _isDark ? CoresApp.darkBorder : const Color(0xFFF1EFF5);

  List<BoxShadow> get _sombra => _isDark
      ? const []
      : [
          BoxShadow(
            color: const Color(0xFF1E1A33).withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ];

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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corFundo,
      appBar: AppBar(
        title: const Text(
          'Meu Perfil',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
        centerTitle: true,
        backgroundColor: CoresApp.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: _isLoading
          ? Center(
              child: Container(
                width: 68,
                height: 68,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CoresApp.primary.withOpacity(_isDark ? 0.18 : 0.10),
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  color: CoresApp.primary,
                ),
              ),
            )
          : _userData == null
              ? _buildSemDados()
              : _buildPerfil(),
    );
  }

  Widget _buildSemDados() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CoresApp.primary.withOpacity(_isDark ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(34),
              ),
              child: Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CoresApp.primary.withOpacity(_isDark ? 0.26 : 0.16),
                      CoresApp.primary.withOpacity(_isDark ? 0.12 : 0.07),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Icon(
                  Icons.person_off_outlined,
                  size: 40,
                  color: CoresApp.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum dado encontrado',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _corTexto,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Preencha o formulário para aparecer aqui.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: _corSecundaria,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: CoresApp.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Voltar',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfil() {
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCabecalho(user),
              const SizedBox(height: 28),

              _buildTituloSecao(),
              const SizedBox(height: 16),

              _buildSection(
                icon: Icons.person_outline_rounded,
                title: 'Dados pessoais',
                descricao: 'Informações de identificação',
                initiallyExpanded: true,
                children: [
                  _buildInfoItem('CPF', 'cpf'),
                  _buildInfoItem('Data de nascimento', 'dataNascimento'),
                  _buildInfoItem(
                    'Idade',
                    'idade',
                    formatar: (v) => '$v anos',
                  ),
                  _buildInfoItem('Sexo', 'sexo'),
                  _buildInfoItem('Telefone', 'telefone'),
                  _buildInfoItem('Cartão SUS', 'cartaoSus'),
                ],
              ),

              _buildSection(
                icon: Icons.monitor_weight_outlined,
                title: 'Dados biométricos',
                descricao: 'Informações físicas e corporais',
                children: [
                  _buildInfoItem('Peso', 'peso'),
                  _buildInfoItem('Altura', 'altura'),
                  _buildInfoItem('IMC', 'imc'),
                  _buildInfoItem('Classificação', 'imcClassificacao'),
                  _buildInfoItem('Tipo sanguíneo', 'tipoSanguineo'),
                ],
              ),

              _buildSection(
                icon: Icons.medical_information_outlined,
                title: 'Informações médicas',
                descricao: 'Histórico e condições de saúde',
                children: [
                  _buildInfoItem('Plano de saúde', 'planoSaude'),
                  _buildInfoItem('Alergias', 'alergias'),
                  _buildInfoItem(
                    'Condições preexistentes',
                    'condicoesPreexistentes',
                  ),
                ],
              ),

              _buildSection(
                icon: Icons.emergency_outlined,
                title: 'Contato de emergência',
                descricao: 'Pessoa para contato em situações urgentes',
                children: [
                  _buildInfoItem('Nome', 'contatoEmergencia'),
                  _buildInfoItem(
                    'Parentesco',
                    'contatoEmergenciaParentesco',
                  ),
                  _buildInfoItem(
                    'Telefone',
                    'contatoEmergenciaTelefone',
                  ),
                ],
              ),

              _buildSection(
                icon: Icons.medication_outlined,
                title: 'Medicamentos e observações',
                descricao: 'Cuidados e informações adicionais',
                children: [
                  _buildInfoItem('Medicamentos', 'medicamentos'),
                  _buildInfoItem('Observações', 'observacoes'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCabecalho(User? user) {
    final nome = _valor('nome') == 'Não informado'
        ? 'Usuário'
        : _valor('nome');

    final email = _valor('email') == 'Não informado'
        ? user?.email ?? ''
        : _valor('email');

    final temNome = nome != 'Usuário';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _corSuperficie,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _corBorda),
        boxShadow: _sombra,
      ),
      child: Stack(
        children: [

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 88,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CoresApp.primary,
                    Color.lerp(CoresApp.primary, Colors.white, 0.28)!,
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 34, 22, 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _corSuperficie,
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(_isDark ? 0.30 : 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: CoresApp.primary,
                      child: temNome
                          ? Text(
                              _iniciais(nome),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            )
                          : const Icon(
                              Icons.person_rounded,
                              size: 46,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    nome,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      color: _corTexto,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (email.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mail_outline_rounded,
                          size: 14,
                          color: _corSecundaria,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: _corSecundaria,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color:
                          CoresApp.primary.withOpacity(_isDark ? 0.18 : 0.08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.health_and_safety_outlined,
                          color: CoresApp.primary,
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Meu perfil de saúde',
                          style: TextStyle(
                            color: CoresApp.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTituloSecao() {
    return Row(
      children: [
        Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                CoresApp.primary,
                CoresApp.primary.withOpacity(0.35),
              ],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Minhas informações',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _corTexto,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Confira seus dados pessoais e de saúde.',
                style: TextStyle(
                  fontSize: 13,
                  color: _corSecundaria,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String descricao,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _corSuperficie,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _corBorda),
        boxShadow: _sombra,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: CoresApp.primary.withOpacity(0.06),
              highlightColor: Colors.transparent,
            ),
            child: ExpansionTile(
              initiallyExpanded: initiallyExpanded,
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
              shape: const RoundedRectangleBorder(),
              collapsedShape: const RoundedRectangleBorder(),
              iconColor: CoresApp.primary,
              collapsedIconColor: _corSecundaria,
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CoresApp.primary.withOpacity(_isDark ? 0.24 : 0.16),
                      CoresApp.primary.withOpacity(_isDark ? 0.10 : 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: CoresApp.primary,
                  size: 22,
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _corTexto,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  descricao,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: _corSecundaria,
                  ),
                ),
              ),
              children: [
                Divider(height: 1, thickness: 1, color: _corDivisor),
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1)
                    Divider(height: 1, thickness: 1, color: _corDivisor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String chave, {
    String Function(String)? formatar,
  }) {
    String valor = _valor(chave);

    if (formatar != null && valor != 'Não informado') {
      valor = formatar(valor);
    }

    final naoInformado = valor == 'Não informado';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: _corSecundaria,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Text(
              valor,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.4,
                color: naoInformado
                    ? _corSecundaria.withOpacity(0.6)
                    : _corTexto,
                fontWeight:
                    naoInformado ? FontWeight.w400 : FontWeight.w600,
                fontStyle:
                    naoInformado ? FontStyle.italic : FontStyle.normal,
              ),
            ),
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

  String _iniciais(String nome) {
    final partes = nome
        .trim()
        .split(RegExp(r'\s+'))
        .where((parte) => parte.isNotEmpty)
        .toList();

    if (partes.isEmpty) return '';

    if (partes.length == 1) {
      return partes.first.substring(0, 1).toUpperCase();
    }

    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }
}