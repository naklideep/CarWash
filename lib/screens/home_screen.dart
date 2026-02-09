import 'package:flutter/material.dart';
import 'appointments_screen.dart';
import 'profile_screen.dart';
import 'service_detail_screen.dart';
import 'slot_booking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    AppointmentsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: const Color(0xFF00897B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_rounded),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool isCarSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF26C6DA).withOpacity(0.15),
            const Color(0xFF00897B).withOpacity(0.05),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            const LinearGradient(
                              colors: [
                                Color(0xFF26C6DA),
                                Color(0xFF00897B),
                              ],
                            ).createShader(bounds),
                        child: const Text(
                          'GO CLEANZ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Fresh & Clean Every Time',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () =>
                        setState(() => isCarSelected = !isCarSelected),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF26C6DA),
                            Color(0xFF00897B),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isCarSelected
                            ? Icons.directions_car_rounded
                            : Icons.two_wheeler_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SERVICES
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: isCarSelected
                    ? _carServices(context)
                    : _bikeServices(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CAR SERVICES =================
  List<Widget> _carServices(BuildContext context) => [
    _ServiceTile(
      title: 'Half Wash',
      price: '₹300',
      icon: Icons.water_drop_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
      ),
      points: const ['Exterior Foam Wash', 'Tyre Polishing'],
      onTap: () => _goCar(context, 'Half Wash'),
    ),
    _ServiceTile(
      title: 'Full Wash',
      price: '₹500',
      icon: Icons.local_car_wash_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
      ),
      points: const [
        'Interior + Exterior',
        'Vacuum Cleaning',
        'AC Vents'
      ],
      onTap: () => _goCar(context, 'Full Wash'),
    ),
    _ServiceTile(
      title: 'Premium',
      price: '₹600',
      icon: Icons.stars_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF00ACC1), Color(0xFF00897B)],
      ),
      points: const [
        'Steam Wash',
        'Sanitization',
        'Engine Bay'
      ],
      onTap: () => _goCar(context, 'Premium'),
    ),
    _ServiceTile(
      title: 'Pro',
      price: '₹1600',
      icon: Icons.auto_awesome_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF00897B), Color(0xFF00695C)],
      ),
      points: const [
        'Rubbing & Polishing',
        'Deep Cleaning',
        'Wax Coating'
      ],
      onTap: () => _goCar(context, 'Pro'),
    ),
    const SizedBox(height: 16),
  ];

  // ================= BIKE SERVICES =================
  List<Widget> _bikeServices(BuildContext context) => [
    _ServiceTile(
      title: 'Two-Wheeler Wash',
      price: '₹100',
      icon: Icons.two_wheeler_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF4DD0E1), Color(0xFF26C6DA)],
      ),
      points: const ['Exterior Wash', 'Chain Cleaning'],
      onTap: () => _goBike(context, 'Two-Wheeler Wash', 100),
    ),
    _ServiceTile(
      title: 'Ceramic Coating',
      price: '₹3000',
      icon: Icons.auto_awesome,
      gradient: const LinearGradient(
        colors: [Color(0xFF26C6DA), Color(0xFF00ACC1)],
      ),
      points: const ['3 Years Protection', 'High Gloss Finish'],
      onTap: () => _goBike(context, 'Ceramic Coating (3 Years)', 3000),
    ),
    _ServiceTile(
      title: 'Ceramic Coating',
      price: '₹2500',
      icon: Icons.stars,
      gradient: const LinearGradient(
        colors: [Color(0xFF00897B), Color(0xFF00695C)],
      ),
      points: const ['5 Years Protection', 'Scratch Resistance'],
      onTap: () => _goBike(context, 'Ceramic Coating (5 Years)', 2500),
    ),
    const SizedBox(height: 16),
  ];

  // ================= NAVIGATION =================
  void _goCar(BuildContext context, String service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceDetailScreen(serviceType: service),
      ),
    );
  }

  void _goBike(BuildContext context, String service, int price) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SlotBookingScreen(
          serviceType: service,
          carType: 'Bike',
          price: price,
        ),
      ),
    );
  }
}

// ================= TILE (UNCHANGED) =================
class _ServiceTile extends StatelessWidget {
  final String title;
  final String price;
  final IconData icon;
  final Gradient gradient;
  final List<String> points;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.title,
    required this.price,
    required this.icon,
    required this.gradient,
    required this.points,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...points.map(
                          (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.check,
                                size: 14, color: Color(0xFF00897B)),
                            const SizedBox(width: 6),
                            Text(
                              e,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: Color(0xFF00897B)),
            ],
          ),
        ),
      ),
    );
  }
}
