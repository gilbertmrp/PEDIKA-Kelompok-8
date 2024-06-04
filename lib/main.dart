import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:violence_app/navigationBar/bottom_bar.dart';
import 'package:violence_app/provider/appointment_provider.dart';
import 'package:violence_app/provider/location_provider.dart';
import 'package:violence_app/provider/report_provider.dart';
import 'package:violence_app/provider/user_provider.dart';
import 'package:violence_app/provider/internet_provider.dart';
import 'package:violence_app/provider/sign_in_provider.dart';
import 'package:violence_app/screens/appointment/appointment_procedure.dart';
import 'package:violence_app/screens/appointment/appointment_screen.dart';
import 'package:violence_app/screens/appointment/edit_appointment_screen.dart';
import 'package:violence_app/screens/appointment/form_appointment_screen.dart';
import 'package:violence_app/screens/auth/forgot_password.dart';
import 'package:violence_app/screens/auth/login_screen.dart';
import 'package:violence_app/screens/auth/register_screen.dart';
import 'package:violence_app/screens/beranda_screen.dart';
import 'package:violence_app/screens/dpmdppa/form_report.dart';
import 'package:violence_app/screens/dpmdppa/report_cancel_screen.dart';
import 'package:violence_app/screens/dpmdppa/report_screen.dart';
import 'package:violence_app/screens/laporan/laporan_anda_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:violence_app/screens/notifikasi_screen.dart';
import 'package:violence_app/screens/profile/edit_password_screen.dart';
import 'package:violence_app/screens/profile/edit_profile_screen.dart';
import 'package:violence_app/screens/profile/profile_screen.dart';
import 'package:violence_app/screens/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final userProvider = UserProvider();
  await userProvider.loadUserToken();
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUserToken()),
        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => InternetProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const SplashScreen(),
      routes: {
        '/homepage' : (context) => const BottomNavigationWidget(initialIndex: 0,pages: [
          HomePage(), ReportScreen(), ProfilePage()
        ],),
        '/login' : (context) => const LoginPage(),
        '/laporan' : (context) => const LaporanScreen(),
        '/register' : (context) => const RegisterPage(),
        '/lupa-sandi' : (context) => const ForgotPassword(),
        '/profile' : (context) => const ProfilePage(),
        '/edit-profile' : (context) => const EditProfileScreen(),
        '/edit-password' : (context) => const EditPasswordScreen(),
        '/add-laporan' : (context) => const FormReportDPMADPPA(),
        '/janji-temu' : (context) => const AppointmentPage(),
        '/add-janji-temu' : (context) => const FormAppointmentScreen(),
        '/edit-janji-temu' : (context) => const EditAppointmentScreen(),
        '/prosedur-janji-temu' : (context) => const AppointmentProcedure(),
        '/notifikasi' : (context) => const NotificationScreen(),
      },
    );
  }
}
