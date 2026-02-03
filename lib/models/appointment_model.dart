import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String serviceId;
  final String serviceName;
  final double servicePrice;
  final DateTime appointmentDate;
  final String timeSlot;
  final String carModel;
  final String carNumber;
  final String status;
  final String? notes;
  final DateTime createdAt;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.serviceId,
    required this.serviceName,
    required this.servicePrice,
    required this.appointmentDate,
    required this.timeSlot,
    required this.carModel,
    required this.carNumber,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  factory AppointmentModel.fromMap(Map<String, dynamic> map, String id) {
    return AppointmentModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userPhone: map['userPhone'] ?? '',
      serviceId: map['serviceId'] ?? '',
      serviceName: map['serviceName'] ?? '',
      servicePrice: map['servicePrice'] is num
          ? (map['servicePrice'] as num).toDouble()
          : 0.0,
      appointmentDate: map['appointmentDate'] is Timestamp
          ? (map['appointmentDate'] as Timestamp).toDate()
          : DateTime.now(),
      timeSlot: map['timeSlot'] ?? '',
      carModel: map['carModel'] ?? '',
      carNumber: map['carNumber'] ?? '',
      status: map['status'] ?? 'pending',
      notes: map['notes']?.toString(),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'servicePrice': servicePrice,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'timeSlot': timeSlot,
      'carModel': carModel,
      'carNumber': carNumber,
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
