import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/paciente_viewmodel.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/role_guard.dart';
import 'attention_screen.dart';

class EmergencyListScreen extends StatefulWidget {
  const EmergencyListScreen({super.key});

  @override
  State<EmergencyListScreen> createState() => _EmergencyListScreenState();
}

class _EmergencyListScreenState extends State<EmergencyListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authVm = context.read<AuthViewModel>();
      final vm = context.read<PacienteViewModel>();
      final usuario = authVm.usuarioActual;

      if (usuario == null) return;

      if (authVm.isAdmin) {
        vm.escucharEmergencias();
      } else if (authVm.isMedico) {
        vm.escucharEmergenciasFiltradasPorHospital(
          hospitalId: usuario.hospitalId,
          especialidad: usuario.especialidad,
        );
      }
    });
  }

  Future<void> _atenderPaciente(int index) async {
    final authVm = context.read<AuthViewModel>();

    if (!authVm.isMedico) return;

    final vm = context.read<PacienteViewModel>();
    final paciente = vm.emergencias[index];

    final ok = await vm.cambiarEstadoPaciente(
      pacienteId: paciente.id,
      nuevoEstado: 'en_atencion',
    );

    if (!mounted) return;

    if (ok) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AttentionScreen(paciente: paciente),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vm.errorMessage.isNotEmpty
                ? vm.errorMessage
                : 'No se pudo atender la emergencia',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PacienteViewModel>();
    final authVm = context.watch<AuthViewModel>();

    return RoleGuard(
      allowedRoles: const ['admin', 'medico'],
      child: Scaffold(
        drawer: const AppDrawer(),
        backgroundColor: const Color(0xFF87CEEB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF87CEEB),
          title: const Text('Emergencias'),
        ),
        body: Builder(
          builder: (_) {
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (vm.errorMessage.isNotEmpty) {
              return Center(
                child: Text(vm.errorMessage),
              );
            }

            if (vm.emergencias.isEmpty) {
              return const Center(
                child: Text('No hay emergencias activas'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.emergencias.length,
              itemBuilder: (context, index) {
                final paciente = vm.emergencias[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: const Icon(
                      Icons.emergency,
                      color: Colors.red,
                      size: 34,
                    ),
                    title: Text(
                      paciente.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Tipo: ${paciente.tipoEmergencia}\nHospital: ${paciente.hospitalNombre}',
                    ),
                    trailing: (authVm.isMedico && paciente.estado == 'pendiente')
                        ? ElevatedButton(
                      onPressed: () => _atenderPaciente(index),
                      child: const Text('Atender'),
                    )
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}