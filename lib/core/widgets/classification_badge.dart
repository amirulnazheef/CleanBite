import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ClassificationType {
  halal,
  haram,
  shubhah,
  vegan,
  vegetarian,
  kosher,
  allergen,
}

class ClassificationBadge extends StatelessWidget {
  final ClassificationType type;
  final bool isLarge;

  const ClassificationBadge({
    super.key,
    required this.type,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 20 : 12,
        vertical: isLarge ? 10 : 6,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            color: Colors.white,
            size: isLarge ? 20 : 16,
          ),
          const SizedBox(width: 6),
          Text(
            _getLabel(),
            style: TextStyle(
              color: Colors.white,
              fontSize: isLarge ? 16 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ClassificationType.halal:
        return AppTheme.halalGreen;
      case ClassificationType.haram:
        return AppTheme.haramRed;
      case ClassificationType.shubhah:
        return AppTheme.shubhahOrange;
      case ClassificationType.vegan:
        return AppTheme.veganGreen;
      case ClassificationType.vegetarian:
        return AppTheme.vegetarianGreen;
      case ClassificationType.kosher:
        return AppTheme.kosherBlue;
      case ClassificationType.allergen:
        return AppTheme.error;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case ClassificationType.halal:
        return Icons.check_circle;
      case ClassificationType.haram:
        return Icons.cancel;
      case ClassificationType.shubhah:
        return Icons.help_outline;
      case ClassificationType.vegan:
        return Icons.eco;
      case ClassificationType.vegetarian:
        return Icons.grass;
      case ClassificationType.kosher:
        return Icons.star_outline;
      case ClassificationType.allergen:
        return Icons.warning;
    }
  }

  String _getLabel() {
    switch (type) {
      case ClassificationType.halal:
        return 'Halal';
      case ClassificationType.haram:
        return 'Haram';
      case ClassificationType.shubhah:
        return 'Doubtful';
      case ClassificationType.vegan:
        return 'Vegan';
      case ClassificationType.vegetarian:
        return 'Vegetarian';
      case ClassificationType.kosher:
        return 'Kosher';
      case ClassificationType.allergen:
        return 'Allergen';
    }
  }
}

