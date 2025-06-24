import 'package:flutter/material.dart';
import '../../core/theme/theme_extensions.dart';
import '../../models/hint_system.dart';
import '../../utils/constants.dart';

class HintPopup extends StatefulWidget {
  final MultiplicationHint hint;
  final String currentLanguage;
  final VoidCallback onClose;

  const HintPopup({
    super.key,
    required this.hint,
    required this.currentLanguage,
    required this.onClose,
  });

  @override
  State<HintPopup> createState() => _HintPopupState();
}

class _HintPopupState extends State<HintPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _closePopup() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closePopup,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          children: [
            // Background tap to close
            Positioned.fill(
              child: GestureDetector(
                onTap: _closePopup,
                child: Container(color: Colors.transparent),
              ),
            ),
            
            // Popup content
            Align(
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    margin: const EdgeInsets.all(AppSpacing.md),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: AppBorderRadius.large,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with close button
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                                                     decoration: BoxDecoration(
                             color: context.colors.primary.withOpacity(0.1),
                             borderRadius: const BorderRadius.only(
                               topLeft: Radius.circular(AppBorderRadius.lg),
                               topRight: Radius.circular(AppBorderRadius.lg),
                             ),
                           ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.hint.title[widget.currentLanguage] ?? 
                                  widget.hint.title['ru']!,
                                  style: AppTextStyles.h3.copyWith(
                                    color: context.colors.onSurface,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _closePopup,
                                icon: Icon(
                                  Icons.close,
                                  color: context.colors.onSurface,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: context.colors.surface.withOpacity(0.8),
                                  minimumSize: const Size(32, 32),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Content
                        Flexible(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Description
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: context.colors.secondary.withOpacity(0.1),
                                    borderRadius: AppBorderRadius.medium,
                                    border: Border.all(
                                      color: context.colors.secondary.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    widget.hint.description[widget.currentLanguage] ?? 
                                    widget.hint.description['ru']!,
                                    style: AppTextStyles.body2.copyWith(
                                      color: context.colors.onSurface,
                                      height: 1.4,
                                      decoration: TextDecoration.none,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                
                                const SizedBox(height: AppSpacing.lg),
                                
                                // Technique section
                                _buildSection(
                                  title: widget.currentLanguage == 'ru' 
                                      ? 'Техники запоминания 🎯'
                                      : widget.currentLanguage == 'en'
                                          ? 'Memory Techniques 🎯'
                                          : 'Merktechniken 🎯',
                                  content: widget.hint.technique[widget.currentLanguage] ?? 
                                           widget.hint.technique['ru']!,
                                  backgroundColor: context.colors.warning.withOpacity(0.1),
                                  borderColor: context.colors.warning.withOpacity(0.3),
                                ),
                                
                                const SizedBox(height: AppSpacing.lg),
                                
                                // Visualization section
                                _buildSection(
                                  title: widget.currentLanguage == 'ru' 
                                      ? 'Визуализация 🎨'
                                      : widget.currentLanguage == 'en'
                                          ? 'Visualization 🎨'
                                          : 'Visualisierung 🎨',
                                  content: widget.hint.visualization[widget.currentLanguage] ?? 
                                           widget.hint.visualization['ru']!,
                                  backgroundColor: context.colors.tertiary,
                                  borderColor: context.colors.primary.withOpacity(0.3),
                                ),
                                

                              ],
                            ),
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
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body2.copyWith(
              color: context.colors.onSurface,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
                      Text(
              content,
              style: AppTextStyles.body2.copyWith(
                color: context.colors.onSurface,
                height: 1.4,
                decoration: TextDecoration.none,
              ),
            ),
        ],
      ),
    );
  }
} 