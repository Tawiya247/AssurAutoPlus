import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import '../services/service_service.dart';
import '../models/user.dart';
import '../models/service.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/service_modal.dart';
import '../widgets/service_forms.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late Future<User?> _userDataFuture;
  late Future<List<Service>> _servicesFuture;
  final ServiceService _serviceService = ServiceService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
    _servicesFuture = _fetchServices();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<User?> _fetchUserData() async {
    final dashboardService = Provider.of<DashboardService>(context, listen: false);
    return await dashboardService.fetchUserData();
  }



  Future<List<Service>> _fetchServices() async {
    return await _serviceService.getUpdatedServices();
  }

  void _refreshServices() {
    setState(() {
      _servicesFuture = _fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                  ),
                ),
                title: const Text('AssurAuto'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await authService.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(),
                      const SizedBox(height: 24),
                      _buildQuickActions(),
                      const SizedBox(height: 24),
                      _buildServicesSection(),
                      const SizedBox(height: 24),
                      _buildStatsSection(),
                      const SizedBox(height: 24),
                      _buildUserServicesSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return FutureBuilder<User?>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          return CustomCard(
            hasGradient: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.accentColor,
                      child: Text(
                        (user.firstName?.isNotEmpty == true ? user.firstName![0] : user.phone[0]).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour,',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '${user.firstName ?? user.phone} ${user.lastName ?? ''}',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                title: 'Paiement',
                subtitle: 'Effectuer un paiement',
                icon: Icons.payment,
                color: AppTheme.successColor,
                onTap: () => Navigator.of(context).pushNamed('/payment'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ActionCard(
                title: 'Retrait',
                subtitle: 'Effectuer un retrait',
                icon: Icons.money_off,
                color: AppTheme.warningColor,
                onTap: () => Navigator.of(context).pushNamed('/withdrawal'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nos Services',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ServiceCard(
                title: 'TVM',
                subtitle: 'Taxe sur véhicule à moteur',
                icon: Icons.directions_car,
                color: AppTheme.primaryColor,
                onTap: () => _showTVMForm(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ServiceCard(
                title: 'Assurances',
                subtitle: 'Assurance véhicule',
                icon: Icons.shield,
                color: AppTheme.accentColor,
                onTap: () => _showAssuranceForm(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ServiceCard(
                title: 'Visite Technique',
                subtitle: 'Contrôle technique',
                icon: Icons.build_circle,
                color: AppTheme.infoColor,
                onTap: () => _showVisiteTechniqueForm(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showTVMForm() {
    final formKey = GlobalKey<TVMFormState>();
    showServiceModal(
      context,
      title: 'Demande TVM',
      icon: Icons.directions_car,
      color: AppTheme.primaryColor,
      child: TVMForm(key: formKey),
      isFormValid: () => formKey.currentState?.isFormValid() ?? false,
      onSubmit: () async {
        final formState = formKey.currentState;
        if (formState != null && formState.isFormValid()) {
          final service = await formState.createService();
          await _serviceService.saveService(service);
          
          if (mounted) {
            Navigator.of(context).pop();
            _refreshServices();
            
            // Show success message with animation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('TVM validé avec succès!'),
                  ],
                ),
                backgroundColor: AppTheme.successColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        }
      },
      submitText: 'Valider',
    );
  }

  void _showAssuranceForm() {
    final formKey = GlobalKey<AssuranceFormState>();
    showServiceModal(
      context,
      title: 'Assurance Véhicule',
      icon: Icons.shield,
      color: AppTheme.accentColor,
      child: AssuranceForm(key: formKey),
      isFormValid: () => formKey.currentState?.isFormValid() ?? false,
      onSubmit: () async {
        final formState = formKey.currentState;
        if (formState != null && formState.isFormValid()) {
          final service = await formState.createService();
          await _serviceService.saveService(service);
          
          if (mounted) {
            Navigator.of(context).pop();
            _refreshServices();
            
            // Show success message with animation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Assurance validée avec succès!'),
                  ],
                ),
                backgroundColor: AppTheme.successColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        }
      },
      submitText: 'Valider',
    );
  }

  void _showVisiteTechniqueForm() {
    final formKey = GlobalKey<VisiteTechniqueFormState>();
    showServiceModal(
      context,
      title: 'Visite Technique',
      icon: Icons.build_circle,
      color: AppTheme.infoColor,
      child: VisiteTechniqueForm(key: formKey),
      isFormValid: () => formKey.currentState?.isFormValid() ?? false,
      onSubmit: () async {
        final formState = formKey.currentState;
        if (formState != null && formState.isFormValid()) {
          final service = await formState.createService();
          await _serviceService.saveService(service);
          
          if (mounted) {
            Navigator.of(context).pop();
            _refreshServices();
            
            // Show success message with animation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Visite technique validée avec succès!'),
                  ],
                ),
                backgroundColor: AppTheme.successColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        }
      },
      submitText: 'Valider',
    );
  }

  Widget _buildStatsSection() {
    return FutureBuilder<User?>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Votre compte',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              StatsCard(
                title: 'Solde total',
                value: '${user.totalBalance?.toStringAsFixed(0) ?? '0'} CFA',
                icon: Icons.account_balance_wallet,
                color: AppTheme.primaryColor,
              ),
              StatsCard(
                title: 'Contribution mensuelle',
                value: '${user.monthlyContribution?.toStringAsFixed(0) ?? '0'} CFA',
                icon: Icons.trending_up,
                color: AppTheme.successColor,
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }


  Widget _buildUserServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vos Assurances',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Service>>(
          future: _servicesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final service = snapshot.data![index];
                  Color statusColor = AppTheme.successColor;
                  IconData serviceIcon = Icons.build;
                  
                  if (service.status == 'expired') {
                    statusColor = AppTheme.errorColor;
                  } else if (service.status == 'expiring_soon') {
                    statusColor = AppTheme.warningColor;
                  }
                  
                  switch (service.type) {
                    case 'tvm':
                      serviceIcon = Icons.directions_car;
                      break;
                    case 'assurance':
                      serviceIcon = Icons.shield;
                      break;
                    case 'visite_technique':
                      serviceIcon = Icons.build_circle;
                      break;
                  }
                  
                  return CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                serviceIcon,
                                color: statusColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.title,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    service.vehicleImmatriculation,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Effectué le ${service.serviceDate.day}/${service.serviceDate.month}/${service.serviceDate.year}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                service.daysUntilExpiry > 0 
                                  ? '${service.daysUntilExpiry} jours restants'
                                  : 'Expiré',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return CustomCard(
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.build_outlined,
                        size: 48,
                        color: AppTheme.textLightColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Aucune assurance enregistrée pour le moment',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

}
