import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/dashboard_viewmodel.dart';
import '../../widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DashboardViewModel>().escucharDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
        backgroundColor: const Color(0xFF87CEEB),
        appBar: AppBar(
          backgroundColor: const Color(0xFF87CEEB),
          title: const Text('Panel general'),
        ),
        drawer: const AppDrawer(),
      body: Builder(
        builder: (_) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage.isNotEmpty) {
            return Center(child: Text(vm.errorMessage));
          }

          if (vm.stats == null) {
            return const Center(child: Text('No hay datos disponibles'));
          }

          final stats = vm.stats!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _DashboardCard(
                  title: 'Total de pacientes',
                  value: stats.totalPacientes.toString(),
                  icon: Icons.people,
                ),
                _DashboardCard(
                  title: 'Emergencias activas',
                  value: stats.emergenciasActivas.toString(),
                  icon: Icons.emergency,
                ),
                _DashboardCard(
                  title: 'Pacientes en atención',
                  value: stats.pacientesEnAtencion.toString(),
                  icon: Icons.local_hospital,
                ),
                _DashboardCard(
                  title: 'Pacientes egresados',
                  value: stats.pacientesEgresados.toString(),
                  icon: Icons.check_circle,
                ),
                _DashboardCard(
                  title: 'Hospitales activos',
                  value: stats.hospitalesActivos.toString(),
                  icon: Icons.apartment,
                ),
                _DashboardCard(
                  title: 'Habitaciones libres',
                  value: stats.habitacionesLibresTotales.toString(),
                  icon: Icons.meeting_room,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: Icon(icon, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}