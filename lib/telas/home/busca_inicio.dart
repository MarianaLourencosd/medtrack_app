import 'package:flutter/material.dart';

import '../../../constantes/cores.dart';

class BuscaInicio extends StatelessWidget {
  final Function(String) onNavigate;

  const BuscaInicio({super.key, required this.onNavigate});

  void _openSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: _BuscaInicioDelegate(onNavigate: onNavigate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? CoresApp.darkSurfaceAlt : CoresApp.surface;
    final border = isDark ? CoresApp.darkBorder : CoresApp.greyLight;
    final hintColor = isDark ? CoresApp.darkTextMuted : CoresApp.textMuted;

    return GestureDetector(
      onTap: () => _openSearch(context),
      child: Container(
        height: 58,
        padding: const EdgeInsets.only(left: 18, right: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: CoresApp.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: CoresApp.primaryDark.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.search_rounded, color: CoresApp.primaryDark, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Buscar',
                style: TextStyle(
                  fontSize: 14,
                  color: hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _openSearch(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: CoresApp.primaryDark,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: CoresApp.primaryDark.withValues(alpha: 0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: CoresApp.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuscaItem {
  final String label;
  final String rota;
  final IconData icon;
  final String categoria;

  const _BuscaItem({
    required this.label,
    required this.rota,
    required this.icon,
    required this.categoria,
  });
}

class _BuscaInicioDelegate extends SearchDelegate<String> {
  final Function(String) onNavigate;

  _BuscaInicioDelegate({required this.onNavigate});

  static const List<_BuscaItem> _items = [
    _BuscaItem(label: 'Remédios', rota: 'Medicamentos', icon: Icons.medication_rounded, categoria: 'Saúde'),
    _BuscaItem(label: 'Minha saúde', rota: 'Informações', icon: Icons.favorite_rounded, categoria: 'Saúde'),
    _BuscaItem(label: 'Emergência', rota: 'Emergência', icon: Icons.emergency_rounded, categoria: 'Urgência'),
    _BuscaItem(label: 'Contatos rápidos', rota: 'Emergência', icon: Icons.phone_in_talk_rounded, categoria: 'Urgência'),
    _BuscaItem(label: 'Carteira', rota: 'Carteira', icon: Icons.badge_rounded, categoria: 'Documentos'),
    _BuscaItem(label: 'Documentos', rota: 'Carteira', icon: Icons.folder_rounded, categoria: 'Documentos'),
    _BuscaItem(label: 'Informações', rota: 'Informações', icon: Icons.description_rounded, categoria: 'Saúde'),
    _BuscaItem(label: 'Perfil', rota: 'Perfil', icon: Icons.person_rounded, categoria: 'Conta'),
    _BuscaItem(label: 'Dicas', rota: 'Dicas', icon: Icons.lightbulb_rounded, categoria: 'Conteúdo'),
    _BuscaItem(label: 'Quiz', rota: 'Quiz', icon: Icons.quiz_rounded, categoria: 'Conteúdo'),
    _BuscaItem(label: 'IMC', rota: 'IMC', icon: Icons.fitness_center_rounded, categoria: 'Saúde'),
    _BuscaItem(label: 'Hospitais', rota: 'Hospitais', icon: Icons.local_hospital_rounded, categoria: 'Saúde'),
    _BuscaItem(label: 'Lembretes', rota: 'Lembretes', icon: Icons.notifications_rounded, categoria: 'Saúde'),
    _BuscaItem(label: 'Compartilhar', rota: 'Compartilhar', icon: Icons.share_rounded, categoria: 'Documentos'),
    _BuscaItem(label: 'PDF', rota: 'PDF', icon: Icons.picture_as_pdf_rounded, categoria: 'Documentos'),
    _BuscaItem(label: 'QR Code', rota: 'QR Code', icon: Icons.qr_code_rounded, categoria: 'Documentos'),
    _BuscaItem(label: 'Alergias', rota: 'Alergias', icon: Icons.healing_rounded, categoria: 'Saúde'),
    _BuscaItem(label: 'Tipo Sanguíneo', rota: 'Tipo Sanguíneo', icon: Icons.bloodtype_rounded, categoria: 'Saúde'),
    _BuscaItem(label: 'Plano de Saúde', rota: 'Plano de Saúde', icon: Icons.medical_services_rounded, categoria: 'Saúde'),
    _BuscaItem(label: 'Sobre', rota: 'Sobre', icon: Icons.info_rounded, categoria: 'Institucional'),
    _BuscaItem(label: 'Ajuda', rota: 'Ajuda', icon: Icons.help_rounded, categoria: 'Institucional'),
  ];

  @override
  String get searchFieldLabel => 'O que você procura?';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context, _filter());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context, _filter());
  }

  List<_BuscaItem> _filter() {
    if (query.isEmpty) return _items;
    final q = query.toLowerCase();
    return _items.where((item) => item.label.toLowerCase().contains(q)).toList();
  }

  Widget _buildList(BuildContext context, List<_BuscaItem> items) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emptyColor = isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: CoresApp.primaryDark.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_off_rounded, color: CoresApp.primaryDark, size: 30),
              ),
              const SizedBox(height: 14),
              Text(
                'Nenhum resultado encontrado',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: emptyColor),
              ),
              const SizedBox(height: 4),
              Text(
                'Tente buscar por outro termo',
                style: TextStyle(fontSize: 12, color: emptyColor),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                close(context, item.label);
                onNavigate(item.rota);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? CoresApp.darkSurface : CoresApp.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? CoresApp.darkBorder : CoresApp.greyLight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: CoresApp.primaryDark.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(item.icon, color: CoresApp.primaryDark, size: 21),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: isDark ? CoresApp.darkTextPrimary : CoresApp.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.categoria,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? CoresApp.darkTextMuted : CoresApp.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: CoresApp.primaryDark.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward_rounded, color: CoresApp.primaryDark, size: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}