import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constantes/cores.dart';
import '../../constantes/estilos_texto.dart';
import '../../modelos/hospital.dart';
import '../../servicos/servico_hospitais.dart';

class TelaEmergencia extends StatefulWidget {
  const TelaEmergencia({super.key});

  @override
  State<TelaEmergencia> createState() => _TelaEmergenciaState();
}

class _TelaEmergenciaState extends State<TelaEmergencia> {
  final ServicoHospitais _servico = ServicoHospitais();
  final MapController _mapController = MapController();

  List<Map<String, dynamic>> _unidades = [];
  bool _carregandoUnidades = true;
  String? _erroLocalizacao;
  String _filtroAtivo = 'Todos';
  bool _mostrarMapa = true;

  final List<Hospital> _hospitaisLocais = [
    Hospital(
      nome: 'Hospital Municipal de Matão',
      endereco: 'R. Sinharinha Frota, 556 - Centro, Matão - SP',
      latitude: -21.605805,
      longitude: -48.367888,
      tipo: 'Hospital',
    ),
    Hospital(
      nome: 'UBS Bairro Alto',
      endereco: 'R. Pedro Bigal, 1530 - Bairro Alto, Matão - SP',
      latitude: -21.592726,
      longitude: -48.360679,
      tipo: 'UBS',
    ),
    Hospital(
      nome: 'USF Jardim Popular',
      endereco: 'R. Pedro Trolli, 3700 - Portal Terra da Saudade, Matão - SP',
      latitude: -21.589079,
      longitude: -48.342838,
      tipo: 'USF',
    ),
    Hospital(
      nome: 'PSF Parque Aliança',
      endereco: 'Parque Aliança, Matão - SP',
      latitude: -21.584453,
      longitude: -48.371650,
      tipo: 'USF',
    ),
    Hospital(
      nome: 'UBS Las Lomas',
      endereco: 'Las Lomas, Matão - SP',
      latitude: -21.614364,
      longitude: -48.356420,
      tipo: 'UBS',
    ),
    Hospital(
      nome: 'UBS Jardim São José',
      endereco: 'Jardim São José, Matão - SP',
      latitude: -21.589445,
      longitude: -48.377347,
      tipo: 'UBS',
    ),
    Hospital(
      nome: 'UBS São Lourenço do Turvo',
      endereco: 'São Lourenço do Turvo, Matão - SP',
      latitude: -21.549764,
      longitude: -48.533625,
      tipo: 'UBS',
    ),
    Hospital(
      nome: 'PSF Bom Jesus',
      endereco: 'Bom Jesus, Matão - SP',
      latitude: -21.601533,
      longitude: -48.391162,
      tipo: 'USF',
    ),
    Hospital(
      nome: 'PSF Jardim Popular',
      endereco: 'Jardim Popular, Matão - SP',
      latitude: -21.589089,
      longitude: -48.342796,
      tipo: 'USF',
    ),
    Hospital(
      nome: 'UBS Vila Pereira',
      endereco: 'Vila Pereira, Matão - SP',
      latitude: -21.601477,
      longitude: -48.380709,
      tipo: 'UBS',
    ),
    Hospital(
      nome: 'PSF Assentamento Horto Silvânia e Paraíso',
      endereco: 'Paraíso, Matão - SP',
      latitude: -21.640024,
      longitude: -48.294306,
      tipo: 'USF',
    ),
    Hospital(
      nome: 'UBS Jardim Paraíso',
      endereco: 'Jardim Paraíso, Matão - SP',
      latitude: -21.630811,
      longitude: -48.340418,
      tipo: 'UBS',
    ),
    Hospital(
      nome: 'UBS IV Centenário',
      endereco: 'IV Centenário, Matão - SP',
      latitude: -21.607242,
      longitude: -48.354217,
      tipo: 'UBS',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _carregarUnidades();
  }

  Future<void> _carregarUnidades() async {
    try {
      final resultado = await _servico.hospitaisProximos();
      if (mounted) {
        setState(() {
          _unidades = resultado;
          _carregandoUnidades = false;
          _erroLocalizacao = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _unidades = _hospitaisLocais
              .map((h) => {'hospital': h, 'distancia': 0.0})
              .toList();
          _erroLocalizacao = null;
          _carregandoUnidades = false;
        });
      }
    }
  }

  Future<void> _abrirMapa(double latitude, double longitude) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> _ligar(String numero) async {
    final uri = Uri.parse('tel:$numero');
    try {
      await launchUrl(uri);
    } catch (_) {}
  }

  String _formatarDistancia(double metros) {
    if (metros <= 0) return '—';
    if (metros < 1000) return '${metros.toStringAsFixed(0)} m';
    return '${(metros / 1000).toStringAsFixed(1)} km';
  }

  List<Map<String, dynamic>> get _unidadesFiltradas {
    if (_filtroAtivo == 'Todos') return _unidades;
    return _unidades
        .where((item) => (item['hospital'] as Hospital).tipo == _filtroAtivo)
        .toList();
  }

  int get _totalHospitais => _unidades
      .where((item) => (item['hospital'] as Hospital).tipo == 'Hospital')
      .length;

  int get _totalUbs => _unidades
      .where((item) {
        final tipo = (item['hospital'] as Hospital).tipo;
        return tipo == 'UBS' || tipo == 'USF';
      })
      .length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CoresApp.darkBackground : CoresApp.background;
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'Emergência',
          style: AppTextStyles.tituloTela.copyWith(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => setState(() => _mostrarMapa = !_mostrarMapa),
            icon: Icon(
              _mostrarMapa ? Icons.map_rounded : Icons.map_outlined,
              color: Colors.white,
            ),
            tooltip: _mostrarMapa ? 'Ocultar mapa' : 'Mostrar mapa',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBannerEmergencia(context, tituloColor, subtituloColor),
              const SizedBox(height: 18),
              _buildBotoesEmergencia(context),
              const SizedBox(height: 22),
              _buildResumoUnidades(context),
              const SizedBox(height: 22),
              if (_mostrarMapa) ...[
                _buildMapa(context),
                const SizedBox(height: 22),
              ],
              _buildSecaoUnidades(context, tituloColor, subtituloColor),
              const SizedBox(height: 22),
              Text(
                'Meus dados de emergência',
                style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
              ),
              const SizedBox(height: 4),
              Text(
                'Informações que podem salvar sua vida',
                style: AppTextStyles.subtituloSecao
                    .copyWith(color: subtituloColor),
              ),
              const SizedBox(height: 14),
              _buildCardPlano(context),
              const SizedBox(height: 10),
              _buildCardTipoSanguineo(context),
              const SizedBox(height: 10),
              _buildCardAlergias(context),
              const SizedBox(height: 10),
              _buildCardContatoEmergencia(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerEmergencia(
    BuildContext context,
    Color tituloColor,
    Color subtituloColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? CoresApp.error.withValues(alpha: 0.15)
        : CoresApp.softRed;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CoresApp.error.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: CoresApp.error.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.emergency_rounded,
                color: CoresApp.error, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Em caso de emergência',
                  style: AppTextStyles.textoCorpoForte
                      .copyWith(fontSize: 14, color: tituloColor),
                ),
                const SizedBox(height: 2),
                Text(
                  'Mantenha a calma e ligue imediatamente',
                  style: AppTextStyles.micro
                      .copyWith(fontSize: 12, color: subtituloColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotoesEmergencia(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _botaoLigar(
            context: context,
            icone: Icons.local_hospital_rounded,
            cor: CoresApp.error,
            titulo: 'SAMU',
            subtitulo: '192',
            descricao: 'Ambulância',
            onTap: () => _ligar('192'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _botaoLigar(
            context: context,
            icone: Icons.contact_phone_rounded,
            cor: CoresApp.primary,
            titulo: 'Contato',
            subtitulo: '190',
            descricao: 'Emergência',
            onTap: () => _ligar('190'),
          ),
        ),
      ],
    );
  }

  Widget _botaoLigar({
    required BuildContext context,
    required IconData icone,
    required Color cor,
    required String titulo,
    required String subtitulo,
    required String descricao,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(Espacamentos.bordaNormal),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(Espacamentos.paddingCardPequeno),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(Espacamentos.bordaNormal),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cor.withValues(alpha: 0.12),
                      borderRadius:
                          BorderRadius.circular(Espacamentos.bordaMedia),
                    ),
                    child: Icon(icone, color: cor, size: 22),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Espacamentos.pequeno, vertical: 3),
                    decoration: BoxDecoration(
                      color: cor.withValues(alpha: 0.12),
                      borderRadius:
                          BorderRadius.circular(Espacamentos.bordaRedonda),
                    ),
                    child: Icon(Icons.phone_rounded, color: cor, size: 13),
                  ),
                ],
              ),
              const SizedBox(height: Espacamentos.pequeno),
              Text(
                titulo,
                style: AppTextStyles.textoCorpoForte
                    .copyWith(fontSize: 14, color: tituloColor),
              ),
              const SizedBox(height: 2),
              Text(
                descricao,
                style: AppTextStyles.micro
                    .copyWith(fontSize: 10.5, color: subtituloColor),
              ),
              const SizedBox(height: Espacamentos.micro),
              Text(
                subtitulo,
                style: AppTextStyles.kpiCardClaro
                    .copyWith(fontSize: 18, color: cor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumoUnidades(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _miniStat(
            context: context,
            icone: Icons.local_hospital_rounded,
            cor: CoresApp.error,
            valor: '$_totalHospitais',
            rotulo: 'Hospitais',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _miniStat(
            context: context,
            icone: Icons.health_and_safety_rounded,
            cor: CoresApp.primary,
            valor: '$_totalUbs',
            rotulo: 'UBS / USF',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _miniStat(
            context: context,
            icone: Icons.location_on_rounded,
            cor: CoresApp.info,
            valor: '${_unidades.length}',
            rotulo: 'Total',
          ),
        ),
      ],
    );
  }

  Widget _miniStat({
    required BuildContext context,
    required IconData icone,
    required Color cor,
    required String valor,
    required String rotulo,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: Espacamentos.medio, horizontal: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(Espacamentos.bordaNormal),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(icone, color: cor, size: 20),
          const SizedBox(height: Espacamentos.micro + 2),
          Text(
            valor,
            style: AppTextStyles.kpiCardClaro
                .copyWith(fontSize: 18, color: tituloColor),
          ),
          const SizedBox(height: 2),
          Text(
            rotulo,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro
                .copyWith(fontSize: 10, color: subtituloColor),
          ),
        ],
      ),
    );
  }

