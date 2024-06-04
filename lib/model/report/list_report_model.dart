import 'package:violence_app/model/report/report_category_model.dart';
import 'package:violence_app/model/report/report_request_model.dart';

class ListLaporanModel {
  String alamatDetailTkp;
  String alamatTkp;
  String alasanDibatalkan;
  DateTime createdAt;
  Dokumentasi dokumentasi;
  int kategoriKekerasanId;
  String kategoriLokasiKasus;
  String kronologisKasus;
  String noRegistrasi;
  String status;
  DateTime tanggalKejadian;
  DateTime tanggalPelaporan;
  DateTime updatedAt;
  int userId;
  int? useridMelihat;
  ViolenceCategory violenceCategoryDetail;
  String? waktuDibatalkan;
  String? waktuDilihat;
  String? waktuDiproses;

  ListLaporanModel({
    required this.alamatDetailTkp,
    required this.alamatTkp,
    this.alasanDibatalkan = "",
    required this.createdAt,
    required this.dokumentasi,
    required this.kategoriKekerasanId,
    required this.kategoriLokasiKasus,
    required this.kronologisKasus,
    required this.noRegistrasi,
    required this.status,
    required this.tanggalKejadian,
    required this.tanggalPelaporan,
    required this.updatedAt,
    required this.userId,
    this.useridMelihat,
    required this.violenceCategoryDetail,
    this.waktuDibatalkan,
    this.waktuDilihat,
    this.waktuDiproses,
  });

  factory ListLaporanModel.fromJson(Map<String, dynamic> json) => ListLaporanModel(
    alamatDetailTkp: json['alamat_detail_tkp'],
    alamatTkp: json['alamat_tkp'],
    alasanDibatalkan: json['alasan_dibatalkan'] ?? "",
    createdAt: DateTime.parse(json['created_at']),
    dokumentasi: Dokumentasi.fromJson(json['dokumentasi']),
    kategoriKekerasanId: json['kategori_kekerasan_id'],
    kategoriLokasiKasus: json['kategori_lokasi_kasus'],
    kronologisKasus: json['kronologis_kasus'],
    noRegistrasi: json['no_registrasi'],
    status: json['status'],
    tanggalKejadian: DateTime.parse(json['tanggal_kejadian']),
    tanggalPelaporan: DateTime.parse(json['tanggal_pelaporan']),
    updatedAt: DateTime.parse(json['updated_at']),
    userId: json['user_id'],
    useridMelihat: json['userid_melihat'],
    violenceCategoryDetail: ViolenceCategory.fromJson(json['violence_category_detail']),
    waktuDibatalkan: json['waktu_dibatalkan'],
    waktuDilihat: json['waktu_dilihat'],
    waktuDiproses: json['waktu_diproses'],
  );

  Map<String, dynamic> toJson() => {
    'alamat_detail_tkp': alamatDetailTkp,
    'alamat_tkp': alamatTkp,
    'alasan_dibatalkan': alasanDibatalkan,
    'created_at': createdAt.toIso8601String(),
    'dokumentasi': dokumentasi.toJson(),
    'kategori_kekerasan_id': kategoriKekerasanId,
    'kategori_lokasi_kasus': kategoriLokasiKasus,
    'kronologis_kasus': kronologisKasus,
    'no_registrasi': noRegistrasi,
    'status': status,
    'tanggal_kejadian': tanggalKejadian.toIso8601String(),
    'tanggal_pelaporan': tanggalPelaporan.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'user_id': userId,
    'userid_melihat': useridMelihat,
    'violence_category_detail': violenceCategoryDetail.toJson(),
    'waktu_dibatalkan': waktuDibatalkan,
    'waktu_dilihat': waktuDilihat,
    'waktu_diproses': waktuDiproses,
  };
}


class ResponseModel {
  int code;
  String status;
  String message;
  List<ListLaporanModel> data;

  ResponseModel({
    required this.code,
    required this.status,
    required this.message,
    required this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
    code: json['code'],
    status: json['status'],
    message: json['message'],
    data: List<ListLaporanModel>.from(json['Data'].map((x) => ListLaporanModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'status': status,
    'message': message,
    'Data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}



