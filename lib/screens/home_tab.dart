import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import 'service_detail_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GO CLEANZ'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Services',
              style: AppTheme.heading2,
            ),
            const SizedBox(height: 16),

            _ServiceSection(
              title: 'Half Wash',
              subtitle: 'Exterior Foam Wash + Tyre Polishing',
              priceFrom: 300,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const ServiceDetailScreen(serviceType: 'Half Wash'),
                  ),
                );
              },
            ),

            _ServiceSection(
              title: 'Full Wash',
              subtitle: 'Interior + Exterior Cleaning',
              priceFrom: 500,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const ServiceDetailScreen(serviceType: 'Full Wash'),
                  ),
                );
              },
            ),

            _ServiceSection(
              title: 'GO CLEANZ – Premium',
              subtitle: 'Steam Wash + Sanitization',
              priceFrom: 600,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const ServiceDetailScreen(serviceType: 'Premium'),
                  ),
                );
              },
            ),

            _ServiceSection(
              title: 'GO CLEANZ – Pro',
              subtitle: 'Rubbing, Polishing & Deep Cleaning',
              priceFrom: 1600,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const ServiceDetailScreen(serviceType: 'Pro'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final int priceFrom;
  final VoidCallback onTap;

  const _ServiceSection({
    required this.title,
    required this.subtitle,
    required this.priceFrom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.heading3,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: AppTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'From ₹$priceFrom',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.successColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
