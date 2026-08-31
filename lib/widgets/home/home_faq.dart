import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class HomeFAQ extends StatefulWidget {
  const HomeFAQ({super.key});

  @override
  State<HomeFAQ> createState() => _HomeFAQState();
}

class _HomeFAQState extends State<HomeFAQ> {
  int _expandedIndex = -1;

  final List<Map<String, String>> _faqs = [
    {'q': 'O que é o MedTrack?', 'a': 'É uma carteira digital de saúde que armazena seus dados médicos com segurança.'},
    {'q': 'Como faço para cadastrar?', 'a': 'Clique em "Cadastro" no menu e preencha seus dados.'},
    {'q': 'Meus dados são seguros?', 'a': 'Sim, usamos criptografia e proteção de dados.'},
    {'q': 'Posso compartilhar meus dados?', 'a': 'Sim, você pode compartilhar via QR Code ou PDF.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.question_mark,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Perguntas Frequentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_faqs.length} perguntas',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...List.generate(_faqs.length, (index) {
              return _buildItem(index, _faqs[index]['q']!, _faqs[index]['a']!);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index, String question, String answer) {
    final isExpanded = _expandedIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isExpanded 
            ? AppColors.primary.withValues(alpha: 0.04) 
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded 
              ? AppColors.primary.withValues(alpha: 0.2) 
              : Colors.grey.shade200,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedIndex = expanded ? index : -1;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          title: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isExpanded 
                      ? AppColors.primary 
                      : AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isExpanded ? Icons.remove : Icons.add,
                  color: isExpanded ? Colors.white : AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    fontWeight: isExpanded ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                    color: isExpanded ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        answer,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}