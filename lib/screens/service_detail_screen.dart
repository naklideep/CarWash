import 'package:flutter/material.dart';
import 'select_car_type_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ServiceDetailScreen extends StatelessWidget {
  final String serviceType;

  const ServiceDetailScreen({super.key, required this.serviceType});

  Map<String, dynamic> getServiceData() {
    switch (serviceType) {
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
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: const Color(0xFF00897B),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        serviceType,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
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
                      // Service Header Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF26C6DA).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                icon,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Service Duration',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
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
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Service Includes Section
                      const Text(
                        'Service Includes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Features List
                      ...features.map((feature) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF26C6DA).withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF26C6DA), Color(0xFF00897B)],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feature['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feature['desc']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF26C6DA), Color(0xFF00897B)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF26C6DA).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  // 🔥 FIRESTORE WRITE
                  await FirebaseFirestore.instance
                      .collection('service_detail_views')
                      .add({
                    'serviceName': serviceType,
                    'duration': duration,
                    'viewedAt': Timestamp.now(),
                  });

                  // ➡️ SAME NAVIGATION (UNCHANGED)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SelectCarTypeScreen(serviceType: serviceType),
                    ),
                  );
                },

                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Select Car Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}