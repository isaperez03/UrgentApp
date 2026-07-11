import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'core/services/location_service.dart';

import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/hospital_remote_datasource.dart';
import 'data/datasources/paciente_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/hospital_repository_impl.dart';
import 'data/repositories/paciente_repository_impl.dart';
import 'data/datasources/dashboard_remote_datasource.dart';
import 'data/repositories/dashboard_repository_impl.dart';
import 'data/datasources/habitacion_remote_datasource.dart';
import 'data/repositories/habitacion_repository_impl.dart';
import 'domain/usecases/get_dashboard_stats.dart';
import 'domain/usecases/get_available_hospitals.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/logout_user.dart';
import 'domain/usecases/register_patient.dart';
import 'domain/usecases/register_user.dart';
import 'domain/usecases/get_pacientes.dart';
import 'domain/usecases/get_emergencias_activas.dart';
import 'domain/usecases/save_attention.dart';
import 'domain/usecases/update_patient_status.dart';
import 'domain/usecases/discharge_patient.dart';
import 'domain/usecases/get_patient_history.dart';
import 'domain/usecases/get_rooms.dart';
import 'domain/usecases/get_rooms_by_hospital.dart';
import 'domain/usecases/update_room_status.dart';
import 'domain/usecases/get_current_user_data.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/hospital_viewmodel.dart';
import 'presentation/viewmodels/paciente_viewmodel.dart';
import 'presentation/viewmodels/dashboard_viewmodel.dart';
import 'presentation/viewmodels/habitacion_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final locationService = LocationService();

  final authRemoteDataSource = AuthRemoteDataSource();
  final hospitalRemoteDataSource = HospitalRemoteDataSource();
  final pacienteRemoteDataSource = PacienteRemoteDataSource();
  final dashboardRemoteDataSource = DashboardRemoteDataSource();
  final habitacionRemoteDataSource = HabitacionRemoteDataSource();

  final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  final hospitalRepository = HospitalRepositoryImpl(hospitalRemoteDataSource);
  final pacienteRepository = PacienteRepositoryImpl(pacienteRemoteDataSource);
  final dashboardRepository = DashboardRepositoryImpl(dashboardRemoteDataSource);
  final habitacionRepository = HabitacionRepositoryImpl(habitacionRemoteDataSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            loginUser: LoginUser(authRepository),
            registerUser: RegisterUser(authRepository),
            logoutUser: LogoutUser(authRepository),
            getCurrentUserData: GetCurrentUserData(authRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HospitalViewModel(
            getAvailableHospitals: GetAvailableHospitals(hospitalRepository),
            locationService: locationService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PacienteViewModel(
            registerPatient: RegisterPatient(pacienteRepository),
            getPacientes: GetPacientes(pacienteRepository),
            getEmergenciasActivas: GetEmergenciasActivas(pacienteRepository),
            updatePatientStatus: UpdatePatientStatus(pacienteRepository),
            saveAttention: SaveAttention(pacienteRepository),
            dischargePatient: DischargePatient(pacienteRepository),
            getPatientHistory: GetPatientHistory(pacienteRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HabitacionViewModel(
            getRooms: GetRooms(habitacionRepository),
            getRoomsByHospital: GetRoomsByHospital(habitacionRepository),
            updateRoomStatus: UpdateRoomStatus(habitacionRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(
            getDashboardStats: GetDashboardStats(dashboardRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
