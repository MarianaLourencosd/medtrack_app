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
        height: 54,
        padding: const EdgeInsets.only(left: 17, right: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: CoresApp.black.withValues(alpha: isDark ? 0.25 : 0.045),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: hintColor, size: 21),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'O que você procura?',
                style: TextStyle(fontSize: 13, color: hintColor),
              ),
            ),
            GestureDetector(
              onTap: () => _openSearch(context),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: CoresApp.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: CoresApp.white,
                  size: 20,
                ),
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

  const _BuscaItem({
    required this.label,
    required this.rota,
    required this.icon,
  });
}

class _BuscaInicioDelegate extends SearchDelegate<String> {
  final Function(String) onNavigate;

  _BuscaInicioDelegate({required this.onNavigate});

  static const List<_BuscaItem> _items = [
    _BuscaItem(label: 'Remédios', rota: 'Medicamentos', icon: Icons.medication_rounded),
    _BuscaItem(label: 'Minha saúde', rota: 'Informações', icon: Icons.favorite_rounded),
    _BuscaItem(label: 'Emergência', rota: 'Emergência', icon: Icons.emergency_rounded),
    _BuscaItem(label: 'Carteira', rota: 'Carteira', icon: Icons.badge_rounded),
    _BuscaItem(label: 'Medicamentos', rota: 'Medicamentos', icon: Icons.medication_rounded),
    _BuscaItem(label: 'Informações', rota: 'Informações', icon: Icons.description_rounded),
    _BuscaItem(label: 'Contatos rápidos', rota: 'Emergência', icon: Icons.emergency_rounded),
    _BuscaItem(label: 'Documentos', rota: 'Carteira', icon: Icons.badge_rounded),
    _BuscaItem(label: 'Perfil', rota: 'Perfil', icon: Icons.person_rounded),
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
    final itens = _items;
    if (query.isEmpty) return itens;
    final q = query.toLowerCase();
    return itens
        .where((item) => item.label.toLowerCase().contains(q))
        .toList();
  }

  Widget _buildList(BuildContext context, List<_BuscaItem> items) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emptyColor =
        isDark ? CoresApp.darkTextSecondary : CoresApp.textSecondary;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Nenhum resultado encontrado.',
            style: TextStyle(color: emptyColor),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: Icon(item.icon, color: CoresApp.primary),
          title: Text(item.label),
          onTap: () {
            close(context, item.label);
            onNavigate(item.rota);
          },
        );
      },
    );
  }
}