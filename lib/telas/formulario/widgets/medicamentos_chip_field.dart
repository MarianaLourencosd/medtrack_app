import 'package:flutter/material.dart';

import '../../../modelos/modelo_medicamento.dart';
import '../../../servicos/servico_medicamentos.dart';

/// Campo de medicamentos com autocomplete e chips para seleção múltipla.
///
/// - Busca na base da ANVISA via [ServicoMedicamentos]
/// - Adiciona medicamentos selecionados como chips removíveis
/// - Mantém o texto livre para dosagem/horário em cada chip
/// - Serializa tudo no [controller] como texto formatado
class MedicamentosChipField extends StatefulWidget {
  const MedicamentosChipField({
    super.key,
    required this.controller,
    required this.servico,
    this.label = 'Medicamentos em Uso Contínuo',
    this.hintText = 'Buscar e adicionar medicamentos...',
    this.icon = Icons.medication_outlined,
    this.maxChips = 10,
    this.cardBg,
    this.textColor,
    this.validator,
  });

  final TextEditingController controller;
  final ServicoMedicamentos servico;
  final String label;
  final String hintText;
  final IconData icon;
  final int maxChips;
  final Color? cardBg;
  final Color? textColor;
  final String? Function(String?)? validator;

  @override
  State<MedicamentosChipField> createState() => _MedicamentosChipFieldState();
}

