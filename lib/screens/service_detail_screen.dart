import 'package:flutter/material.dart';
import 'select_car_type_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceType;

  const ServiceDetailScreen({super.key, required this.serviceType});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {

  Map<String, dynamic> getServiceData() {
    switch (widget.serviceType) {
      case 'Half Wash':
        return {
          'features': [
            {'title': 'Exterior Foam Wash', 'desc': 'Premium foam cleaning'},
            {'title': 'Tyre Polishing', 'desc': 'Deep black shine'},
          ],
          'icon': Icons.water_drop_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
          ),
          'duration': '30 mins',
        };

      case 'Full Wash':
        return {
          'features': [
            {'title': 'Interior Cleaning', 'desc': 'Complete dashboard & seats'},
            {'title': 'Vacuum Cleaning', 'desc': 'Deep carpet cleaning'},
            {'title': 'AC Vents', 'desc': 'Dust removal & freshening'},
          ],
          'icon': Icons.local_car_wash_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
          ),
          'duration': '45 mins',
        };

      case 'Premium':
        return {
          'features': [
            {'title': 'Steam Wash', 'desc': 'Chemical-free deep cleaning'},
            {'title': 'Sanitization', 'desc': 'Complete disinfection'},
            {'title': 'Engine Bay', 'desc': 'Engine compartment cleaning'},
          ],
          'icon': Icons.stars_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFF00ACC1), Color(0xFF00897B)],
          ),
          'duration': '60 mins',
        };

      case 'Pro':
        return {
          'features': [
            {'title': 'Rubbing & Polishing', 'desc': 'Mirror-like finish'},
            {'title': 'Deep Cleaning', 'desc': 'Every corner detailed'},
            {'title': 'Wax Coating', 'desc': 'Long-lasting protection'},
          ],
          'icon': Icons.auto_awesome_rounded,
          'gradient': const LinearGradient(
            colors: [Color(0xFF00897B), Color(0xFF00695C)],
          ),
          'duration': '90 mins',
        };

      default:
        return {
          'features': [],
          'icon': Icons.local_car_wash,
          'gradient': const LinearGradient(
            colors: [Color(0xFF26C6DA), Color(0xFF00897B)],
          ),
          'duration': '30 mins',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceData = getServiceData();
    final features = serviceData['features'] as List<Map<String, String>>;
    final icon = serviceData['icon'] as IconData;
    final gradient = serviceData['gradient'] as Gradient;
    final duration = serviceData['duration'] as String;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF26C6DA).withOpacity(0.1),
              const Color(0xFF00897B).withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: const Color(0xFF00897B),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.serviceType,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(icon, color: Colors.white, size: 40),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Service Duration',
                                    style: TextStyle(color: Colors.white70)),
                                Text(
                                  duration,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Text('Service Includes',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      ...features.map(
                            (feature) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Color(0xFF00897B)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(feature['title']!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(feature['desc']!,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ✅ SAME BUTTON — SAME UI — SAME FLOW
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32), // 👈 more bottom padding
        child: SizedBox(
          height: 42,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SelectCarTypeScreen(serviceType: widget.serviceType),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF26C6DA), Color(0xFF00897B)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Select Car Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}