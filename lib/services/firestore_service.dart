import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';
import '../models/appointment_model.dart';
import '../utils/app_theme.dart';


class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== Services ==========
  Stream<List<ServiceModel>> getServices() {
    return _firestore
        .collection('services')
        .orderBy('category')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ServiceModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  Stream<List<ServiceModel>> getServicesByCategory(String category) {
    return _firestore
        .collection('services')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ServiceModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  Future<ServiceModel?> getServiceById(String serviceId) async {
    try {
      final doc = await _firestore.collection('services').doc(serviceId).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return ServiceModel.fromMap(data, doc.id);
    } catch (_) {
      return null;
    }
  }

  // ========== Appointments ==========
  Future<String> createAppointment(AppointmentModel appointment) async {
    final docRef =
    await _firestore.collection('appointments').add(appointment.toMap());
    return docRef.id;
  }
  Future<void> cancelAppointment(String appointmentId) async {
    await updateAppointmentStatus(appointmentId, 'cancelled');
  }

  Stream<List<AppointmentModel>> getUserAppointments(String userId) {
    return _firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .orderBy('appointmentDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AppointmentModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  Stream<List<AppointmentModel>> getAllAppointments() {
    return _firestore
        .collection('appointments')
        .orderBy('appointmentDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return AppointmentModel.fromMap(data, doc.id);
      }).toList();
    });
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status) async {
    await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .update({'status': status});
  }

  Future<List<String>> getAvailableTimeSlots(DateTime date) async {
    final allSlots = AppConstants.timeSlots;

    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection('appointments')
        .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('appointmentDate', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .where('status', whereIn: ['pending', 'confirmed'])
        .get();

    final bookedSlots = snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((data) => data['timeSlot'] != null)
        .map((data) => data['timeSlot'].toString())
        .toList();

    return allSlots.where((slot) => !bookedSlots.contains(slot)).toList();
  }

  Future<bool> isUserAdmin(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return false;

      final data = doc.data() as Map<String, dynamic>;
      return data['role']?.toString() == 'admin';
    } catch (_) {
      return false;
    }
  }
}