class _MedicamentosChipFieldState extends State<MedicamentosChipField> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final List<_MedicamentoComDetalhes> _medicamentos = [];

  @override
  void initState() {
    super.initState();
    _parseControllerText();
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _focusNode.removeListener(_onFocusChange);
    _searchController.dispose();
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _parseControllerText() {
    final texto = widget.controller.text.trim();
    if (texto.isEmpty) return;

    // Tenta parsear formato: "Nome (Princípio) - Dosagem/Horário"
    final linhas = texto.split('\n');
    for (final linha in linhas) {
      final match = RegExp(r'^(.+?)\s*\((.+?)\)(?:\s*[-–]\s*(.+))?$').firstMatch(linha.trim());
      if (match != null) {
        _medicamentos.add(_MedicamentoComDetalhes(
          nome: match.group(1)!.trim(),
          principioAtivo: match.group(2)!.trim(),
          detalhes: match.group(3)?.trim() ?? '',
        ));
      } else if (linha.trim().isNotEmpty) {
        // Texto livre sem padrão reconhecido
        _medicamentos.add(_MedicamentoComDetalhes(
          nome: linha.trim(),
          principioAtivo: '',
          detalhes: '',
        ));
      }
    }
  }

  void _onSearchChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
    setState(() {}); // Rebuild para mostrar/esconder sugestões
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Pequeno delay para permitir clique no item da lista
      Future.delayed(const Duration(milliseconds: 150), _removeOverlay);
    } else {
      _showOverlay();
    }
    setState(() {});
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: size.width,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: _buildSuggestionsList(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildSuggestionsList() {
    final termo = _searchController.text.trim();
    if (termo.isEmpty) {
      return const SizedBox.shrink();
    }

    final sugestoes = widget.servico.buscar(termo);
    if (sugestoes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text('Nenhum medicamento encontrado', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: sugestoes.length,
      itemBuilder: (context, index) {
        final med = sugestoes[index];
        final jaAdicionado = _medicamentos.any((m) =>
            m.nome.toLowerCase() == med.nome.toLowerCase() &&
            m.principioAtivo.toLowerCase() == med.principioAtivo.toLowerCase());

        return ListTile(
          dense: true,
          leading: Icon(
            jaAdicionado ? Icons.check_circle : Icons.add_circle_outline,
            color: jaAdicionado ? Colors.green : Theme.of(context).colorScheme.primary,
            size: 22,
          ),
          title: Text(med.nome, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          subtitle: Text(med.principioAtivo, style: const TextStyle(fontSize: 12)),
          onTap: jaAdicionado ? null : () => _adicionarMedicamento(med),
          enabled: !jaAdicionado,
        );
      },
    );
  }

  void _adicionarMedicamento(Medicamento med) {
    if (_medicamentos.length >= widget.maxChips) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Máximo de ${widget.maxChips} medicamentos')),
      );
      return;
    }

    setState(() {
      _medicamentos.add(_MedicamentoComDetalhes(
        nome: med.nome,
        principioAtivo: med.principioAtivo,
        detalhes: '',
      ));
      _searchController.clear();
      _focusNode.unfocus();
      _atualizarController();
    });
  }

  void _removerMedicamento(int index) {
    setState(() {
      _medicamentos.removeAt(index);
      _atualizarController();
    });
  }

  void _editarDetalhes(int index) {
    final med = _medicamentos[index];
    final controller = TextEditingController(text: med.detalhes);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${med.nome} (${med.principioAtivo})'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Dosagem / Horário / Observações',
            hintText: 'Ex: 500mg 8/8h, após café da manhã',
          ),
          maxLines: 2,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              setState(() {
                _medicamentos[index] = _MedicamentoComDetalhes(
                  nome: med.nome,
                  principioAtivo: med.principioAtivo,
                  detalhes: controller.text.trim(),
                );
                _atualizarController();
              });
              Navigator.pop(ctx);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _atualizarController() {
    final buffer = StringBuffer();
    for (final m in _medicamentos) {
      buffer.write('${m.nome} (${m.principioAtivo})');
      if (m.detalhes.isNotEmpty) {
        buffer.write(' - ${m.detalhes}');
      }
      buffer.write('\n');
    }
    widget.controller.text = buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardBg = widget.cardBg ?? (theme.brightness == Brightness.dark ? const Color(0xFF22322D) : Colors.grey.shade50);
    final textColor = widget.textColor ?? theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),

        // Chips dos medicamentos adicionados
        if (_medicamentos.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _medicamentos.asMap().entries.map((entry) {
              final index = entry.key;
              final med = entry.value;
              return InputChip(
                label: Text(
                  med.nome,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                avatar: CircleAvatar(
                  radius: 10,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                onPressed: () => _editarDetalhes(index),
                onDeleted: () => _removerMedicamento(index),
                deleteIconColor: Colors.red.shade400,
                backgroundColor: cardBg,
                side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                tooltip: med.detalhes.isNotEmpty ? 'Toque para editar: ${med.detalhes}' : 'Toque para adicionar detalhes',
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
        ],

        // Campo de busca com autocomplete
        TextFormField(
          controller: _searchController,
          focusNode: _focusNode,
          style: TextStyle(fontSize: 14.5, color: textColor),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(widget.icon, color: theme.colorScheme.primary.withValues(alpha: 0.8), size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      _focusNode.unfocus();
                    },
                  )
                : null,
            filled: true,
            fillColor: cardBg,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.25), width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade700, width: 1.8),
            ),
          ),
          validator: widget.validator,
          onTapOutside: (_) => _focusNode.unfocus(),
        ),

        // Status da base + erro/loading
        ValueListenableBuilder<bool>(
          valueListenable: widget.servico.carregando,
          builder: (context, carregando, _) {
            return ValueListenableBuilder<String?>(
              valueListenable: widget.servico.erro,
              builder: (context, erro, _) {
                return ValueListenableBuilder<List<Medicamento>>(
                  valueListenable: widget.servico.medicamentos,
                  builder: (context, lista, _) {
                    if (carregando) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.primary),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Carregando base de medicamentos...',
                              style: TextStyle(fontSize: 11, color: theme.colorScheme.primary),
                            ),
                          ],
                        ),
                      );
                    }

                    if (erro != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, size: 12, color: Colors.red.shade400),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                erro,
                                style: TextStyle(fontSize: 11, color: Colors.red.shade400),
                              ),
                            ),
                            TextButton(
                              onPressed: () => widget.servico.inicializar(forcar: true),
                              child: const Text('Tentar novamente', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 12, color: Colors.green.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${lista.length} medicamentos na base da ANVISA',
                            style: TextStyle(fontSize: 11, color: Colors.green.shade600),
                          ),
                          if (_medicamentos.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${_medicamentos.length}/${widget.maxChips} selecionados',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

/// Medicamento com campo extra para detalhes (dosagem, horário, etc.)
class _MedicamentoComDetalhes {
  final String nome;
  final String principioAtivo;
  final String detalhes;

  _MedicamentoComDetalhes({
    required this.nome,
    required this.principioAtivo,
    required this.detalhes,
  });
}