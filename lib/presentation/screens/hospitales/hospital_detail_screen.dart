import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/hospital.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'register_patient_screen.dart';

class HospitalDetailScreen extends StatelessWidget {
  final Hospital hospital;

  const HospitalDetailScreen({
    super.key,
    required this.hospital,
  });

  int get _espaciosDisponiblesTotales =>
      hospital.habitacionesLibres + hospital.uciLibres;

  Color _statusColor() {
    if (_espaciosDisponiblesTotales <= 0) return Colors.red;
    if (_espaciosDisponiblesTotales <= 2) return Colors.orange;
    return Colors.green;
  }

  String _statusText() {
    if (_espaciosDisponiblesTotales <= 0) {
      return 'Saturado';
    }
    if (_espaciosDisponiblesTotales <= 2) {
      return 'Disponibilidad limitada';
    }
    return 'Disponible';
  }

  IconData _especialidadIcon(String especialidad) {
    switch (especialidad.trim().toLowerCase()) {
      case 'urgencias':
        return Icons.emergency_outlined;
      case 'cardiología':
      case 'cardiologia':
        return Icons.favorite_border;
      case 'traumatología':
      case 'traumatologia':
        return Icons.accessibility_new_outlined;
      case 'pediatría':
      case 'pediatria':
        return Icons.child_care_outlined;
      case 'general':
        return Icons.local_hospital_outlined;
      default:
        return Icons.medical_services_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final puedeEnviar = authVm.isTraslado || authVm.isAdmin;

    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEEB),
        elevation: 0,
        title: const Text('Detalle del hospital'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 34,
                    child: Icon(Icons.local_hospital_outlined, size: 34),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hospital.nombre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hospital.direccion,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Zona: ${hospital.zona}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Teléfono: ${hospital.telefono}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      _statusText(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Espacios disponibles: $_espaciosDisponiblesTotales',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Capacidad actual',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _infoRow(
                      icon: Icons.meeting_room_outlined,
                      label: 'Habitaciones libres',
                      value: hospital.habitacionesLibres.toString(),
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      icon: Icons.lock_outline,
                      label: 'Habitaciones ocupadas',
                      value: hospital.habitacionesOcupadas.toString(),
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      icon: Icons.monitor_heart_outlined,
                      label: 'UCI libres',
                      value: hospital.uciLibres.toString(),
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      icon: Icons.local_hospital_outlined,
                      label: 'UCI ocupadas',
                      value: hospital.uciOcupadas.toString(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Especialidades',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (hospital.especialidades.isEmpty)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('No hay especialidades registradas'),
                      )
                    else
                      Column(
                        children: hospital.especialidades.map((especialidad) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F8FB),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Icon(_especialidadIcon(especialidad)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    especialidad,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (puedeEnviar)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_espaciosDisponiblesTotales <= 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Este hospital ya no tiene disponibilidad para recibir pacientes.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _espaciosDisponiblesTotales <= 0
                          ? null
                          : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterPatientScreen(
                              hospital: hospital,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text(
                        'Enviar paciente',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}