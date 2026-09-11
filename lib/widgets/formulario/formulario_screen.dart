import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/colors.dart';
import '../../services/auth_service.dart';
import '../../styles/text_styles.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  // Dados cadastrais já obtidos no cadastro
  String? _nomeUsuario;
  String? _cpfUsuario;

  // Controllers - Dados Biométricos e Gerais
  final TextEditingController _dataNascimentoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _cartaoSusController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  // Controllers - Informações Médicas
  final TextEditingController _planoController = TextEditingController();
  final TextEditingController _alergiasController = TextEditingController();
  final TextEditingController _condicoesController = TextEditingController();

  // Controllers - Contato de Emergência
  final TextEditingController _emergenciaNomeController = TextEditingController();
  final TextEditingController _emergenciaParentescoController = TextEditingController();
  final TextEditingController _emergenciaTelefoneController = TextEditingController();

  // Controllers - Medicamentos e Observações
  final TextEditingController _medicamentosController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();

  // Selected values
  String? _sexoSelecionado;
  String? _tipoSanguineoSelecionado;
  DateTime? _dataNascimentoDate;
  int? _idadeCalculada;
  double? _imcCalculado;
  String? _imcClassificacao;

  // Accordion / Section toggle states
  bool _expandDadosPessoais = true;
  bool _expandContatosEmergencia = false;
  bool _expandMedicamentos = false;
  bool _expandObservacoes = false;

  // UI States
  bool _isLoading = false;
  bool _isFetchingInitialData = true;
  bool _isDarkMode = false;

  final List<String> _opcoesSexo = [
    'Masculino',
    'Feminino',
    'Outro',
    'Prefiro não informar',
  ];

  final List<String> _tiposSanguineos = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    _alturaController.addListener(_calcularImc);
    _pesoController.addListener(_calcularImc);
    _carregarDadosIniciais();
  }

  @override
  void dispose() {
    _dataNascimentoController.dispose();
    _alturaController.dispose();
    _pesoController.dispose();
    _cartaoSusController.dispose();
    _telefoneController.dispose();
    _planoController.dispose();
    _alergiasController.dispose();
    _condicoesController.dispose();
    _emergenciaNomeController.dispose();
    _emergenciaParentescoController.dispose();
    _emergenciaTelefoneController.dispose();
    _medicamentosController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _calcularImc() {
    final pesoStr = _pesoController.text.replaceAll(',', '.').trim();
    final alturaStr = _alturaController.text.replaceAll(',', '.').trim();

    final peso = double.tryParse(pesoStr);
    final altura = double.tryParse(alturaStr);

    if (peso != null && altura != null && peso > 0 && altura > 0) {
      // Se a altura foi digitada em cm (ex: 175 em vez de 1.75), converte
      final alturaMetros = altura > 3.0 ? (altura / 100) : altura;
      final imc = peso / (alturaMetros * alturaMetros);

      String classificacao;
      if (imc < 18.5) {
        classificacao = 'Abaixo do peso';
      } else if (imc < 24.9) {
        classificacao = 'Peso adequado';
      } else if (imc < 29.9) {
        classificacao = 'Sobrepeso';
      } else if (imc < 34.9) {
        classificacao = 'Obesidade Grau I';
      } else if (imc < 39.9) {
        classificacao = 'Obesidade Grau II';
      } else {
        classificacao = 'Obesidade Grau III';
      }

      setState(() {
        _imcCalculado = imc;
        _imcClassificacao = classificacao;
      });
    } else {
      if (_imcCalculado != null) {
        setState(() {
          _imcCalculado = null;
          _imcClassificacao = null;
        });
      }
    }
  }

  void _calcularIdade(DateTime dataNasc) {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNasc.year;
    if (hoje.month < dataNasc.month ||
        (hoje.month == dataNasc.month && hoje.day < dataNasc.day)) {
      idade--;
    }
    setState(() {
      _idadeCalculada = idade >= 0 ? idade : 0;
    });
  }

  Future<void> _carregarDadosIniciais() async {
    try {
      User? user;
      try {
        user = FirebaseAuth.instance.currentUser;
      } catch (_) {}

      if (user == null) {
        if (mounted) {
          setState(() => _isFetchingInitialData = false);
        }
        return;
      }

      final usuario = await _auth.getUsuario(user.uid);
      final formulario = await _auth.getFormulario(user.uid);
      final data = formulario ?? <String, dynamic>{};

      if (mounted) {
        setState(() {
          if (usuario != null) {
            if (usuario['nome'] != null) _nomeUsuario = usuario['nome'].toString();
            if (usuario['cpf'] != null) _cpfUsuario = usuario['cpf'].toString();
          }
          if (data['dataNascimento'] != null) {
            _dataNascimentoController.text = data['dataNascimento'].toString();
            final partes = data['dataNascimento'].toString().split('/');
            if (partes.length == 3) {
              final dia = int.tryParse(partes[0]);
              final mes = int.tryParse(partes[1]);
              final ano = int.tryParse(partes[2]);
              if (dia != null && mes != null && ano != null) {
                _dataNascimentoDate = DateTime(ano, mes, dia);
                _calcularIdade(_dataNascimentoDate!);
              }
            }
          }
          if (data['sexo'] != null && _opcoesSexo.contains(data['sexo'])) {
            _sexoSelecionado = data['sexo'].toString();
          }
          if (data['altura'] != null) _alturaController.text = data['altura'].toString();
          if (data['peso'] != null) _pesoController.text = data['peso'].toString();
          if (data['cartaoSus'] != null) _cartaoSusController.text = data['cartaoSus'].toString();
          if (data['telefone'] != null) _telefoneController.text = data['telefone'].toString();
          if (data['tipoSanguineo'] != null && _tiposSanguineos.contains(data['tipoSanguineo'])) {
            _tipoSanguineoSelecionado = data['tipoSanguineo'].toString();
          }
          if (data['planoSaude'] != null) _planoController.text = data['planoSaude'].toString();
          if (data['alergias'] != null) _alergiasController.text = data['alergias'].toString();
          if (data['condicoesPreexistentes'] != null) {
            _condicoesController.text = data['condicoesPreexistentes'].toString();
          }
          if (data['contatoEmergencia'] != null) {
            _emergenciaNomeController.text = data['contatoEmergencia'].toString();
          }
          if (data['contatoEmergenciaTelefone'] != null) {
            _emergenciaTelefoneController.text = data['contatoEmergenciaTelefone'].toString();
          }
          if (data['contatoEmergenciaParentesco'] != null) {
            _emergenciaParentescoController.text = data['contatoEmergenciaParentesco'].toString();
          }
          if (data['medicamentos'] != null) {
            _medicamentosController.text = data['medicamentos'].toString();
          }
          if (data['observacoes'] != null) {
            _observacoesController.text = data['observacoes'].toString();
          }
        });
        _calcularImc();
      }
    } catch (_) {
      // Mantém campos vazios em caso de erro na leitura inicial
    } finally {
      if (mounted) {
        setState(() => _isFetchingInitialData = false);
      }
    }
  }

  Future<void> _selecionarDataNascimento() async {
    final agora = DateTime.now();
    final DateTime? escolhida = await showDatePicker(
      context: context,
      initialDate: _dataNascimentoDate ?? DateTime(agora.year - 25, agora.month, agora.day),
      firstDate: DateTime(1900),
      lastDate: agora,
      locale: const Locale('pt', 'BR'),
      helpText: 'SELECIONE SUA DATA DE NASCIMENTO',
      cancelText: 'CANCELAR',
      confirmText: 'CONFIRMAR',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (escolhida != null) {
      setState(() {
        _dataNascimentoDate = escolhida;
        final dia = escolhida.day.toString().padLeft(2, '0');
        final mes = escolhida.month.toString().padLeft(2, '0');
        final ano = escolhida.year.toString();
        _dataNascimentoController.text = '$dia/$mes/$ano';
      });
      _calcularIdade(escolhida);
    }
  }

  Future<void> _salvarFormulario() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackbar('Por favor, preencha os campos obrigatórios (*)', isError: true);
      return;
    }

    if (_sexoSelecionado == null) {
      _showSnackbar('Por favor, selecione o sexo', isError: true);
      return;
    }

    if (_tipoSanguineoSelecionado == null) {
      _showSnackbar('Por favor, selecione o tipo sanguíneo', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackbar('Você precisa estar logado para salvar suas informações.', isError: true);
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final dadosParaSalvar = {
      'dataNascimento': _dataNascimentoController.text.trim(),
      'idade': _idadeCalculada,
      'sexo': _sexoSelecionado,
      'altura': _alturaController.text.trim(),
      'peso': _pesoController.text.trim(),
      'imc': _imcCalculado != null ? double.parse(_imcCalculado!.toStringAsFixed(1)) : null,
      'imcClassificacao': _imcClassificacao,
      'tipoSanguineo': _tipoSanguineoSelecionado,
      'cartaoSus': _cartaoSusController.text.trim(),
      'telefone': _telefoneController.text.trim(),
      'planoSaude': _planoController.text.trim(),
      'alergias': _alergiasController.text.trim(),
      'condicoesPreexistentes': _condicoesController.text.trim(),
      'contatoEmergencia': _emergenciaNomeController.text.trim(),
      'contatoEmergenciaTelefone': _emergenciaTelefoneController.text.trim(),
      'contatoEmergenciaParentesco': _emergenciaParentescoController.text.trim(),
      'medicamentos': _medicamentosController.text.trim(),
      'observacoes': _observacoesController.text.trim(),
    };

    try {
      await _auth.salvarFormulario(user.uid, dadosParaSalvar);

      if (!mounted) return;
      _exibirDialogoSucesso();
    } catch (e) {
      _showSnackbar('Erro ao salvar no servidor: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _exibirDialogoSucesso() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Formulário Concluído!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        content: const Text(
          'Suas informações médicas e gerais foram salvas com sucesso. Elas estarão sempre disponíveis na sua página de perfil!',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // fecha dialog
              Navigator.pop(context); // volta para a tela anterior
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Continuar',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red.shade700 : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF121B18) : Colors.grey.shade50;
    final cardBg = _isDarkMode ? const Color(0xFF1A2622) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : AppColors.textPrimary;
    final subtitleColor = _isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo-claro.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'MedTrack',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: _isDarkMode ? 'Modo Claro' : 'Modo Escuro',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                size: 20,
                color: Colors.white,
              ),
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
      body: _isFetchingInitialData
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderBanner(textColor, subtitleColor),
                      const SizedBox(height: 24),
                      _buildCardSection(
                        title: 'Dados Biométricos e Físicos',
                        icon: Icons.accessibility_new_outlined,
                        isExpanded: _expandDadosPessoais,
                        onToggle: () => setState(() => _expandDadosPessoais = !_expandDadosPessoais),
                        cardBg: cardBg,
                        textColor: textColor,
                        child: _buildDadosBiometricosContent(cardBg, textColor),
                      ),
                      const SizedBox(height: 16),
                      _buildCardSection(
                        title: 'Informações Médicas',
                        icon: Icons.favorite_border,
                        isExpanded: true,
                        cardBg: cardBg,
                        textColor: textColor,
                        child: _buildInformacoesMedicasContent(cardBg, textColor),
                      ),
                      const SizedBox(height: 16),
                      _buildCardSection(
                        title: 'Contatos de Emergência',
                        icon: Icons.contact_phone_outlined,
                        isExpanded: _expandContatosEmergencia,
                        onToggle: () => setState(() => _expandContatosEmergencia = !_expandContatosEmergencia),
                        cardBg: cardBg,
                        textColor: textColor,
                        child: _buildContatosEmergenciaContent(cardBg, textColor),
                      ),
                      const SizedBox(height: 16),
                      _buildCardSection(
                        title: 'Medicamentos',
                        icon: Icons.medication_outlined,
                        isExpanded: _expandMedicamentos,
                        onToggle: () => setState(() => _expandMedicamentos = !_expandMedicamentos),
                        cardBg: cardBg,
                        textColor: textColor,
                        child: _buildMedicamentosContent(cardBg, textColor),
                      ),
                      const SizedBox(height: 16),
                      _buildCardSection(
                        title: 'Observações Gerais',
                        icon: Icons.notes_outlined,
                        isExpanded: _expandObservacoes,
                        onToggle: () => setState(() => _expandObservacoes = !_expandObservacoes),
                        cardBg: cardBg,
                        textColor: textColor,
                        child: _buildObservacoesContent(cardBg, textColor),
                      ),
                      const SizedBox(height: 28),
                      _buildSubmitButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderBanner(Color textColor, Color subtitleColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF162520) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'PREENCHA O FORMULÁRIO',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontSpectral,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _nomeUsuario != null && _nomeUsuario!.isNotEmpty
                ? 'Olá, $_nomeUsuario! Preencha suas informações médicas.'
                : 'Seu espaço para cuidar da saúde.',
            style: TextStyle(
              fontFamily: AppTextStyles.fontMontserrat,
              fontSize: 14,
              color: subtitleColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (_nomeUsuario != null && _nomeUsuario!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Cadastro vinculado: $_nomeUsuario${_cpfUsuario != null && _cpfUsuario!.isNotEmpty ? ' (CPF: $_cpfUsuario)' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardSection({
    required String title,
    required IconData icon,
    required bool isExpanded,
    VoidCallback? onToggle,
    required Widget child,
    required Color cardBg,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isExpanded
              ? AppColors.primary.withValues(alpha: 0.25)
              : Colors.grey.withValues(alpha: 0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                    color: AppColors.primary,
                    size: 26,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontKarla,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (onToggle != null)
                    Text(
                      isExpanded ? 'Recolher' : 'Expandir',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(height: 1, color: Colors.grey.withValues(alpha: 0.15)),
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDadosBiometricosContent(Color cardBg, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Data de Nascimento', obrigatorio: true, textColor: textColor),
                  InkWell(
                    onTap: _selecionarDataNascimento,
                    child: IgnorePointer(
                      child: _buildTextInput(
                        controller: _dataNascimentoController,
                        hintText: 'dd/mm/aaaa',
                        icon: Icons.calendar_today_outlined,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Informe a data' : null,
                        cardBg: cardBg,
                        textColor: textColor,
                      ),
                    ),
                  ),
                  if (_idadeCalculada != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Idade: $_idadeCalculada anos',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Sexo', obrigatorio: true, textColor: textColor),
                  _buildDropdown(
                    value: _sexoSelecionado,
                    hint: 'Selecione',
                    items: _opcoesSexo,
                    onChanged: (val) => setState(() => _sexoSelecionado = val),
                    icon: Icons.wc_outlined,
                    cardBg: cardBg,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Altura (m)', obrigatorio: true, textColor: textColor),
                  _buildTextInput(
                    controller: _alturaController,
                    hintText: 'Ex: 1.75',
                    icon: Icons.height_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Informe a altura' : null,
                    cardBg: cardBg,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Peso (kg)', obrigatorio: true, textColor: textColor),
                  _buildTextInput(
                    controller: _pesoController,
                    hintText: 'Ex: 70',
                    icon: Icons.fitness_center_outlined,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Informe o peso' : null,
                    cardBg: cardBg,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_imcCalculado != null && _imcClassificacao != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.health_and_safety_outlined, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'IMC: ${_imcCalculado!.toStringAsFixed(1)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
                ),
                const SizedBox(width: 8),
                Text(
                  '($_imcClassificacao)',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Tipo Sanguíneo', obrigatorio: true, textColor: textColor),
                  _buildDropdown(
                    value: _tipoSanguineoSelecionado,
                    hint: 'Selecione',
                    items: _tiposSanguineos,
                    onChanged: (val) => setState(() => _tipoSanguineoSelecionado = val),
                    icon: Icons.bloodtype_outlined,
                    cardBg: cardBg,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Cartão SUS', obrigatorio: true, textColor: textColor),
                  _buildTextInput(
                    controller: _cartaoSusController,
                    hintText: 'Número do cartão',
                    icon: Icons.credit_card_outlined,
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.trim().isEmpty ? 'Informe o cartão SUS' : null,
                    cardBg: cardBg,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        _buildFieldLabel('Telefone / WhatsApp', obrigatorio: false, textColor: textColor),
        _buildTextInput(
          controller: _telefoneController,
          hintText: '(DD) 99999-9999',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          cardBg: cardBg,
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildInformacoesMedicasContent(Color cardBg, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Plano de Saúde / Convênio', obrigatorio: false, textColor: textColor),
        _buildTextInput(
          controller: _planoController,
          hintText: 'Ex: Unimed, Bradesco ou SUS',
          icon: Icons.local_hospital_outlined,
          cardBg: cardBg,
          textColor: textColor,
        ),
        const SizedBox(height: 14),

        _buildFieldLabel('Alergias Conhecidas', obrigatorio: false, textColor: textColor),
        _buildTextInput(
          controller: _alergiasController,
          hintText: 'Ex: Dipirona, penicilina, frutos do mar, pólen...',
          icon: Icons.warning_amber_rounded,
          maxLines: 2,
          cardBg: cardBg,
          textColor: textColor,
        ),
        const SizedBox(height: 14),

        _buildFieldLabel('Condições Preexistentes / Doenças Crônicas', obrigatorio: false, textColor: textColor),
        _buildTextInput(
          controller: _condicoesController,
          hintText: 'Ex: Hipertensão, Diabetes, Asma...',
          icon: Icons.medical_information_outlined,
          maxLines: 2,
          cardBg: cardBg,
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildContatosEmergenciaContent(Color cardBg, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Nome do Contato', obrigatorio: false, textColor: textColor),
        _buildTextInput(
          controller: _emergenciaNomeController,
          hintText: 'Ex: Maria da Silva',
          icon: Icons.person_add_alt_outlined,
          cardBg: cardBg,
          textColor: textColor,
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Parentesco / Relação', obrigatorio: false, textColor: textColor),
                  _buildTextInput(
                    controller: _emergenciaParentescoController,
                    hintText: 'Ex: Mãe, Irmão, Cônjuge',
                    icon: Icons.family_restroom_outlined,
                    cardBg: cardBg,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('Telefone de Emergência', obrigatorio: false, textColor: textColor),
                  _buildTextInput(
                    controller: _emergenciaTelefoneController,
                    hintText: '(DD) 99999-9999',
                    icon: Icons.phone_in_talk_outlined,
                    keyboardType: TextInputType.phone,
                    cardBg: cardBg,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMedicamentosContent(Color cardBg, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Medicamentos em Uso Contínuo', obrigatorio: false, textColor: textColor),
        _buildTextInput(
          controller: _medicamentosController,
          hintText: 'Liste seus medicamentos regulares (dosagem, horário)...',
          icon: Icons.healing_outlined,
          maxLines: 3,
          cardBg: cardBg,
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildObservacoesContent(Color cardBg, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Observações e Recomendações Adicionais', obrigatorio: false, textColor: textColor),
        _buildTextInput(
          controller: _observacoesController,
          hintText: 'Informações relevantes para socorristas ou equipe médica...',
          icon: Icons.edit_note_outlined,
          maxLines: 4,
          cardBg: cardBg,
          textColor: textColor,
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String text, {bool obrigatorio = false, required Color textColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: textColor,
            fontFamily: AppTextStyles.fontMontserrat,
          ),
          children: [
            if (obrigatorio)
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    required Color cardBg,
    required Color textColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(
        fontSize: 14.5,
        color: textColor,
        fontFamily: AppTextStyles.fontMontserrat,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary.withValues(alpha: 0.8), size: 20),
        filled: true,
        fillColor: _isDarkMode ? const Color(0xFF22322D) : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.withValues(alpha: 0.25),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: 1.2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red.shade700,
            width: 1.8,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    required Color cardBg,
    required Color textColor,
  }) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      initialValue: value,
      hint: Text(
        hint,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 20),
      dropdownColor: _isDarkMode ? const Color(0xFF1E2D28) : Colors.white,
      style: TextStyle(
        fontSize: 14,
        color: textColor,
        fontFamily: AppTextStyles.fontMontserrat,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primary.withValues(alpha: 0.8), size: 18),
        filled: true,
        fillColor: _isDarkMode ? const Color(0xFF22322D) : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.withValues(alpha: 0.25),
            width: 1.2,
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
      items: items.map((opt) {
        return DropdownMenuItem<String>(
          value: opt,
          child: Text(
            opt,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13.5),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _salvarFormulario,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_outlined, size: 22, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Salvar Informações',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}