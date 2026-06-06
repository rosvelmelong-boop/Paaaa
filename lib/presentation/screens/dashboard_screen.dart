import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../widgets/propveil_card.dart';

class NativeDashboardScreen extends StatelessWidget {
  const NativeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: PropveilTheme.canvasNavy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Bar row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PropVeil',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                          color: PropveilTheme.tealAccent,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: PropveilTheme.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'CAMEROON · OHADA-COMPLIANT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: PropveilTheme.textSecondary,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: PropveilTheme.surfaceNavy,
                        child: Text(
                          'JD',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: PropveilTheme.tealAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Welcome Text
              Text(
                'Welcome Back, Landlord',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Here is your portfolio performance for June 2026',
                style: TextStyle(
                  color: PropveilTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Primary Metric (Yield/Gross Collected)
              PropveilCard(
                hasGlow: true,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL RENT COLLECTED',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: PropveilTheme.textSecondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Icon(
                          Icons.trending_up,
                          color: PropveilTheme.success,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'XAF 1,250,000',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: PropveilTheme.borderSubtle.withOpacity(0.5)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PropVeil Fee (6%)',
                              style: TextStyle(
                                fontSize: 12,
                                color: PropveilTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '- XAF 75,000',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: PropveilTheme.danger.withOpacity(0.9),
                                fontFeatures: [const FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Net Payout',
                              style: TextStyle(
                                fontSize: 12,
                                color: PropveilTheme.tealAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'XAF 1,175,000',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: PropveilTheme.success,
                                fontFeatures: [const FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Secondary Metrics (Pending, Expenses, Occupancy)
              Row(
                children: [
                  Expanded(
                    child: PropveilCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PENDING RENT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: PropveilTheme.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'XAF 450,000',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              fontFeatures: [const FontFeature.tabularFigures()],
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '3 units due soon',
                            style: TextStyle(
                              fontSize: 11,
                              color: PropveilTheme.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PropveilCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'OCCUPANCY RATE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: PropveilTheme.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '83.3%',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '5/6 units occupied',
                            style: TextStyle(
                              fontSize: 11,
                              color: PropveilTheme.tealAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              Text(
                'QUICK ACTIONS',
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 1.0,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickActionItem(
                    icon: Icons.payments_outlined,
                    label: 'Collect Rent',
                    color: PropveilTheme.tealAccent,
                    onTap: () {},
                  ),
                  _buildQuickActionItem(
                    icon: Icons.add_home_work_outlined,
                    label: 'Add Property',
                    color: PropveilTheme.goldAccent,
                    onTap: () {},
                  ),
                  _buildQuickActionItem(
                    icon: Icons.person_add_alt_outlined,
                    label: 'Add Tenant',
                    color: PropveilTheme.success,
                    onTap: () {},
                  ),
                  _buildQuickActionItem(
                    icon: Icons.psychology_outlined,
                    label: 'AI Hub',
                    color: PropveilTheme.coralAccent,
                    onTap: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: 28),
              
              // Recent Alerts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PORTFOLIO ALERTS',
                    style: theme.textTheme.labelLarge?.copyWith(
                      letterSpacing: 1.0,
                      fontSize: 11,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: PropveilTheme.tealAccent,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('View All', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              PropveilCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    _buildAlertItem(
                      icon: Icons.warning_amber_rounded,
                      iconColor: PropveilTheme.warning,
                      title: 'Late Rent: Jean Talla',
                      subtitle: 'Unit B-3 · XAF 150,000 overdue by 3 days',
                    ),
                    const Divider(color: PropveilTheme.borderSubtle, height: 16),
                    _buildAlertItem(
                      icon: Icons.build_circle_outlined,
                      iconColor: PropveilTheme.coralAccent,
                      title: 'New Maintenance Ticket',
                      subtitle: 'Kitchen Sink Leak · Résidence Bonamoussadi',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: PropveilTheme.surfaceNavy,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PropveilTheme.borderSubtle),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: PropveilTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: PropveilTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: PropveilTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: PropveilTheme.textTertiary, size: 16),
      ],
    );
  }
}
