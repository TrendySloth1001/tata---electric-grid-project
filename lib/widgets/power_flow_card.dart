import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'dart:math' as math;

class PowerFlowCard extends StatelessWidget {
  final double currentFlow;
  final double voltage;
  final double frequency;
  final PowerDirection direction;
  final double stability;

  const PowerFlowCard({
    super.key,
    required this.currentFlow,
    required this.voltage,
    required this.frequency,
    required this.direction,
    required this.stability,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero, // Remove card margin
      color: AppTheme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppTheme.darkPrimaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live Power Flow',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: direction == PowerDirection.incoming
                        ? AppTheme.darkSecondaryColor.withOpacity(0.2)
                        : AppTheme.warningYellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    direction == PowerDirection.incoming ? 'Incoming' : 'Outgoing',
                    style: textTheme.labelMedium?.copyWith(
                      color: direction == PowerDirection.incoming
                          ? AppTheme.darkSecondaryColor
                          : AppTheme.warningYellow,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: _buildFlowIndicator(),
            ),
            const SizedBox(height: 16),
            _buildStabilityBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowIndicator() {
    return SizedBox(
      width: 120,
      height: 120,
      child: CustomPaint(
        painter: PowerFlowPainter(
          direction: direction,
          flowRate: currentFlow / 150.0, // Normalized flow rate
        ),
      ),
    );
  }

  Widget _buildStabilityBar(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Grid Stability',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              '${(stability * 100).toStringAsFixed(1)}%',
              style: textTheme.labelMedium?.copyWith(
                color: stability > 0.7
                    ? AppTheme.secondaryColor
                    : AppTheme.warningYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: stability,
            backgroundColor: colorScheme.surface.withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
              stability > 0.7 ? AppTheme.secondaryColor : AppTheme.warningYellow,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class PowerFlowPainter extends CustomPainter {
  final PowerDirection direction;
  final double flowRate;

  PowerFlowPainter({required this.direction, required this.flowRate});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    // Draw circle
    canvas.drawCircle(center, radius, paint);

    // Draw flow arrows
    _drawFlowArrows(canvas, size, paint);
  }

  void _drawFlowArrows(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    
    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2) + (direction == PowerDirection.incoming ? 0 : math.pi);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      final arrowStart = Offset(
        center.dx + (radius * 0.5) * math.cos(angle),
        center.dy + (radius * 0.5) * math.sin(angle),
      );
      final arrowEnd = Offset(x, y);
      
      canvas.drawLine(arrowStart, arrowEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

enum PowerDirection { incoming, outgoing }
