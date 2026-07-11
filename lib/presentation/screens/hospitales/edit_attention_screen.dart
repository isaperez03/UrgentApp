import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/atencion.dart';

class EditAttentionScreen extends StatefulWidget {
  final Atencion atencion;

  const EditAttentionScreen({
    super.key,
    required this.atencion,
  });

  @override
  State<EditAttentionScreen> createState() => _EditAttentionScreenState();
}

class _EditAttentionScreenState extends State<EditAttentionScreen> {
  late final TextEditingController diagnosticoController;
  late final TextEditingController medicamentosController;
  late final TextEditingController procedimientoController;
  late final TextEditingController observacionesController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    diagnosticoController =
        TextEditingController(text: widget.atencion.diagnostico);
    medicamentosController =
        TextEditingController(text: widget.atencion.medicamentos);
    procedimientoController =
        TextEditingController(text: widget.atencion.procedimiento);
    observacionesController =
        TextEditingController(text: widget.atencion.observaciones);
  }

  @override
  void dispose() {
    diagnosticoController.dispose();
    medicamentosController.dispose();
    procedimientoController.dispose();
    observacionesController.dispose();
    super.dispose();
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

  Future<void> _guardarCambios() async {
    if (diagnosticoController.text
        .trim()
        .isEmpty ||
        medicamentosController.text
            .trim()
            .isEmpty ||
        procedimientoController.text
            .trim()
            .isEmpty ||
        observacionesController.text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos'),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseFirestore.instance
          .collection('atenciones')
          .doc(widget.atencion.id)
          .update({
        'diagnostico': diagnosticoController.text.trim(),
        'medicamentos': medicamentosController.text.trim(),
        'procedimiento': procedimientoController.text.trim(),
        'observaciones': observacionesController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Atención actualizada correctamente'),
        ),
      );

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de Firestore: ${e.message ?? e.code}'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo actualizar la atención: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEEB),
        title: const Text('Editar atención'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: diagnosticoController,
              decoration: _inputDecoration('Diagnóstico'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: medicamentosController,
              decoration: _inputDecoration('Medicamentos'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: procedimientoController,
              maxLines: 3,
              decoration: _inputDecoration('Procedimiento'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: observacionesController,
              maxLines: 4,
              decoration: _inputDecoration('Observaciones'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : _guardarCambios,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Guardar cambios',
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