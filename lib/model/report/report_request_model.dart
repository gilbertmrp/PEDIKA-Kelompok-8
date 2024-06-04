class ReportRequestModel {
  final String alamatDetailTkp;
  final String alamatTkp;
  final DateTime createdAt;
  final List<String> dokumentasiUrls;
  final int kategoriKekerasanId;
  final String kategoriLokasiKasus;
  final String kronologisKasus;
  final String noRegistrasi;
  final DateTime tanggalKejadian;
  final DateTime tanggalPelaporan;
  final DateTime updatedAt;
  final int userId;

  ReportRequestModel({
    required this.alamatDetailTkp,
    required this.alamatTkp,
    required this.createdAt,
    required this.dokumentasiUrls,
    required this.kategoriKekerasanId,
    required this.kategoriLokasiKasus,
    required this.kronologisKasus,
    required this.noRegistrasi,
    required this.tanggalKejadian,
    required this.tanggalPelaporan,
    required this.updatedAt,
    required this.userId,
  });

  factory ReportRequestModel.fromJson(Map<String, dynamic> json) {
    List<String> urls = (json['dokumentasi']['urls'] as List).map((item) => item.toString()).toList();
    return ReportRequestModel(
      alamatDetailTkp: json['alamat_detail_tkp'],
      alamatTkp: json['alamat_tkp'],
      createdAt: DateTime.parse(json['created_at']),
      dokumentasiUrls: urls,
      kategoriKekerasanId: json['kategori_kekerasan_id'],
      kategoriLokasiKasus: json['kategori_lokasi_kasus'],
      kronologisKasus: json['kronologis_kasus'],
      noRegistrasi: json['no_registrasi'],
      tanggalKejadian: DateTime.parse(json['tanggal_kejadian']),
      tanggalPelaporan: DateTime.parse(json['tanggal_pelaporan']),
      updatedAt: DateTime.parse(json['updated_at']),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alamat_detail_tkp': alamatDetailTkp,
      'alamat_tkp': alamatTkp,
      'created_at': createdAt.toIso8601String(),
      'dokumentasi': {
        'urls': dokumentasiUrls,
      },
      'kategori_kekerasan_id': kategoriKekerasanId,
      'kategori_lokasi_kasus': kategoriLokasiKasus,
      'kronologis_kasus': kronologisKasus,
      'no_registrasi': noRegistrasi,
      'tanggal_kejadian': tanggalKejadian.toIso8601String(),
      'tanggal_pelaporan': tanggalPelaporan.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_id': userId,
    };
  }
}

class Dokumentasi {
  List<String> urls;

  Dokumentasi({required this.urls});

  factory Dokumentasi.fromJson(Map<String, dynamic> json) {
    return Dokumentasi(
      urls: List<String>.from(json['urls']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'urls': urls,
    };
  }
}
