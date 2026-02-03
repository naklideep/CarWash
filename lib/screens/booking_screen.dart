import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../models/service_model.dart';
import '../models/appointment_model.dart';
import '../utils/app_theme.dart';

class BookingScreen extends StatefulWidget {
  final ServiceModel service;

  const BookingScreen({super.key, required this.service});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _carModelController = TextEditingController();
  final _carNumberController = TextEditingController();
  final _notesController = TextEditingController();
  final _firestoreService = FirestoreService();
  final _authService = AuthService();

  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  String? _selectedTimeSlot;
  List<String> _availableTimeSlots = [];
  bool _isLoading = false;
  bool _isLoadingSlots = false;

  @override
  void initState() {
    super.initState();
    _loadAvailableTimeSlots();
  }

  @override
  void dispose() {
    _carModelController.dispose();
    _carNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableTimeSlots() async {
    setState(() => _isLoadingSlots = true);
    final slots = await _firestoreService.getAvailableTimeSlots(_selectedDate);
    setState(() {
      _availableTimeSlots = slots;
      _isLoadingSlots = false;
      if (!_availableTimeSlots.contains(_selectedTimeSlot)) {
        _selectedTimeSlot = null;
      }
    });
  }

  Future<void> _bookAppointment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final userData = await _authService.getUserData(user.uid);

      final appointment = AppointmentModel(
        id: '',
        userId: user.uid,
        userName: userData?['name'] ?? user.displayName ?? '',
        userEmail: user.email ?? '',
        userPhone: userData?['phone'] ?? '',
        serviceId: widget.service.id,
        serviceName: widget.service.name,
        servicePrice: widget.service.price,
        appointmentDate: _selectedDate,
        timeSlot: _selectedTimeSlot!,
        carModel: _carModelController.text.trim(),
        carNumber: _carNumberController.text.trim().toUpperCase(),
        status: 'pending',
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: DateTime.now(),
      );

      await _firestoreService.createAppointment(appointment);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment booked successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book appointment: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Service Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
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
                      widget.service.category == 'wash'
                          ? Icons.local_car_wash
                          : Icons.auto_awesome,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.service.name,
                          style: AppTheme.heading3.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${widget.service.price.toStringAsFixed(0)} • ${widget.service.durationMinutes} mins',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Booking Form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Date', style: AppTheme.heading3),
                    const SizedBox(height: 16),

                    // Calendar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 60)),
                        focusedDay: _focusedDate,
                        selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                        calendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: AppTheme.heading3,
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: AppTheme.secondaryColor.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: const TextStyle(color: Colors.white),
                          todayTextStyle: TextStyle(color: AppTheme.primaryColor),
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDate, selectedDay)) {
                            setState(() {
                              _selectedDate = selectedDay;
                              _focusedDate = focusedDay;
                            });
                            _loadAvailableTimeSlots();
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text('Select Time Slot', style: AppTheme.heading3),
                    const SizedBox(height: 16),

                    // Time Slots
                    _isLoadingSlots
                        ? const Center(child: CircularProgressIndicator())
                        : _availableTimeSlots.isEmpty
                        ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'No time slots available for this date',
                          style: AppTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                        : Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _availableTimeSlots.map((slot) {
                        final isSelected = slot == _selectedTimeSlot;
                        return InkWell(
                          onTap: () {
                            setState(() => _selectedTimeSlot = slot);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              slot,
                              style: AppTheme.bodyMedium.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    Text('Car Details', style: AppTheme.heading3),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _carModelController,
                      decoration: const InputDecoration(
                        labelText: 'Car Model',
                        hintText: 'e.g., Honda City',
                        prefixIcon: Icon(Icons.directions_car),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter car model';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _carNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Car Number',
                        hintText: 'e.g., GJ01AB1234',
                        prefixIcon: Icon(Icons.confirmation_number),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter car number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Additional Notes (Optional)',
                        hintText: 'Any specific requirements...',
                        prefixIcon: Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _bookAppointment,
                        child: _isLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text('Confirm Booking'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}