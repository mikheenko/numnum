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
        color: Colors.black.withOpacity(0.4),
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
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: AppBorderRadius.large,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with close button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg, AppSpacing.lg, AppSpacing.md, AppSpacing.md,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.hint.title[widget.currentLanguage] ?? 
                                  widget.hint.title['ru']!,
                                  style: AppTextStyles.body2.copyWith(
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
                                  size: 24,
                                ),
                                style: IconButton.styleFrom(
                                  minimumSize: const Size(40, 40),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Divider
                        Container(
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: context.colors.dividerColor,
                          ),
                        ),
                        
                        // Content
                        Flexible(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Description
                                Text(
                                  widget.hint.description[widget.currentLanguage] ?? 
                                  widget.hint.description['ru']!,
                                  style: AppTextStyles.body2.copyWith(
                                    color: context.colors.onSurface,
                                    height: 1.5,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                
                                const SizedBox(height: AppSpacing.lg),
                                
                                // Technique section
                                _buildMinimalSection(
                                  title: widget.currentLanguage == 'ru' 
                                      ? 'Техники запоминания'
                                      : widget.currentLanguage == 'en'
                                          ? 'Memory Techniques'
                                          : 'Merktechniken',
                                  content: widget.hint.technique[widget.currentLanguage] ?? 
                                           widget.hint.technique['ru']!,
                                ),
                                
                                const SizedBox(height: AppSpacing.lg),
                                
                                // Visualization section
                                _buildMinimalSection(
                                  title: widget.currentLanguage == 'ru' 
                                      ? 'Визуализация'
                                      : widget.currentLanguage == 'en'
                                          ? 'Visualization'
                                          : 'Visualisierung',
                                  content: widget.hint.visualization[widget.currentLanguage] ?? 
                                           widget.hint.visualization['ru']!,
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

  Widget _buildMinimalSection({
    required String title,
    required String content,
  }) {
    return Column(
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
        const SizedBox(height: AppSpacing.md),
        ..._buildContentWidgets(content),
      ],
    );
  }

  List<Widget> _buildContentWidgets(String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];
    
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      
      // Check if this is a list item (starts with • or similar)
      if (line.trim().startsWith('•') || line.trim().startsWith('◆') || line.trim().startsWith('🔹')) {
        final itemText = line.trim().startsWith('🔹') 
            ? line.trim().substring(2).trim() // emoji takes 2 characters
            : line.trim().substring(1).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.xs,
              bottom: AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: AppTextStyles.body2.fontSize! * 0.7), // Центрируем по первой строке
                  child: Container(
                    width: 4.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: context.colors.onSurface,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    itemText,
                    style: AppTextStyles.body2.copyWith(
                      color: context.colors.onSurface,
                      height: 1.5,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Regular text
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Text(
              line,
              style: AppTextStyles.body2.copyWith(
                color: context.colors.onSurface,
                height: 1.5,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );
      }
    }
    
    return widgets;
  }
} 