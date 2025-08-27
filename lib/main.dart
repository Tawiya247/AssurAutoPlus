import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assurauto_app/screens/login_screen.dart';
import 'package:assurauto_app/screens/register_screen.dart';
import 'package:assurauto_app/screens/dashboard_screen.dart';
import 'package:assurauto_app/screens/payment_screen.dart';
import 'package:assurauto_app/screens/withdrawal_screen.dart';
import 'package:assurauto_app/services/auth_service.dart';
import 'package:assurauto_app/services/dashboard_service.dart';
import 'package:assurauto_app/services/payment_service.dart';
import 'package:assurauto_app/services/withdrawal_service.dart';
import 'package:assurauto_app/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<DashboardService>(
          create: (context) => DashboardService(context.read<AuthService>()),
        ),
        Provider<PaymentService>(
          create: (context) => PaymentService(context.read<AuthService>()),
        ),
        Provider<WithdrawalService>(
          create: (context) => WithdrawalService(context.read<AuthService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AssurAuto',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) =>
            const DashboardScreen(), // Added route for dashboard
        '/payment': (context) =>
            const PaymentScreen(), // Added route for payment
        '/withdrawal': (context) =>
            const WithdrawalScreen(), // Added route for withdrawal
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return FutureBuilder<bool>(
      future: authService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return const DashboardScreen(); // Changed placeholder to DashboardScreen
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
