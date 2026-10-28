import 'package:flutter/material.dart';

import '../../modelos/modelo_medicamento.dart';
import '../../servicos/servico_medicamentos.dart';

/// Exemplo de tela de busca de medicamentos usando [Autocomplete] nativo
/// com [ValueNotifier] para gerenciamento de estado reativo.
///
/// Demonstra:
/// - Inicialização do serviço no initState
/// - ListenableBuilder para UI reativa sem setState manual
/// - Autocomplete com display customizado (nome + princípio ativo)
/// - Feedback visual de carregamento e erro
/// - Botão para forçar atualização OTA
class TelaBuscaMedicamentos extends StatefulWidget {
  const TelaBuscaMedicamentos({super.key});

  @override
  State<TelaBuscaMedicamentos> createState() => _TelaBuscaMedicamentosState();
}

class _TelaBuscaMedicamentosState extends State<TelaBuscaMedicamentos> {
  final _servico = ServicoMedicamentos();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _servico.inicializar();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _servico.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Medicamento'),
        actions: [
          // Botão para forçar atualização OTA
          ValueListenableBuilder<bool>(
            valueListenable: _servico.atualizando,
            builder: (_, atualizando, _) => IconButton(
              tooltip: 'Verificar atualização da base',
              onPressed: atualizando ? null : _forcarAtualizacao,
              icon: atualizando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_download_outlined),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _servico.carregando,
        builder: (context, carregando, _) {
          if (carregando) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<String?>(
            valueListenable: _servico.erro,
            builder: (context, erro, _) {
              if (erro != null) {
                return _buildErro(erro);
              }

              return _buildAutocomplete();
            },
          );
        },
      ),
    );
  }

  Widget _buildErro(String mensagem) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar medicamentos',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _servico.inicializar(),
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutocomplete() {
    return Column(
      children: [
        // Barra de busca com contador
        ValueListenableBuilder<List<Medicamento>>(
          valueListenable: _servico.medicamentos,
          builder: (context, lista, _) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.medication_outlined, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${lista.length} medicamentos na base',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            );
          },
        ),

        // Autocomplete nativo do Flutter
        Autocomplete<Medicamento>(
          // Controller para permitir limpar programaticamente
          initialValue: TextEditingValue.empty,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            // Sincroniza com nosso controller/focus para controle externo se necessário
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Digite nome ou princípio ativo...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) => value.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => controller.clear(),
                        )
                      : const SizedBox.shrink(),
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) => onFieldSubmitted(),
              textInputAction: TextInputAction.search,
            );
          },

          // Fornece as opções filtradas baseado no input do usuário
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.trim().isEmpty) {
              return const Iterable<Medicamento>.empty();
            }
            return _servico.autocomplete(textEditingValue.text);
          },

          // Como exibir cada opção na lista dropdown
          displayStringForOption: (medicamento) => medicamento.displayString,

          // Widget customizado para cada item da lista
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final medicamento = options.elementAt(index);
                      return _OptionTile(
                        medicamento: medicamento,
                        onTap: () => onSelected(medicamento),
                      );
                    },
                  ),
                ),
              ),
            );
          },

          // Callback quando usuário seleciona um medicamento
          onSelected: (medicamento) {
            _onMedicamentoSelecionado(medicamento);
          },
        ),
      ],
    );
  }

  Future<void> _forcarAtualizacao() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final atualizou = await _servico.forcarAtualizacao();

    if (!mounted) return;

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(atualizou
            ? 'Base de medicamentos atualizada!'
            : 'Base já está na versão mais recente.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onMedicamentoSelecionado(Medicamento medicamento) {
    _mostrarDetalhes(medicamento);
  }

  void _mostrarDetalhes(Medicamento medicamento) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medication, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        medicamento.nome,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Princípio Ativo',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  medicamento.principioAtivo,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tile customizado para exibição no dropdown do Autocomplete.
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.medicamento,
    required this.onTap,
  });

  final Medicamento medicamento;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicamento.nome,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              medicamento.principioAtivo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}