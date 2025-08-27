import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/withdrawal_service.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_text_field.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> with TickerProviderStateMixin {
  final _amountController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedType;
  final _formKey = GlobalKey<FormState>();
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _errorMessage;
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _amountController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _makeWithdrawal() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final withdrawalService = Provider.of<WithdrawalService>(context, listen: false);

      final result = await withdrawalService.makeWithdrawal(
        amount: double.parse(_amountController.text),
        phone: _phoneNumberController.text,
        password: _passwordController.text,
        type: _selectedType!,
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          Navigator.of(context).pop();
        }
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // En-tête personnalisé
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.accentColor, AppTheme.accentColor.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Effectuer un Retrait',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Retrait sécurisé',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Retirez vos fonds facilement',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Contenu principal
                Expanded(
                  child: _isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentColor),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Traitement du retrait...',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Message d'erreur
                                if (_errorMessage != null)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 24),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppTheme.errorColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppTheme.errorColor.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: AppTheme.errorColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: TextStyle(
                                              color: AppTheme.errorColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                
                                // Champs de saisie
                                ModernTextField(
                                  controller: _amountController,
                                  labelText: 'Montant',
                                  hintText: 'Entrez le montant en CFA',
                                  prefixIcon: Icons.attach_money,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer un montant';
                                    }
                                    final amount = double.tryParse(value);
                                    if (amount == null) {
                                      return 'Montant invalide';
                                    }
                                    if (amount <= 0) {
                                      return 'Le montant doit être positif';
                                    }
                                    if (amount < 500) {
                                      return 'Montant minimum: 500 CFA';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                ModernTextField(
                                  controller: _phoneNumberController,
                                  labelText: 'Numéro de téléphone',
                                  hintText: '9X XXX XXX',
                                  prefixIcon: Icons.phone_outlined,
                                  prefixText: '+228 ',
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer le numéro de téléphone';
                                    }
                                    if (!RegExp(r'^[279][0-9]{7}$').hasMatch(value)) {
                                      return 'Numéro togolais invalide';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                ModernTextField(
                                  controller: _passwordController,
                                  labelText: 'Mot de passe',
                                  hintText: 'Votre mot de passe',
                                  prefixIcon: Icons.lock_outline,
                                  suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  obscureText: _obscurePassword,
                                  onSuffixIconTap: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer votre mot de passe';
                                    }
                                    if (value.length < 6) {
                                      return 'Mot de passe trop court';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Sélection du type de retrait
                                Text(
                                  'Type de retrait',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedType = 'moov';
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: _selectedType == 'moov'
                                                ? AppTheme.accentColor.withValues(alpha: 0.1)
                                                : Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: _selectedType == 'moov'
                                                  ? AppTheme.accentColor
                                                  : Colors.grey.shade200,
                                              width: _selectedType == 'moov' ? 2 : 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF0066CC).withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: const Icon(
                                                  Icons.phone_android,
                                                  color: Color(0xFF0066CC),
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Moov',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: _selectedType == 'moov'
                                                      ? AppTheme.accentColor
                                                      : AppTheme.textPrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedType = 'yass';
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: _selectedType == 'yass'
                                                ? AppTheme.accentColor.withValues(alpha: 0.1)
                                                : Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: _selectedType == 'yass'
                                                  ? AppTheme.accentColor
                                                  : Colors.grey.shade200,
                                              width: _selectedType == 'yass' ? 2 : 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: const Icon(
                                                  Icons.account_balance_wallet,
                                                  color: Color(0xFFFF6B35),
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Yass',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: _selectedType == 'yass'
                                                      ? AppTheme.accentColor
                                                      : AppTheme.textPrimaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                if (_selectedType == null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Veuillez sélectionner un type de retrait',
                                      style: TextStyle(
                                        color: AppTheme.errorColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                
                                const SizedBox(height: 32),
                                
                                // Bouton de retrait
                                ModernButton(
                                  text: 'Effectuer le Retrait',
                                  onPressed: () {
                                    if (_selectedType == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Veuillez sélectionner un type de retrait'),
                                        ),
                                      );
                                      return;
                                    }
                                    _makeWithdrawal();
                                  },
                                  isLoading: _isLoading,
                                  icon: Icons.account_balance_wallet,
                                  backgroundColor: AppTheme.accentColor,
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Note de sécurité
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.warningColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppTheme.warningColor.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: AppTheme.warningColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Les retraits sont traités sous 24h ouvrées',
                                          style: TextStyle(
                                            color: AppTheme.warningColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
