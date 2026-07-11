import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/paciente.dart';
import '../../viewmodels/paciente_viewmodel.dart';

class AttentionScreen extends StatefulWidget {
  final Paciente paciente;

  const AttentionScreen({
    super.key,
    required this.paciente,
  });

  @override
  State<AttentionScreen> createState() => _AttentionScreenState();
}

class _AttentionScreenState extends State<AttentionScreen> {
  final diagnosticoController = TextEditingController();
  final medicamentosController = TextEditingController();
  final procedimientoController = TextEditingController();
  final observacionesController = TextEditingController();

  bool get _pacienteEgresado => widget.paciente.estado == 'egresado';

  @override
  void dispose() {
    diagnosticoController.dispose();
    medicamentosController.dispose();
    procedimientoController.dispose();
    observacionesController.dispose();
    super.dispose();
  }

  Future<void> _guardarAtencion() async {
    if (_pacienteEgresado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pueden registrar atenciones a un paciente egresado',
          ),
        ),
      );
      return;
    }

    if (diagnosticoController.text.trim().isEmpty ||
        medicamentosController.text.trim().isEmpty ||
        procedimientoController.text.trim().isEmpty ||
        observacionesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    final vm = context.read<PacienteViewModel>();

    final ok = await vm.guardarAtencion(
      pacienteId: widget.paciente.id,
      pacienteNombre: widget.paciente.nombre,
      diagnostico: diagnosticoController.text.trim(),
      medicamentos: medicamentosController.text.trim(),
      procedimiento: procedimientoController.text.trim(),
      observaciones: observacionesController.text.trim(),
    );

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Atención guardada correctamente')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vm.errorMessage.isNotEmpty
                ? vm.errorMessage
                : 'No se pudo guardar la atención',
          ),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PacienteViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEEB),
        title: const Text('Atención'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black12,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.paciente.nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Estado actual: ${widget.paciente.estado}',
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tipo de emergencia: ${widget.paciente.tipoEmergencia}',
                    style: const TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (_pacienteEgresado)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Este paciente ya fue egresado y no admite nuevas atenciones.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            TextField(
              controller: diagnosticoController,
              enabled: !_pacienteEgresado,
              decoration: _inputDecoration('Diagnóstico'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: medicamentosController,
              enabled: !_pacienteEgresado,
              decoration: _inputDecoration('Medicamentos'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: procedimientoController,
              enabled: !_pacienteEgresado,
              maxLines: 3,
              decoration: _inputDecoration('Procedimiento'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: observacionesController,
              enabled: !_pacienteEgresado,
              maxLines: 4,
              decoration: _inputDecoration('Observaciones'),
            ),
            const SizedBox(height: 24),

            if (vm.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  vm.errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: (vm.isLoading || _pacienteEgresado)
                    ? null
                    : _guardarAtencion,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: vm.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Guardar atención',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}