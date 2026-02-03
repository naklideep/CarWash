import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/service_model.dart';
import '../utils/app_theme.dart';
import 'booking_screen.dart';

class ServicesScreen extends StatelessWidget {
  final String category;
  final String? selectedServiceId;

  const ServicesScreen({
    super.key,
    required this.category,
    this.selectedServiceId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category == 'wash' ? 'Car Wash Services' : 'Ceramic Coating',
        ),
      ),
      body: StreamBuilder<List<ServiceModel>>(
        stream: FirestoreService().getServicesByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No services available',
                    style: AppTheme.heading3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please check back later',
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          final services = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              final isSelected = service.id == selectedServiceId;

              return ServiceDetailCard(
                service: service,
                isHighlighted: isSelected,
              );
            },
          );
        },
      ),
    );
  }
}

class ServiceDetailCard extends StatelessWidget {
  final ServiceModel service;
  final bool isHighlighted;

  const ServiceDetailCard({
    super.key,
    required this.service,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isHighlighted ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isHighlighted
            ? BorderSide(color: AppTheme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Service Image/Icon
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: service.category == 'wash'
                    ? [AppTheme.secondaryColor, AppTheme.secondaryColor.withOpacity(0.7)]
                    : [AppTheme.accentColor, AppTheme.accentColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Icon(
                service.category == 'wash'
                    ? Icons.local_car_wash
                    : Icons.auto_awesome,
                size: 80,
                color: Colors.white,
              ),
            ),
          ),

          // Service Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: AppTheme.heading3,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '₹${service.price.toStringAsFixed(0)}',
                        style: AppTheme.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  service.description,
                  style: AppTheme.bodyMedium,
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.access_time,
                      label: '${service.durationMinutes} mins',
                    ),
                    const SizedBox(width: 12),
                    _InfoChip(
                      icon: Icons.verified,
                      label: 'Professional',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(service: service),
                        ),
                      );
                    },
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}