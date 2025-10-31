import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Liquid Glass Button Widget
/// Features:
/// - Semi-transparent glassmorphism effect
/// - Backdrop blur filter
/// - Soft glow animation on press
/// - Rounded corners
/// - Customizable colors and sizes
class LiquidGlassButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool isOutlined;

  const LiquidGlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.icon,
    this.width,
    this.height,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  State<LiquidGlassButton> createState() => _LiquidGlassButtonState();
}

class _LiquidGlassButtonState extends State<LiquidGlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppTheme.primaryButton;
    final textColor = widget.textColor ?? AppTheme.textWhite;

    return GestureDetector(
      onTapDown: widget.isLoading ? null : _handleTapDown,
      onTapUp: widget.isLoading ? null : _handleTapUp,
      onTapCancel: widget.isLoading ? null : _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height ?? 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: [
                  // Soft glow effect
                  BoxShadow(
                    color: buttonColor.withOpacity(0.3),
                    blurRadius: _glowAnimation.value,
                    spreadRadius: _glowAnimation.value / 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: AppTheme.glassBlur,
                    sigmaY: AppTheme.glassBlur,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      // Liquid glass effect
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isOutlined
                            ? [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                              ]
                            : [
                                buttonColor.withOpacity(0.9),
                                buttonColor.withOpacity(0.7),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      border: widget.isOutlined
                          ? Border.all(
                              color: buttonColor.withOpacity(0.5),
                              width: 2,
                            )
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.isLoading ? null : widget.onPressed,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                        splashColor: Colors.white.withOpacity(0.2),
                        highlightColor: Colors.white.withOpacity(0.1),
                        child: Center(
                          child: widget.isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      textColor,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (widget.icon != null) ...[
                                      Icon(
                                        widget.icon,
                                        color: widget.isOutlined
                                            ? buttonColor
                                            : textColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(
                                      widget.text,
                                      style: AppTheme.buttonText.copyWith(
                                        color: widget.isOutlined
                                            ? buttonColor
                                            : textColor,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Small Liquid Glass Icon Button
class LiquidGlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double size;

  const LiquidGlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 48,
  });

  @override
  State<LiquidGlassIconButton> createState() => _LiquidGlassIconButtonState();
}

class _LiquidGlassIconButtonState extends State<LiquidGlassIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.color ?? AppTheme.primaryButton;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          buttonColor.withOpacity(0.9),
                          buttonColor.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Icon(
                      widget.icon,
                      color: AppTheme.textWhite,
                      size: widget.size * 0.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
