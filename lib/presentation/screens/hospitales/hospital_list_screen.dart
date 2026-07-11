import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/hospital_viewmodel.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/hospital_card.dart';
import 'hospital_detail_screen.dart';
import 'register_patient_screen.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  State<HospitalListScreen> createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  String? tipoEmergenciaSeleccionado;

  final List<String> tiposEmergencia = [
    'Urgencia general',
    'Cardiologia',
    'Traumatologia',
    'Pediatria',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HospitalViewModel>().escucharHospitales();
    });
  }

  Future<void> _recargar() async {
    final vm = context.read<HospitalViewModel>();
    vm.escucharHospitales();

    if (tipoEmergenciaSeleccionado != null &&
        tipoEmergenciaSeleccionado != 'todos') {
      vm.recomendarPorTipoEmergencia(tipoEmergenciaSeleccionado!);
    } else {
      vm.limpiarFiltro();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HospitalViewModel>();
    final authVm = context.watch<AuthViewModel>();
    final recomendado = vm.hospitalMasCercanoDisponible;

    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF87CEEB),
        title: Text(
          authVm.isTraslado
              ? 'Hospitales disponibles'
              : 'Listado de hospitales',
        ),
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

          return RefreshIndicator(
            onRefresh: _recargar,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: DropdownButtonFormField<String>(
                    value: tipoEmergenciaSeleccionado,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Filtrar por tipo de emergencia',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 'todos',
                        child: Text('Todos'),
                      ),
                      ...tiposEmergencia.map(
                            (tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        tipoEmergenciaSeleccionado = value;
                      });

                      if (value == null || value == 'todos') {
                        vm.limpiarFiltro();
                      } else {
                        vm.recomendarPorTipoEmergencia(value);
                      }
                    },
                  ),
                ),

                if (recomendado != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black12),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black12,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hospital recomendado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recomendado.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text('Zona: ${recomendado.zona}'),
                        Text(
                          'Distancia: ${vm.getDistanciaKm(recomendado.id).toStringAsFixed(2)} km',
                        ),
                        Text(
                          'Habitaciones libres: ${recomendado.habitacionesLibres}',
                        ),
                        Text('UCI libres: ${recomendado.uciLibres}'),
                        Text(
                          recomendado.especialidades.isEmpty
                              ? 'Especialidades: no registradas'
                              : 'Especialidades: ${recomendado.especialidades.join(', ')}',
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HospitalDetailScreen(
                                        hospital: recomendado,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Ver detalle'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RegisterPatientScreen(
                                        hospital: recomendado,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Enviar aquí'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                if (vm.hospitalesFiltrados.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'No hay hospitales compatibles con esa emergencia',
                      ),
                    ),
                  )
                else
                  ...vm.hospitalesFiltrados.map((hospital) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: HospitalCard(hospital: hospital),
                    );
                  }).toList(),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}