import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class ServiceModal extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;
  final VoidCallback? onSubmit;
  final String submitText;
  final bool Function()? isFormValid;

  const ServiceModal({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
    this.onSubmit,
    this.submitText = 'Valider',
    this.isFormValid,
  });

  @override
  State<ServiceModal> createState() => _ServiceModalState();
}

class _ServiceModalState extends State<ServiceModal>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _slideController;
  late AnimationController _buttonController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonScaleAnimation;
  bool _isFormValid = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _buttonScaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _slideController.forward();

    // Check form validity periodically
    _checkFormValidity();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    // Check form validity every 500ms
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && widget.isFormValid != null) {
        final isValid = widget.isFormValid!();
        if (isValid != _isFormValid) {
          setState(() {
            _isFormValid = isValid;
          });
          if (isValid) {
            _buttonController.forward();
          } else {
            _buttonController.reverse();
          }
        }
        _checkFormValidity(); // Continue checking
      }
    });
  }

  void _closeModal() async {
    await _slideController.reverse();
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background overlay
          FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: _closeModal,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),
          // Modal content
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.color.withValues(alpha: 0.1),
                              widget.color.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: widget.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                widget.icon,
                                color: widget.color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimaryColor,
                                    ),
                              ),
                            ),
                            IconButton(
                              onPressed: _closeModal,
                              icon: const Icon(Icons.close),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey.withValues(alpha: 0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Content
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: widget.child,
                        ),
                      ),
                      // Footer with action button
                      if (widget.onSubmit != null)
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.05),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Enhanced form validation indicator
                              if (widget.isFormValid != null)
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _isFormValid 
                                          ? [Colors.green.withValues(alpha: 0.15), Colors.green.withValues(alpha: 0.05)]
                                          : [Colors.orange.withValues(alpha: 0.15), Colors.orange.withValues(alpha: 0.05)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _isFormValid 
                                          ? Colors.green.withValues(alpha: 0.4)
                                          : Colors.orange.withValues(alpha: 0.4),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (_isFormValid ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AnimatedRotation(
                                        turns: _isFormValid ? 0 : 0.1,
                                        duration: const Duration(milliseconds: 300),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: (_isFormValid ? Colors.green : Colors.orange).withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            _isFormValid 
                                                ? Icons.check_circle_rounded
                                                : Icons.info_rounded,
                                            color: _isFormValid 
                                                ? Colors.green.shade700
                                                : Colors.orange.shade700,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: Text(
                                          _isFormValid 
                                              ? '✨ Formulaire complet et prêt'
                                              : '📝 Veuillez compléter tous les champs requis',
                                          style: TextStyle(
                                            color: _isFormValid 
                                                ? Colors.green.shade700
                                                : Colors.orange.shade700,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 16),
                              // Submit button with enhanced design
                              ScaleTransition(
                                scale: _buttonScaleAnimation,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: _isFormValid 
                                        ? LinearGradient(
                                            colors: [
                                              widget.color,
                                              widget.color.withValues(alpha: 0.8),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    boxShadow: _isFormValid ? [
                                      BoxShadow(
                                        color: widget.color.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ] : null,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isSubmitting ? null : () async {
                                      if (widget.isFormValid == null || widget.isFormValid!()) {
                                        setState(() {
                                          _isSubmitting = true;
                                        });
                                        
                                        // Add haptic feedback
                                        HapticFeedback.mediumImpact();
                                        
                                        // Call the submit function
                                        widget.onSubmit?.call();
                                        
                                        if (mounted) {
                                          setState(() {
                                            _isSubmitting = false;
                                          });
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _isFormValid 
                                          ? Colors.transparent
                                          : Colors.grey.shade300,
                                      foregroundColor: _isFormValid ? Colors.white : Colors.grey.shade600,
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: _isSubmitting
                                          ? Row(
                                              key: const ValueKey('loading'),
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      _isFormValid ? Colors.white : Colors.grey.shade600
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Enregistrement en cours...',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: _isFormValid ? Colors.white : Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              key: const ValueKey('submit'),
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                AnimatedRotation(
                                                  turns: _isFormValid ? 0 : 0.5,
                                                  duration: const Duration(milliseconds: 300),
                                                  child: Icon(
                                                    _isFormValid 
                                                        ? Icons.check_circle_rounded
                                                        : Icons.lock_rounded,
                                                    size: 22,
                                                    color: _isFormValid ? Colors.white : Colors.grey.shade600,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  widget.submitText,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: _isFormValid ? Colors.white : Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
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
          ),
        ],
      ),
    );
  }
}

// Helper function to show service modal
void showServiceModal(
  BuildContext context, {
  required String title,
  required IconData icon,
  required Color color,
  required Widget child,
  VoidCallback? onSubmit,
  String submitText = 'Valider',
  bool Function()? isFormValid,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return ServiceModal(
        title: title,
        icon: icon,
        color: color,
        onSubmit: onSubmit,
        submitText: submitText,
        isFormValid: isFormValid,
        child: child,
      );
    },
  );
}
