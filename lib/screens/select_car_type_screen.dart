import 'package:flutter/material.dart';
import 'slot_booking_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SelectCarTypeScreen extends StatelessWidget {
  final String serviceType;

  const SelectCarTypeScreen({super.key, required this.serviceType});

  @override
  Widget build(BuildContext context) {
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
                    const Expanded(
                      child: Text(
                        'Select Car Type',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose your vehicle type for $serviceType',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Car Type Cards
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _carTypeTile(
                      context,
                      'Hatchback / Sedan',
                      500,
                      Icons.directions_car_rounded,
                      'Compact & mid-size vehicles',
                      const LinearGradient(
                        colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
                      ),
                    ),
                    _carTypeTile(
                      context,
                      'SUV / Premium',
                      600,
                      Icons.airport_shuttle_rounded,
                      'Large vehicles & luxury cars',
                      const LinearGradient(
                        colors: [Color(0xFF26C6DA), Color(0xFF00897B)],
                      ),
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

  Widget _carTypeTile(
      BuildContext context,
      String type,
      int price,
      IconData icon,
      String description,
      Gradient gradient,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26C6DA).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            // 🔥 WRITE SELECTION TO FIRESTORE
            await FirebaseFirestore.instance
                .collection('car_type_selections')
                .add({
              'serviceType': serviceType,
              'carType': type,
              'price': price,
              'selectedAt': Timestamp.now(),
            });

            // ➡️ SAME NAVIGATION (UNCHANGED)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SlotBookingScreen(
                  serviceType: serviceType,
                  carType: type,
                  price: price,
                ),
              ),
            );
          },

          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Car Icon with Gradient
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF26C6DA).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 36,
                  ),
                ),

                const SizedBox(width: 20),

                // Car Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF26C6DA).withOpacity(0.2),
                                  const Color(0xFF00897B).withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.currency_rupee,
                                  size: 16,
                                  color: Color(0xFF00897B),
                                ),
                                Text(
                                  '$price',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00897B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF26C6DA).withOpacity(0.15),
                        const Color(0xFF00897B).withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: Color(0xFF00897B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}