  Widget _buildMapa(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;

    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(Espacamentos.bordaNormal),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-21.6034, -48.3666),
              initialZoom: 13,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.medtrack_app',
              ),
              MarkerLayer(
                markers: _unidades.map((item) {
                  final Hospital h = item['hospital'] as Hospital;
                  final bool isHospital = h.tipo == 'Hospital';
                  return Marker(
                    point: LatLng(h.latitude, h.longitude),
                    width: 40,
                    height: 40,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () => _abrirMapa(h.latitude, h.longitude),
                      child: Icon(
                        isHospital
                            ? Icons.local_hospital_rounded
                            : Icons.health_and_safety_rounded,
                        color: isHospital ? CoresApp.error : CoresApp.primary,
                        size: 30,
                      ),
                    ),
                  );
                }).toList(),
              ),
              CurrentLocationLayer(),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(Espacamentos.bordaPequena),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_rounded,
                      size: 14, color: CoresApp.primary),
                  const SizedBox(width: Espacamentos.micro),
                  Text(
                    '${_unidades.length} unidades',
                    style: AppTextStyles.micro.copyWith(
                      fontSize: 11,
                      color: isDark
                          ? CoresApp.darkTextPrimary
                          : CoresApp.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                if (_unidades.isNotEmpty) {
                  final h = _unidades.first['hospital'] as Hospital;
                  _mapController.move(
                    LatLng(h.latitude, h.longitude),
                    14,
                  );
                }
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: cardColor.withValues(alpha: 0.90),
                  borderRadius:
                      BorderRadius.circular(Espacamentos.bordaPequena),
                  border: Border.all(color: borderColor),
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  color: CoresApp.primary,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecaoUnidades(
    BuildContext context,
    Color tituloColor,
    Color subtituloColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Unidades próximas',
                style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: CoresApp.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(Espacamentos.bordaRedonda),
              ),
              child: Text(
                '${_unidadesFiltradas.length}',
                style: AppTextStyles.chip.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: Espacamentos.micro),
        Text(
          'Toque para ver no mapa',
          style:
              AppTextStyles.subtituloSecao.copyWith(color: subtituloColor),
        ),
        const SizedBox(height: Espacamentos.medio),
        _buildFiltros(),
        const SizedBox(height: Espacamentos.pequeno),
        _buildListaUnidades(context, tituloColor, subtituloColor),
      ],
    );
  }

  Widget _buildFiltros() {
    final filtros = ['Todos', 'Hospital', 'UBS', 'USF'];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inativoBg = isDark
        ? CoresApp.primary.withValues(alpha: 0.18)
        : CoresApp.primary.withValues(alpha: 0.10);
    final inativoTexto = isDark ? CoresApp.secondaryLight : CoresApp.primary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filtros.map((filtro) {
          final ativo = _filtroAtivo == filtro;
          return Padding(
            padding: const EdgeInsets.only(right: Espacamentos.pequeno),
            child: GestureDetector(
              onTap: () => setState(() => _filtroAtivo = filtro),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: Espacamentos.normal, vertical: 9),
                decoration: BoxDecoration(
                  color: ativo ? CoresApp.primary : inativoBg,
                  borderRadius:
                      BorderRadius.circular(Espacamentos.bordaRedonda),
                  border: Border.all(
                    color: ativo
                        ? CoresApp.primary
                        : inativoTexto.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (ativo) ...[
                      const Icon(Icons.check_rounded,
                          size: 13, color: Colors.white),
                      const SizedBox(width: Espacamentos.micro),
                    ],
                    Text(
                      filtro,
                      style: AppTextStyles.chip.copyWith(
                        fontSize: 13,
                        color: ativo ? Colors.white : inativoTexto,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildListaUnidades(
    BuildContext context,
    Color tituloColor,
    Color subtituloColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;

    if (_carregandoUnidades) {
      return Container(
        padding: const EdgeInsets.all(Espacamentos.grande),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(Espacamentos.bordaNormal),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(width: Espacamentos.normal - 2),
            Text(
              'Buscando sua localização...',
              style: AppTextStyles.micro
                  .copyWith(fontSize: 13, color: subtituloColor),
            ),
          ],
        ),
      );
    }

    if (_erroLocalizacao != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Espacamentos.normal),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(Espacamentos.bordaNormal),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            const Icon(Icons.location_off_rounded,
                color: CoresApp.error, size: 32),
            const SizedBox(height: 10),
            Text(
              'Não foi possível pegar sua localização',
              textAlign: TextAlign.center,
              style: AppTextStyles.textoCorpoForte
                  .copyWith(fontSize: 13.5, color: tituloColor),
            ),
            const SizedBox(height: Espacamentos.micro),
            Text(
              _erroLocalizacao ?? '',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro
                  .copyWith(fontSize: 11.5, color: subtituloColor),
            ),
            const SizedBox(height: Espacamentos.medio),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _carregandoUnidades = true;
                  _erroLocalizacao = null;
                });
                _carregarUnidades();
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Tentar de novo'),
            ),
          ],
        ),
      );
    }

    final lista = _unidadesFiltradas;
    if (lista.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Espacamentos.normal),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(Espacamentos.bordaNormal),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, color: subtituloColor, size: 28),
            const SizedBox(height: Espacamentos.pequeno),
            Text(
              'Nenhuma unidade encontrada para esse filtro',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro
                  .copyWith(fontSize: 13, color: subtituloColor),
            ),
          ],
        ),
      );
    }

    return Column(
      children: lista.map((item) {
        final Hospital h = item['hospital'] as Hospital;
        final double dist = item['distancia'] as double;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _cardUnidade(
            context: context,
            hospital: h,
            distancia: _formatarDistancia(dist),
            perto: dist > 0 && dist < 1500,
            tituloColor: tituloColor,
            subtituloColor: subtituloColor,
          ),
        );
      }).toList(),
    );
  }

  Widget _cardUnidade({
    required BuildContext context,
    required Hospital hospital,
    required String distancia,
    required bool perto,
    required Color tituloColor,
    required Color subtituloColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;

    final bool isHospital = hospital.tipo == 'Hospital';
    final IconData icone = isHospital
        ? Icons.local_hospital_rounded
        : Icons.health_and_safety_rounded;
    final Color corIcone = isHospital ? CoresApp.error : CoresApp.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(Espacamentos.bordaNormal),
        onTap: () => _abrirMapa(hospital.latitude, hospital.longitude),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Espacamentos.paddingCardPequeno),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(Espacamentos.bordaNormal),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: corIcone.withValues(alpha: 0.12),
                      borderRadius:
                          BorderRadius.circular(Espacamentos.bordaMedia),
                    ),
                    child: Icon(icone, color: corIcone, size: 22),
                  ),
                  const SizedBox(width: Espacamentos.medio),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hospital.nome,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.textoCorpoForte
                              .copyWith(fontSize: 13, color: tituloColor),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          hospital.endereco,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro
                              .copyWith(fontSize: 10.5, color: subtituloColor),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.map_rounded,
                      color: CoresApp.primary, size: 20),
                ],
              ),
              const SizedBox(height: Espacamentos.pequeno + 2),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Espacamentos.pequeno, vertical: 3),
                    decoration: BoxDecoration(
                      color: (perto ? CoresApp.success : subtituloColor)
                          .withValues(alpha: 0.12),
                      borderRadius:
                          BorderRadius.circular(Espacamentos.bordaRedonda),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.near_me_rounded,
                          size: 11,
                          color: perto ? CoresApp.success : subtituloColor,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          distancia,
                          style: AppTextStyles.chip.copyWith(
                            fontSize: 10.5,
                            color: perto ? CoresApp.success : subtituloColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Espacamentos.micro + 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Espacamentos.pequeno, vertical: 3),
                    decoration: BoxDecoration(
                      color: corIcone.withValues(alpha: 0.12),
                      borderRadius:
                          BorderRadius.circular(Espacamentos.bordaRedonda),
                    ),
                    child: Text(
                      hospital.tipo,
                      style: AppTextStyles.chip
                          .copyWith(fontSize: 9.5, color: corIcone),
                    ),
                  ),
                  const Spacer(),
                  if (perto)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Espacamentos.pequeno, vertical: 3),
                      decoration: BoxDecoration(
                        color: CoresApp.success.withValues(alpha: 0.12),
                        borderRadius:
                            BorderRadius.circular(Espacamentos.bordaRedonda),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt_rounded,
                              size: 11, color: CoresApp.success),
                          const SizedBox(width: 2),
                          Text(
                            'Perto',
                            style: AppTextStyles.chip.copyWith(
                                fontSize: 9.5, color: CoresApp.success),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPlano(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textoColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return _cardBase(
      context: context,
      icon: Icons.medical_services_rounded,
      iconColor: CoresApp.info,
      iconBg: CoresApp.info.withValues(alpha: 0.15),
      titulo: 'Plano de saúde',
      child: Padding(
        padding: const EdgeInsets.only(top: Espacamentos.pequeno),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Unimed',
              style: AppTextStyles.textoCorpoForte
                  .copyWith(fontSize: 15, color: textoColor),
            ),
            const SizedBox(height: 2),
            Text(
              'Carteira 12345 — Cobertura nacional',
              style: AppTextStyles.micro
                  .copyWith(fontSize: 11.5, color: subtituloColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTipoSanguineo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtituloColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return _cardBase(
      context: context,
      icon: Icons.bloodtype_rounded,
      iconColor: CoresApp.error,
      iconBg: CoresApp.error.withValues(alpha: 0.15),
      titulo: 'Tipo sanguíneo',
      child: Padding(
        padding: const EdgeInsets.only(top: Espacamentos.pequeno),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Espacamentos.paddingCardPequeno,
                vertical: Espacamentos.pequeno,
              ),
              decoration: BoxDecoration(
                color: CoresApp.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Espacamentos.bordaMedia),
              ),
              child: Text(
                'O+',
                style: AppTextStyles.kpiCardClaro.copyWith(
                  fontSize: 22,
                  color: CoresApp.error,
                ),
              ),
            ),
            const SizedBox(width: Espacamentos.medio),
            Expanded(
              child: Text(
                'Doador universal de hemácias',
                style: AppTextStyles.micro.copyWith(
                  fontSize: 11.5,
                  color: subtituloColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardAlergias(BuildContext context) {
    final alergias = ['Dipirona', 'Penicilina', 'Frutos do mar'];

    return _cardBase(
      context: context,
      icon: Icons.warning_amber_rounded,
      iconColor: CoresApp.warning,
      iconBg: CoresApp.warning.withValues(alpha: 0.15),
      titulo: 'Alergias',
      child: Padding(
        padding: const EdgeInsets.only(top: Espacamentos.pequeno),
        child: Wrap(
          spacing: Espacamentos.micro + 2,
          runSpacing: Espacamentos.micro + 2,
          children: alergias.map((a) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: CoresApp.warning.withValues(alpha: 0.12),
                borderRadius:
                    BorderRadius.circular(Espacamentos.bordaRedonda),
              ),
              child: Text(
                a,
                style: AppTextStyles.chip.copyWith(
                  fontSize: 11,
                  color: CoresApp.warning,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCardContatoEmergencia(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textoColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;
    final subtituloColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    return _cardBase(
      context: context,
      icon: Icons.contact_emergency_rounded,
      iconColor: CoresApp.secondary,
      iconBg: CoresApp.secondary.withValues(alpha: 0.15),
      titulo: 'Contato de emergência',
      child: Padding(
        padding: const EdgeInsets.only(top: Espacamentos.pequeno),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: CoresApp.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Espacamentos.bordaMedia),
              ),
              child: Center(
                child: Text(
                  'MS',
                  style: AppTextStyles.chip.copyWith(
                    fontSize: 13,
                    color: CoresApp.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: Espacamentos.medio),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maria Silva',
                    style: AppTextStyles.textoCorpoForte.copyWith(
                      fontSize: 13.5,
                      color: textoColor,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Mãe — (16) 99999-0000',
                    style: AppTextStyles.micro.copyWith(
                      fontSize: 11,
                      color: subtituloColor,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(Espacamentos.bordaRedonda),
                onTap: () => _ligar('16999990000'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: CoresApp.success.withValues(alpha: 0.12),
                    borderRadius:
                        BorderRadius.circular(Espacamentos.bordaRedonda),
                  ),
                  child: const Icon(
                    Icons.phone_rounded,
                    color: CoresApp.success,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardBase({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String titulo,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? CoresApp.darkSurface : CoresApp.surface;
    final borderColor = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
    final tituloColor =
        isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Espacamentos.normal),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(Espacamentos.grande),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(Espacamentos.bordaMedia),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: Espacamentos.medio),
              Text(
                titulo,
                style: AppTextStyles.textoCorpoForte.copyWith(
                  fontSize: 13.5,
                  color: tituloColor,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}