import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../models/appointment_model.dart';
import '../utils/app_theme.dart';

class AdminScreen extends StatefulWidget
{
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin
{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primaryColor,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AppointmentsList(status: null),
          AppointmentsList(status: 'pending'),
          AppointmentsList(status: 'confirmed'),
          AppointmentsList(status: 'completed'),
        ],
      ),
    );
  }
}

class AppointmentsList extends StatelessWidget {
  final String? status;

  const AppointmentsList({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AppointmentModel>>(
      stream: FirestoreService().getAllAppointments(),
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
                  Icons.calendar_today_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No appointments',
                  style: AppTheme.heading3,
                ),
              ],
            ),
          );
        }

        var appointments = snapshot.data!;

        // Filter by status if specified
        if (status != null) {
          appointments = appointments
              .where((apt) => apt.status == status)
              .toList();
        }

        if (appointments.isEmpty) {
          return Center(
            child: Text(
              'No ${status ?? ""} appointments',
              style: AppTheme.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            return AdminAppointmentCard(appointment: appointments[index]);
          },
        );
      },
    );
  }
}

class AdminAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AdminAppointmentCard({super.key, required this.appointment});

  Color _getStatusColor() {
    switch (appointment.status) {
      case 'confirmed':
        return AppTheme.successColor;
      case 'pending':
        return AppTheme.warningColor;
      case 'completed':
        return AppTheme.primaryColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.serviceName,
                        style: AppTheme.heading3.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${appointment.id.substring(0, 8)}',
                        style: AppTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    appointment.status.toUpperCase(),
                    style: AppTheme.bodySmall.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Customer Info
            Text('Customer Details', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _InfoRow(Icons.person, appointment.userName),
            _InfoRow(Icons.email, appointment.userEmail),
            _InfoRow(Icons.phone, appointment.userPhone),

            const SizedBox(height: 16),

            // Appointment Info
            Text('Appointment Details', style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _InfoRow(Icons.calendar_today, dateFormat.format(appointment.appointmentDate)),
            _InfoRow(Icons.access_time, appointment.timeSlot),
            _InfoRow(Icons.directions_car, '${appointment.carModel} • ${appointment.carNumber}'),
            _InfoRow(
              Icons.payment,
              '₹${appointment.servicePrice.toStringAsFixed(0)}',
              valueColor: AppTheme.successColor,
            ),

            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.note, size: 16, color: AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Notes:',
                          style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(appointment.notes!, style: AppTheme.bodySmall),
                  ],
                ),
              ),
            ],

            // Action buttons
            if (appointment.status != 'cancelled' && appointment.status != 'completed') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (appointment.status == 'pending') ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _updateStatus(context, 'confirmed'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.successColor,
                          side: const BorderSide(color: AppTheme.successColor),
                        ),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Confirm'),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (appointment.status == 'confirmed') ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateStatus(context, 'completed'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.successColor,
                        ),
                        icon: const Icon(Icons.task_alt),
                        label: const Text('Complete'),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _updateStatus(context, 'cancelled'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.errorColor,
                        side: const BorderSide(color: AppTheme.errorColor),
                      ),
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _updateStatus(BuildContext context, String newStatus) async {
    try {
      await FirestoreService().updateAppointmentStatus(appointment.id, newStatus);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment ${newStatus.toLowerCase()} successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? valueColor;

  const _InfoRow(this.icon, this.text, {this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTheme.bodyMedium.copyWith(
                color: valueColor ?? AppTheme.textPrimary,
                fontWeight: valueColor != null ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}