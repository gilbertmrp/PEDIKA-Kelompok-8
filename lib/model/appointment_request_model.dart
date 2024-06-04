import 'package:violence_app/model/auth/login_request_model.dart';

class AppointmentRequestModel {
  final int id;
  final int? userId;
  final String waktuDimulai;
  final String waktuSelesai;
  final String keperluanKonsultasi;
  final String status;
  final int? userIdTolakSetujui;
  final String? alasanDitolak;
  final String? alasanDibatalkan;

  AppointmentRequestModel({
    required this.id,
    this.userId,
    required this.waktuDimulai,
    required this.waktuSelesai,
    required this.keperluanKonsultasi,
    required this.status,
    this.userIdTolakSetujui,
    this.alasanDitolak,
    this.alasanDibatalkan,
  });

  factory AppointmentRequestModel.fromJson(Map<String, dynamic> json) {
    return AppointmentRequestModel(
      id: json['id'],
      userId: json['user_id'] != "" ? json['user_id'] : null,
      waktuDimulai: json['waktu_dimulai'],
      waktuSelesai: json['waktu_selesai'],
      keperluanKonsultasi: json['keperluan_konsultasi'],
      status: json['status'],
      userIdTolakSetujui: json['user_id_tolak_setujui'] is int ? json['user_tolak_setujui'] : null,
      alasanDitolak: json['alasan_ditolak'] != "" ? json['alasan_ditolak'] : null,
      alasanDibatalkan: json['alasan_dibatalkan'] != "" ? json['alasan_dibatalkan'] : null,
    );
  }
}