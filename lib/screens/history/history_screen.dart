import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/routes/app_routes.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock history data
    final List<ScanHistoryItem> historyItems = [
      ScanHistoryItem(
        id: '1',
        productName: 'Organic Green Tea',
        classification: 'halal',
        scanDate: DateTime.now().subtract(const Duration(hours: 2)),
        ingredientCount: 4,
      ),
      ScanHistoryItem(
        id: '2',
        productName: 'Chocolate Cookies',
        classification: 'doubtful',
        scanDate: DateTime.now().subtract(const Duration(days: 1)),
        ingredientCount: 12,
      ),
      ScanHistoryItem(
        id: '3',
        productName: 'Almond Milk',
        classification: 'vegan',
        scanDate: DateTime.now().subtract(const Duration(days: 2)),
        ingredientCount: 6,
      ),
      ScanHistoryItem(
        id: '4',
        productName: 'Gummy Bears',
        classification: 'haram',
        scanDate: DateTime.now().subtract(const Duration(days: 3)),
        ingredientCount: 8,
      ),
    ];

    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            // App Bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Scan History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                    // Clear All Button
                    if (historyItems.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Clear History'),
                              content: Text(
                                'Are you sure you want to clear all scan history?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // TODO: Clear history
                                  },
                                  child: Text(
                                    'Clear',
                                    style: TextStyle(color: AppTheme.error),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            color: AppTheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: historyItems.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: historyItems.length,
                      itemBuilder: (context, index) {
                        final item = historyItems[index];
                        return _buildHistoryCard(context, item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history,
              size: 50,
              color: AppTheme.textMuted.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No scan history',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your scanned products will appear here',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, ScanHistoryItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.result,
          arguments: {
            'productName': item.productName,
            'classification': item.classification,
            'ingredients': [],
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Classification Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getClassificationColor(item.classification).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _getClassificationIcon(item.classification),
                color: _getClassificationColor(item.classification),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildInfoChip(
                        _getClassificationLabel(item.classification),
                        _getClassificationColor(item.classification),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${item.ingredientCount} ingredients',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(item.scanDate),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getClassificationColor(String classification) {
    switch (classification.toLowerCase()) {
      case 'halal':
        return AppTheme.halalGreen;
      case 'haram':
        return AppTheme.haramRed;
      case 'doubtful':
      case 'shubhah':
        return AppTheme.shubhahOrange;
      case 'vegan':
        return AppTheme.veganGreen;
      case 'vegetarian':
        return AppTheme.vegetarianGreen;
      case 'kosher':
        return AppTheme.kosherBlue;
      default:
        return AppTheme.primaryOrange;
    }
  }

  IconData _getClassificationIcon(String classification) {
    switch (classification.toLowerCase()) {
      case 'halal':
        return Icons.check_circle;
      case 'haram':
        return Icons.cancel;
      case 'doubtful':
      case 'shubhah':
        return Icons.help_outline;
      case 'vegan':
        return Icons.eco;
      case 'vegetarian':
        return Icons.grass;
      case 'kosher':
        return Icons.star;
      default:
        return Icons.restaurant;
    }
  }

  String _getClassificationLabel(String classification) {
    switch (classification.toLowerCase()) {
      case 'halal':
        return 'Halal';
      case 'haram':
        return 'Haram';
      case 'doubtful':
      case 'shubhah':
        return 'Doubtful';
      case 'vegan':
        return 'Vegan';
      case 'vegetarian':
        return 'Vegetarian';
      case 'kosher':
        return 'Kosher';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class ScanHistoryItem {
  final String id;
  final String productName;
  final String classification;
  final DateTime scanDate;
  final int ingredientCount;

  ScanHistoryItem({
    required this.id,
    required this.productName,
    required this.classification,
    required this.scanDate,
    required this.ingredientCount,
  });
}

