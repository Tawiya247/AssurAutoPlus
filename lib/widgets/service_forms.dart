import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/service.dart';
import '../services/service_service.dart';

class ModernTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool required;
  final int? maxLines;

  const ModernTextField({
    super.key,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.controller,
    this.required = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.errorColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class ModernDatePicker extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final void Function(DateTime?)? onDateSelected;
  final IconData? prefixIcon;
  final bool required;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hint;

  const ModernDatePicker({
    super.key,
    required this.label,
    this.selectedDate,
    this.onDateSelected,
    this.prefixIcon,
    this.required = false,
    this.firstDate,
    this.lastDate,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: firstDate ?? DateTime(2020),
              lastDate: lastDate ?? DateTime.now(),
            );
            if (date != null && onDateSelected != null) {
              onDateSelected!(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (prefixIcon != null)
                  Icon(prefixIcon, color: AppTheme.primaryColor),
                if (prefixIcon != null) const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : hint ?? 'Sélectionner une date',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selectedDate != null
                          ? AppTheme.textPrimaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today_outlined, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ModernDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final IconData? prefixIcon;
  final bool required;

  const ModernDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.prefixIcon,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            filled: true,
            fillColor: Colors.grey.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

// TVM Form
class TVMForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const TVMForm({super.key, this.onSubmit});

  @override
  State<TVMForm> createState() => TVMFormState();
}

// Make the state class public so it can be accessed from dashboard
class TVMFormState extends State<TVMForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _immatriculationController = TextEditingController();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _anneeController = TextEditingController();
  String? _typeVehicule;
  String? _typeCarburant;
  DateTime? _dateService;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations personnelles',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Nom',
            hint: 'Votre nom de famille',
            prefixIcon: Icons.person_outline,
            controller: _nomController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le nom est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Prénom',
            hint: 'Votre prénom',
            prefixIcon: Icons.person_outline,
            controller: _prenomController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le prénom est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Téléphone',
            hint: '+228 XX XX XX XX XX',
            prefixIcon: Icons.phone_outlined,
            controller: _telephoneController,
            keyboardType: TextInputType.phone,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le numéro de téléphone est requis';
              }
              // Validation pour numéro togolais (+228)
              final cleanNumber = value!.replaceAll(RegExp(r'[^0-9]'), '');
              if (cleanNumber.length == 8) {
                // Format local: 90 XX XX XX ou 70 XX XX XX
                if (!cleanNumber.startsWith('90') && !cleanNumber.startsWith('70') && !cleanNumber.startsWith('91') && !cleanNumber.startsWith('92') && !cleanNumber.startsWith('93')) {
                  return 'Numéro togolais invalide';
                }
              } else if (cleanNumber.length == 11 && cleanNumber.startsWith('228')) {
                // Format international: 228 XX XX XX XX
                final localPart = cleanNumber.substring(3);
                if (!localPart.startsWith('90') && !localPart.startsWith('70') && !localPart.startsWith('91') && !localPart.startsWith('92') && !localPart.startsWith('93')) {
                  return 'Numéro togolais invalide';
                }
              } else {
                return 'Format: +228 XX XX XX XX XX ou XX XX XX XX';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Informations du véhicule',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Immatriculation',
            hint: 'Ex: AB 1234 CD',
            prefixIcon: Icons.confirmation_number_outlined,
            controller: _immatriculationController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'L\'immatriculation est requise';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernDropdown<String>(
            label: 'Type de véhicule',
            value: _typeVehicule,
            prefixIcon: Icons.directions_car_outlined,
            required: true,
            items: const [
              DropdownMenuItem(value: 'voiture', child: Text('Voiture')),
              DropdownMenuItem(value: 'moto', child: Text('Moto')),
              DropdownMenuItem(value: 'camion', child: Text('Camion')),
              DropdownMenuItem(value: 'bus', child: Text('Bus')),
            ],
            onChanged: (value) {
              setState(() {
                _typeVehicule = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Marque',
            hint: 'Ex: Toyota, Honda, Mercedes...',
            prefixIcon: Icons.branding_watermark_outlined,
            controller: _marqueController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'La marque est requise';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Modèle',
            hint: 'Ex: Corolla, Civic, C-Class...',
            prefixIcon: Icons.model_training_outlined,
            controller: _modeleController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le modèle est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Année',
            hint: 'Ex: 2020',
            prefixIcon: Icons.calendar_today_outlined,
            controller: _anneeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'L\'année est requise';
              }
              final year = int.tryParse(value!);
              if (year == null ||
                  year < 1900 ||
                  year > DateTime.now().year + 1) {
                return 'Année invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernDropdown<String>(
            label: 'Type de carburant',
            value: _typeCarburant,
            prefixIcon: Icons.local_gas_station_outlined,
            required: true,
            items: const [
              DropdownMenuItem(value: 'essence', child: Text('Essence')),
              DropdownMenuItem(value: 'diesel', child: Text('Diesel')),
              DropdownMenuItem(value: 'hybride', child: Text('Hybride')),
              DropdownMenuItem(value: 'electrique', child: Text('Électrique')),
            ],
            onChanged: (value) {
              setState(() {
                _typeCarburant = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Date du service',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ModernDatePicker(
            label: 'Date de réalisation du TVM',
            selectedDate: _dateService,
            prefixIcon: Icons.event_outlined,
            required: true,
            hint: 'Quand avez-vous effectué le TVM?',
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now(),
            onDateSelected: (date) {
              setState(() {
                _dateService = date;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _immatriculationController.dispose();
    _marqueController.dispose();
    _modeleController.dispose();
    _anneeController.dispose();
    super.dispose();
  }

  bool isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  Future<Service> createService() async {
    final serviceService = ServiceService();
    return serviceService.createServiceFromFormData(
      userId: 'current_user', // This should be replaced with actual user ID
      type: 'tvm',
      nom: _nomController.text,
      prenom: _prenomController.text,
      telephone: _telephoneController.text,
      immatriculation: _immatriculationController.text,
      marque: _marqueController.text,
      modele: _modeleController.text,
      serviceDate: _dateService ?? DateTime.now(),
      additionalDetails: {
        'annee': _anneeController.text,
        'typeVehicule': _typeVehicule,
        'typeCarburant': _typeCarburant,
      },
    );
  }
}

// Insurance Form
class AssuranceForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const AssuranceForm({super.key, this.onSubmit});

  @override
  State<AssuranceForm> createState() => AssuranceFormState();
}

class AssuranceFormState extends State<AssuranceForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _immatriculationController = TextEditingController();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _valeurController = TextEditingController();
  String? _typeAssurance;
  String? _dureeAssurance;
  DateTime? _dateService;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations personnelles',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Nom',
            hint: 'Votre nom de famille',
            prefixIcon: Icons.person_outline,
            controller: _nomController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le nom est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Prénom',
            hint: 'Votre prénom',
            prefixIcon: Icons.person_outline,
            controller: _prenomController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le prénom est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Téléphone',
            hint: '+228 XX XX XX XX XX',
            prefixIcon: Icons.phone_outlined,
            controller: _telephoneController,
            keyboardType: TextInputType.phone,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le numéro de téléphone est requis';
              }
              // Validation pour numéro togolais (+228)
              final cleanNumber = value!.replaceAll(RegExp(r'[^0-9]'), '');
              if (cleanNumber.length == 8) {
                // Format local: 90 XX XX XX ou 70 XX XX XX
                if (!cleanNumber.startsWith('90') && !cleanNumber.startsWith('70') && !cleanNumber.startsWith('91') && !cleanNumber.startsWith('92') && !cleanNumber.startsWith('93')) {
                  return 'Numéro togolais invalide';
                }
              } else if (cleanNumber.length == 11 && cleanNumber.startsWith('228')) {
                // Format international: 228 XX XX XX XX
                final localPart = cleanNumber.substring(3);
                if (!localPart.startsWith('90') && !localPart.startsWith('70') && !localPart.startsWith('91') && !localPart.startsWith('92') && !localPart.startsWith('93')) {
                  return 'Numéro togolais invalide';
                }
              } else {
                return 'Format: +228 XX XX XX XX XX ou XX XX XX XX';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Informations du véhicule',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Immatriculation',
            hint: 'Ex: AB 1234 CD',
            prefixIcon: Icons.confirmation_number_outlined,
            controller: _immatriculationController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'L\'immatriculation est requise';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Marque',
            hint: 'Ex: Toyota, Honda, Mercedes...',
            prefixIcon: Icons.branding_watermark_outlined,
            controller: _marqueController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'La marque est requise';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Modèle',
            hint: 'Ex: Corolla, Civic, C-Class...',
            prefixIcon: Icons.model_training_outlined,
            controller: _modeleController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le modèle est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Valeur du véhicule',
            hint: 'En FCFA',
            prefixIcon: Icons.attach_money_outlined,
            controller: _valeurController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'La valeur du véhicule est requise';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Type d\'assurance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ModernDropdown<String>(
            label: 'Formule d\'assurance',
            value: _typeAssurance,
            prefixIcon: Icons.shield_outlined,
            required: true,
            items: const [
              DropdownMenuItem(
                value: 'tiers',
                child: Text('Responsabilité Civile (Tiers)'),
              ),
              DropdownMenuItem(
                value: 'tiers_plus',
                child: Text('Tiers Plus (Vol + Incendie)'),
              ),
              DropdownMenuItem(
                value: 'tous_risques',
                child: Text('Tous Risques'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _typeAssurance = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ModernDropdown<String>(
            label: 'Durée de l\'assurance',
            value: _dureeAssurance,
            prefixIcon: Icons.schedule_outlined,
            required: true,
            items: const [
              DropdownMenuItem(value: '6_mois', child: Text('6 mois')),
              DropdownMenuItem(value: '1_an', child: Text('1 an')),
              DropdownMenuItem(value: '2_ans', child: Text('2 ans')),
            ],
            onChanged: (value) {
              setState(() {
                _dureeAssurance = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Date du service',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ModernDatePicker(
            label: 'Date de souscription',
            selectedDate: _dateService,
            prefixIcon: Icons.event_outlined,
            required: true,
            hint: 'Quand avez-vous souscrit à cette assurance?',
            firstDate: DateTime.now().subtract(const Duration(days: 365)),
            lastDate: DateTime.now(),
            onDateSelected: (date) {
              setState(() {
                _dateService = date;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _immatriculationController.dispose();
    _marqueController.dispose();
    _modeleController.dispose();
    _valeurController.dispose();
    super.dispose();
  }

  bool isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  Future<Service> createService() async {
    final serviceService = ServiceService();
    return serviceService.createServiceFromFormData(
      userId: 'current_user',
      type: 'assurance',
      nom: _nomController.text,
      prenom: _prenomController.text,
      telephone: _telephoneController.text,
      immatriculation: _immatriculationController.text,
      marque: _marqueController.text,
      modele: _modeleController.text,
      serviceDate: _dateService ?? DateTime.now(),
      additionalDetails: {
        'valeurVehicule': _valeurController.text,
        'typeAssurance': _typeAssurance,
        'dureeAssurance': _dureeAssurance,
      },
    );
  }
}

// Technical Visit Form
class VisiteTechniqueForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const VisiteTechniqueForm({super.key, this.onSubmit});

  @override
  State<VisiteTechniqueForm> createState() => VisiteTechniqueFormState();
}

class VisiteTechniqueFormState extends State<VisiteTechniqueForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _immatriculationController = TextEditingController();
  final _marqueController = TextEditingController();
  final _modeleController = TextEditingController();
  final _anneeController = TextEditingController();
  final _kilometrageController = TextEditingController();
  String? _typeVisite;
  String? _centreVisite;
  DateTime? _datePreferee;
  DateTime? _dateService;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations personnelles',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Nom',
            hint: 'Votre nom de famille',
            prefixIcon: Icons.person_outline,
            controller: _nomController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le nom est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Prénom',
            hint: 'Votre prénom',
            prefixIcon: Icons.person_outline,
            controller: _prenomController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le prénom est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Téléphone',
            hint: '+228 XX XX XX XX XX',
            prefixIcon: Icons.phone_outlined,
            controller: _telephoneController,
            keyboardType: TextInputType.phone,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le numéro de téléphone est requis';
              }
              // Validation pour numéro togolais (+228)
              final cleanNumber = value!.replaceAll(RegExp(r'[^0-9]'), '');
              if (cleanNumber.length == 8) {
                // Format local: 90 XX XX XX ou 70 XX XX XX
                if (!cleanNumber.startsWith('90') && !cleanNumber.startsWith('70') && !cleanNumber.startsWith('91') && !cleanNumber.startsWith('92') && !cleanNumber.startsWith('93')) {
                  return 'Numéro togolais invalide';
                }
              } else if (cleanNumber.length == 11 && cleanNumber.startsWith('228')) {
                // Format international: 228 XX XX XX XX
                final localPart = cleanNumber.substring(3);
                if (!localPart.startsWith('90') && !localPart.startsWith('70') && !localPart.startsWith('91') && !localPart.startsWith('92') && !localPart.startsWith('93')) {
                  return 'Numéro togolais invalide';
                }
              } else {
                return 'Format: +228 XX XX XX XX XX ou XX XX XX XX';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Informations du véhicule',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Immatriculation',
            hint: 'Ex: AB 1234 CD',
            prefixIcon: Icons.confirmation_number_outlined,
            controller: _immatriculationController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'L\'immatriculation est requise';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Marque',
            hint: 'Ex: Toyota, Honda, Mercedes...',
            prefixIcon: Icons.branding_watermark_outlined,
            controller: _marqueController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'La marque est requise';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Modèle',
            hint: 'Ex: Corolla, Civic, C-Class...',
            prefixIcon: Icons.model_training_outlined,
            controller: _modeleController,
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le modèle est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Année',
            hint: 'Ex: 2020',
            prefixIcon: Icons.calendar_today_outlined,
            controller: _anneeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'L\'année est requise';
              }
              final year = int.tryParse(value!);
              if (year == null ||
                  year < 1900 ||
                  year > DateTime.now().year + 1) {
                return 'Année invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ModernTextField(
            label: 'Kilométrage',
            hint: 'Kilométrage actuel',
            prefixIcon: Icons.speed_outlined,
            controller: _kilometrageController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            required: true,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Le kilométrage est requis';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Détails de la visite',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ModernDropdown<String>(
            label: 'Type de visite',
            value: _typeVisite,
            prefixIcon: Icons.build_outlined,
            required: true,
            items: const [
              DropdownMenuItem(
                value: 'premiere',
                child: Text('Première visite'),
              ),
              DropdownMenuItem(
                value: 'periodique',
                child: Text('Visite périodique'),
              ),
              DropdownMenuItem(
                value: 'contre_visite',
                child: Text('Contre-visite'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _typeVisite = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ModernDropdown<String>(
            label: 'Centre de visite préféré',
            value: _centreVisite,
            prefixIcon: Icons.location_on_outlined,
            required: true,
            items: const [
              DropdownMenuItem(
                value: 'abidjan_nord',
                child: Text('Abidjan Nord'),
              ),
              DropdownMenuItem(
                value: 'abidjan_sud',
                child: Text('Abidjan Sud'),
              ),
              DropdownMenuItem(value: 'cocody', child: Text('Cocody')),
              DropdownMenuItem(value: 'yopougon', child: Text('Yopougon')),
              DropdownMenuItem(value: 'bouake', child: Text('Bouaké')),
            ],
            onChanged: (value) {
              setState(() {
                _centreVisite = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Date préférée',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now().add(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (date != null) {
                    setState(() {
                      _datePreferee = date;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _datePreferee != null
                              ? '${_datePreferee!.day}/${_datePreferee!.month}/${_datePreferee!.year}'
                              : 'Sélectionner une date',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: _datePreferee != null
                                    ? AppTheme.textPrimaryColor
                                    : Colors.grey,
                              ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ModernDatePicker(
            label: 'Date de réalisation de la visite',
            selectedDate: _dateService,
            prefixIcon: Icons.event_outlined,
            required: true,
            hint: 'Quand avez-vous effectué cette visite technique?',
            firstDate: DateTime.now().subtract(const Duration(days: 730)),
            lastDate: DateTime.now(),
            onDateSelected: (date) {
              setState(() {
                _dateService = date;
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _immatriculationController.dispose();
    _marqueController.dispose();
    _modeleController.dispose();
    _anneeController.dispose();
    _kilometrageController.dispose();
    super.dispose();
  }

  bool isFormValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  Future<Service> createService() async {
    final serviceService = ServiceService();
    return serviceService.createServiceFromFormData(
      userId: 'current_user',
      type: 'visite_technique',
      nom: _nomController.text,
      prenom: _prenomController.text,
      telephone: _telephoneController.text,
      immatriculation: _immatriculationController.text,
      marque: _marqueController.text,
      modele: _modeleController.text,
      serviceDate: _dateService ?? DateTime.now(),
      additionalDetails: {
        'annee': _anneeController.text,
        'kilometrage': _kilometrageController.text,
        'typeVisite': _typeVisite,
        'centreVisite': _centreVisite,
        'datePreferee': _datePreferee?.toIso8601String(),
      },
    );
  }
}
