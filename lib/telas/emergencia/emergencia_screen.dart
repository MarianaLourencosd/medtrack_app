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
          _erroLocalizacao = e.toString().replaceFirst('Exception: ', '');
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

  String _formatarDistancia(double metros) {
    if (metros < 1000) return '${metros.toStringAsFixed(0)} m';
    return '${(metros / 1000).toStringAsFixed(1)} km';
  }

  List<Map<String, dynamic>> get _unidadesFiltradas {
    if (_filtroAtivo == 'Todos') return _unidades;
    return _unidades
        .where((item) => (item['hospital'] as Hospital).tipo == _filtroAtivo)
        .toList();
  }

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
        title: const Text(
          'Emergência',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMapa(context),
              const SizedBox(height: 22),
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
            ],
          ),
        ),
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
        borderRadius: BorderRadius.circular(18),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: 0.90),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color: CoresApp.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_unidades.length} unidades',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? CoresApp.darkTextPrimary
                          : CoresApp.textPrimary,
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

  Widget _buildSecaoUnidades(
    BuildContext context,
    Color tituloColor,
    Color subtituloColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unidades próximas',
          style: AppTextStyles.tituloSecao.copyWith(color: tituloColor),
        ),
        const SizedBox(height: 4),
        Text(
          'Toque para ver no mapa',
          style:
              AppTextStyles.subtituloSecao.copyWith(color: subtituloColor),
        ),
        const SizedBox(height: 12),
        _buildFiltros(),
        const SizedBox(height: 8),
        _buildListaUnidades(context, tituloColor, subtituloColor),
      ],
    );
  }

  Widget _buildFiltros() {
    final filtros = ['Todos', 'Hospital', 'UBS', 'USF'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filtros.map((filtro) {
          final ativo = _filtroAtivo == filtro;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _filtroAtivo = filtro),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: ativo
                      ? CoresApp.primary
                      : CoresApp.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  filtro,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: ativo ? Colors.white : CoresApp.primary,
                  ),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(width: 14),
            Text(
              'Buscando sua localização...',
              style: TextStyle(fontSize: 13, color: subtituloColor),
            ),
          ],
        ),
      );
    }

    if (_erroLocalizacao != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
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
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: tituloColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _erroLocalizacao ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: subtituloColor),
            ),
            const SizedBox(height: 12),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          'Nenhuma unidade encontrada para esse filtro',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: subtituloColor),
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
            perto: dist < 1500,
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
        borderRadius: BorderRadius.circular(18),
        onTap: () => _abrirMapa(hospital.latitude, hospital.longitude),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: corIcone.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icone, color: corIcone, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.nome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: tituloColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hospital.endereco,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: subtituloColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.near_me_rounded,
                          size: 12,
                          color: perto ? CoresApp.success : subtituloColor,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          distancia,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color:
                                perto ? CoresApp.success : subtituloColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 1),
                          decoration: BoxDecoration(
                            color: corIcone.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            hospital.tipo,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: corIcone,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.map_rounded,
                color: CoresApp.primary,
                size: 20,
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

    return _cardBase(
      context: context,
      icon: Icons.medical_services_rounded,
      iconColor: CoresApp.info,
      iconBg: CoresApp.info.withValues(alpha: 0.15),
      titulo: 'Plano de saúde',
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          'Unimed — Carteira 12345',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: textoColor,
          ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
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