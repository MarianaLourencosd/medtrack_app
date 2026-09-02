import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/colors.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _alergiasController = TextEditingController();
  final TextEditingController _planoController = TextEditingController();
  final TextEditingController _emergenciaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _salvar() async {
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackbar('Usuário não logado!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .update({
        'telefone': _telefoneController.text.trim(),
        'tipoSanguineo': _bloodTypeController.text.trim(),
        'alergias': _alergiasController.text.trim(),
        'planoSaude': _planoController.text.trim(),
        'contatoEmergencia': _emergenciaController.text.trim(),
        'peso': _pesoController.text.trim(),
        'altura': _alturaController.text.trim(),
        'formularioPreenchido': true,
      });

      if (!mounted) return;
      _showSnackbar('✅ Dados salvos com sucesso!', isSuccess: true);
      Navigator.pop(context);
    } catch (e) {
      _showSnackbar('Erro ao salvar: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String msg, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Saúde'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField('Telefone', _telefoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField('Tipo Sanguíneo', _bloodTypeController),
              const SizedBox(height: 16),
              _buildTextField('Alergias', _alergiasController),
              const SizedBox(height: 16),
              _buildTextField('Plano de Saúde', _planoController),
              const SizedBox(height: 16),
              _buildTextField('Contato de Emergência', _emergenciaController),
              const SizedBox(height: 16),
              _buildTextField('Peso (kg)', _pesoController, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField('Altura (m)', _alturaController, keyboardType: TextInputType.number),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Salvar Dados',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}