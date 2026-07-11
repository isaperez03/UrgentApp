import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../roles/role_router_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nombreController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final unidadController = TextEditingController();

  String? rolSeleccionado;
  String? hospitalSeleccionado;
  String? especialidadSeleccionada;

  final List<Map<String, dynamic>> hospitales = const [
    {
      'id': 'HOSP001',
      'nombre': 'Hospital General del Norte',
      'especialidades': ['General', 'Cardiologia', 'Traumatologia'],
    },
    {
      'id': 'HOSP002',
      'nombre': 'Hospital Central',
      'especialidades': ['Pediatria', 'General'],
    },
    {
      'id': 'HOSP003',
      'nombre': 'Hospital del Sur',
      'especialidades': ['General'],
    },
    {
      'id': 'HOSP004',
      'nombre': 'Hospital Materno Infantil',
      'especialidades': ['Pediatria', 'General'],
    },
    {
      'id': 'HOSP005',
      'nombre': 'Hospital Regional Oriente',
      'especialidades': ['General', 'Cardiologia', 'Traumatologia'],
    },
  ];

  List<String> especialidadesDisponibles = [];

  @override
  void dispose() {
    nombreController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    unidadController.dispose();
    super.dispose();
  }

  void _actualizarEspecialidadesPorHospital(String? hospitalId) {
    final hospital = hospitales.firstWhere(
          (h) => h['id'] == hospitalId,
      orElse: () => {},
    );

    final lista = (hospital['especialidades'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ??
        [];

    setState(() {
      hospitalSeleccionado = hospitalId;
      especialidadesDisponibles = lista;
      especialidadSeleccionada = null;
    });
  }

  Future<void> _register() async {
    if (nombreController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        rolSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    if (rolSeleccionado == 'medico') {
      if (hospitalSeleccionado == null || especialidadSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecciona hospital y especialidad para el médico'),
          ),
        );
        return;
      }
    }

    if (rolSeleccionado == 'traslado' && unidadController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe la unidad de traslado'),
        ),
      );
      return;
    }

    final vm = context.read<AuthViewModel>();

    final ok = await vm.register(
      nombre: nombreController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      rol: rolSeleccionado!,
      hospitalId: rolSeleccionado == 'medico' ? (hospitalSeleccionado ?? '') : '',
      especialidad:
      rolSeleccionado == 'medico' ? (especialidadSeleccionada ?? '') : '',
      unidad: rolSeleccionado == 'traslado' ? unidadController.text.trim() : '',
    );

    if (!mounted) return;

    if (ok) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const RoleRouterScreen(),
        ),
            (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
        backgroundColor: const Color(0xFF87CEEB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Nombre completo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Confirmar contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              value: rolSeleccionado,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Selecciona un rol',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'medico',
                  child: Text('Personal médico'),
                ),
                DropdownMenuItem(
                  value: 'traslado',
                  child: Text('Traslado'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  rolSeleccionado = value;
                  hospitalSeleccionado = null;
                  especialidadSeleccionada = null;
                  especialidadesDisponibles = [];
                });
              },
            ),
            const SizedBox(height: 18),
            if (rolSeleccionado == 'medico') ...[
              DropdownButtonFormField<String>(
                value: hospitalSeleccionado,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Selecciona hospital',
                  border: OutlineInputBorder(),
                ),
                items: hospitales.map((hospital) {
                  return DropdownMenuItem(
                    value: hospital['id'] as String,
                    child: Text(hospital['nombre'] as String),
                  );
                }).toList(),
                onChanged: _actualizarEspecialidadesPorHospital,
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                value: especialidadSeleccionada,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Selecciona especialidad',
                  border: OutlineInputBorder(),
                ),
                items: especialidadesDisponibles.map((especialidad) {
                  return DropdownMenuItem(
                    value: especialidad,
                    child: Text(especialidad),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    especialidadSeleccionada = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              if (hospitalSeleccionado != null)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Solo se muestran las especialidades que atiende ese hospital.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              const SizedBox(height: 18),
            ],
            if (rolSeleccionado == 'traslado') ...[
              TextField(
                controller: unidadController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Unidad de traslado',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
            ],
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
              width: double.infinity,
              child: ElevatedButton(
                onPressed: vm.isLoading ? null : _register,
                child: vm.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Registrarse'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}