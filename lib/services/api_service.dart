import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:violence_app/config.dart';
import 'package:violence_app/model/appointment_request_model.dart';
import 'package:violence_app/model/appointment_response_model.dart';
import 'package:violence_app/model/auth/login_response_model.dart';
import 'package:violence_app/model/auth/register_response_model.dart';
import 'package:violence_app/model/report/list_report_model.dart';
import 'package:violence_app/model/report/report_request_model.dart';
import 'package:violence_app/services/shared_service.dart';

import '../model/auth/login_request_model.dart';
import '../model/content_model.dart';
import '../model/report/cancel_model.dart';
import '../model/report/full_report_model.dart';
import '../model/report/korban_model.dart';
import '../model/report/report_category_model.dart';
import '../model/report/report_response_model.dart';
import '../model/wilayah/pelaporan/provincies.dart';


class APIService {
  static var client = http.Client();

  Future<LoginResponseModel> login(String identifier, String password) async {
    final url = Uri.parse('${Config.apiUrl}${Config.loginAPI}');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': identifier,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('Body: ${response.body}');
      return LoginResponseModel.fromJson(jsonResponse);
      if (jsonResponse['access'] != null && jsonResponse['access'] == 'masyarakat') {
      } else {
        throw Exception('Access Denied: Only users with masyarakat access can login.');
      }
    } else {
      throw Exception('Failed to login. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<RegisterResponseModel> register(String email, String password, String fullName, String phoneNumber) async {
    final url = Uri.parse('${Config.apiUrl}${Config.registerAPI}');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'full_name': fullName,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          final User newUser = User.fromJson(jsonResponse['data']);
          print('User created: ${newUser.toString()}');
        } else {
          print('No data found in response');
        }
        return RegisterResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        final jsonResponse = json.decode(response.body);
        throw Exception('Registration failed: ${jsonResponse['message']}');
      } else {
        throw Exception('Failed to register. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  Future<LoginResponseModel> forgotPassword(String email, String password) async {
    final url = Uri.parse('${Config.apiUrl}${Config.forgotPassdword}');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          final User newUser = User.fromJson(jsonResponse['data']);
        } else {
          print('No data found in response');
        }
        return LoginResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 400) {
        final jsonResponse = json.decode(response.body);
        throw Exception('Gagal mengubah kata sandi: ${jsonResponse['message']}');
      } else {
        throw Exception('Gagal mengubah kata sandi. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Gagal saat mengubah kata sandi: $e');
      rethrow;
    }
  }

  Future<List<ViolenceCategory>> fetchCategories() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getViolenceCategory}');

    try {
      final response = await client.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['Data'] != null && responseBody['Data'].isNotEmpty) {
          return List<ViolenceCategory>.from(
              responseBody['Data'].map((data) => ViolenceCategory.fromJson(data))
          );
        } else {
          print('No data available');
          return [];
        }
      } else {
        throw Exception('Failed to fetch categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<ReportResponseModel<ReportRequestModel>> submitReport(
      int idViolenceCategory,
      DateTime tanggalKejadian,
      String kategoriLokasiKasus,
      String kronologisKasus,
      String alamatTkp,
      String alamatDetailTkp,
      List<File> dokumen,
      ) async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');

    final url = Uri.parse('${Config.apiUrl}${Config.postReport}');

    var request = http.MultipartRequest('POST', url);

    request.fields['kategori_kekerasan_id'] = idViolenceCategory.toString();
    request.fields['tanggal_kejadian'] = tanggalKejadian.toIso8601String();
    request.fields['kategori_lokasi_kasus'] = kategoriLokasiKasus;
    request.fields['kronologis_kasus'] = kronologisKasus;
    request.fields['alamat_detail_tkp'] = alamatDetailTkp;
    request.fields['alamat_tkp'] = alamatTkp;

    // Tambahkan gambar default jika dokumen kosong
    if (dokumen.isEmpty) {
      dokumen.add(File('https://res.cloudinary.com/dz1kiuf8x/image/upload/v1717396414/c9r4yheoxsundwgngcz1.png'));
    }

    for (var file in dokumen) {
      var multipartFile = await http.MultipartFile.fromPath(
        'dokumen',
        file.path,
      );
      request.files.add(multipartFile);
    }

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    try {
      var streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return ReportResponseModel<ReportRequestModel>.fromJson(
            jsonResponse,
                (dataJson) =>
                ReportRequestModel.fromJson(dataJson as Map<String, dynamic>));
      } else {
        print('Response body: ${response.body}');
        String errorMessage =
            'Gagal mengirim laporan. Status code: ${response.statusCode}, Body: ${response.body}';
        if (response.statusCode == 400) {
          errorMessage =
          'Request tidak valid. Silakan periksa input dan coba lagi.';
        } else if (response.statusCode >= 500) {
          errorMessage = 'Terjadi kesalahan server. Silakan coba lagi nanti.';
        }
        throw Exception(errorMessage);
      }
    } on SocketException catch (e) {
      throw Exception(
          'Tidak dapat terhubung ke server. Silakan periksa koneksi internet Anda. Error: ${e.message}');
    } catch (e) {
      throw Exception('Error pada saat mengirim laporan: $e');
    }
  }


  Future<KorbanResponseModel> submitReportKorban(
      String noRegistrasi,
      String nikKorban,
      String namaKorban,
      String usiaKorban,
      String alamatKorban,
      String alamatDetail,
      String jenisKelamin,
      String agama,
      String noTelepon,
      String pendidikan,
      String pekerjaan,
      String statusPerkawinan,
      String kebangsaan,
      String hubunganDenganPelaku,
      String keteranganLainnya,
      List<io.File> dokumentasiKorban
      ) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.postReportKorban}');

    var request = http.MultipartRequest('POST', url);

    request.fields['no_registrasi'] = noRegistrasi;
    request.fields['nik_korban'] = nikKorban;
    request.fields['nama_korban'] = namaKorban;
    request.fields['usia_korban'] = usiaKorban;
    request.fields['alamat_korban'] = alamatKorban;
    request.fields['alamat_detail'] = alamatDetail;
    request.fields['jenis_kelamin'] = jenisKelamin;
    request.fields['agama'] = agama;
    request.fields['no_telepon'] = noTelepon;
    request.fields['pendidikan'] = pendidikan;
    request.fields['pekerjaan'] = pekerjaan;
    request.fields['status_perkawinan'] = statusPerkawinan;
    request.fields['kebangsaan'] = kebangsaan;
    request.fields['hubungan_dengan_pelaku'] = hubunganDenganPelaku;
    request.fields['keterangan_lainnya'] = keteranganLainnya;

    for (var file in dokumentasiKorban) {
      if (await file.exists()) {
        request.files.add(await http.MultipartFile.fromPath(
            'dokumentasi_korban',
            file.path
        ));
      } else {
        print("File does not exist: ${file.path}");
      }
    }

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    try {
      var streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return KorbanResponseModel.fromJson(jsonResponse);
      } else {
        print('Response body: ${response.body}');
        throw Exception('Failed to submit korban report. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error while submitting korban report: $e');
    }
  }

  Future<void> cancelReport(String noRegistrasi, String alasanDibatalkan) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.cancelReport}/$noRegistrasi');

    var request = http.MultipartRequest('PUT', url);

    request.fields['alasan_dibatalkan'] = alasanDibatalkan;

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    try {
      var response = await request.send();

      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Laporan berhasil dibatalkan: $respStr');
      } else {
        throw Exception('Gagal membatalkan laporan. Status code: ${response.statusCode}, Body: $respStr');
      }
    } catch (e) {
      throw Exception('Error saat membatalkan laporan: $e');
    }
  }

  Future<ResponseModel> fetchUserReports() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getReportByUser}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return ResponseModel.fromJson(responseData);
      } else {
        return ResponseModel(
          code: response.statusCode,
          status: 'Error',
          message: 'Server Error: ${response.reasonPhrase}',
          data: [],
        );
      }
    } catch (e) {
      // Handling errors in request or JSON parsing
      return ResponseModel(
        code: 500,
        status: 'Exception',
        message: 'Exception occurred: $e',
        data: [],
      );
    }
  }

  Future<DetailResponseModel> getFullReportDetails(String noRegistrasi) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getDetailReportByUser}/$noRegistrasi');
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

    if (response.statusCode == 200) {
      return DetailResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load report details');
    }
  }


  Future<List<ReportRequestModel>> fetchReportsEnter() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getReportByUser}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['Data'] != null && responseBody['Data'].isNotEmpty) {
          var filteredData = responseBody['Data']
              .where((data) => data['status'] != null && data['status'].toString() == 'Laporan masuk')
              .toList();

          return List<ReportRequestModel>.from(
              filteredData.map((data) => ReportRequestModel.fromJson(data))
          );
        } else {
          print('No data available');
          return [];
        }
      } else {
        throw Exception('Failed to fetch reports. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching reports: $e');
      throw Exception('Error fetching reports: $e');
    }
  }

  Future<List<ReportRequestModel>> fetchReportsProcess() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getReportByUser}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['Data'] != null && responseBody['Data'].isNotEmpty) {
          var filteredData = responseBody['Data']
              .where((data) => data['status'] != null && data['status'].toString() == 'Diproses')
              .toList();

          return List<ReportRequestModel>.from(
              filteredData.map((data) => ReportRequestModel.fromJson(data))
          );
        } else {
          print('No data available');
          return [];
        }
      } else {
        throw Exception('Failed to fetch reports. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching reports: $e');
      throw Exception('Error fetching reports: $e');
    }
  }

  Future<ReportRequestModel> fetchReportByRegistration(String noRegistrasi) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getDetailReportByUser}/$noRegistrasi');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ReportRequestModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch report. Status code: ${response.statusCode}');
    }
  }

  Future<AppointmentResponseModel> submitAppointment(DateTime waktuDimulai, DateTime waktuSelesai, String keperluanKonsultasi) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    var uri = Uri.parse('${Config.apiUrl}${Config.createJanjiTemu}');

    var request = http.MultipartRequest('POST', uri)
      ..fields['waktu_dimulai'] = waktuDimulai.toIso8601String()
      ..fields['waktu_selesai'] = waktuSelesai.toIso8601String()
      ..fields['keperluan_konsultasi'] = keperluanKonsultasi
      ..headers['Authorization'] = 'Bearer $token';

    try {
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 201) {
        print('Janji temu berhasil dibuat. Body: $responseString');
        return AppointmentResponseModel.fromJson(jsonDecode(responseString));
      } else {
        print('Gagal membuat janji temu. Status code: ${response.statusCode}, Body: $responseString');
        throw Exception('Gagal membuat janji temu. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat membuat janji temu: $e');
    }
  }

  Future<List<AppointmentRequestModel>> fetchAppointments() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.getJanjiTemu}');

    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['Data'] != null && responseBody['Data'].isNotEmpty) {
        List<dynamic> reportData = responseBody['Data'];
        return reportData.map((data) => AppointmentRequestModel.fromJson(data)).toList();
      } else {
        print('No data available');
        return [];
      }
    } else {
      throw Exception('Failed to fetch reports. Status code: ${response.statusCode}');
    }
  }

  Future<AppointmentResponseModel> editAppointment(int appointmentId, DateTime waktuDimulai, DateTime waktuSelesai, String keperluanKonsultasi) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    var uri = Uri.parse('${Config.apiUrl}${Config.editJanjiTemu}/$appointmentId');

    var request = http.MultipartRequest('PUT', uri)
      ..fields['waktu_dimulai'] = waktuDimulai.toIso8601String()
      ..fields['waktu_selesai'] = waktuSelesai.toIso8601String()
      ..fields['keperluan_konsultasi'] = keperluanKonsultasi
      ..headers['Authorization'] = 'Bearer $token';

    try {
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        print('Janji temu berhasil diedit. Body: $responseString');
        return AppointmentResponseModel.fromJson(jsonDecode(responseString));
      } else {
        print('Gagal mengedit janji temu. Status code: ${response.statusCode}, Body: $responseString');
        throw Exception('Gagal mengedit janji temu. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat mengedit janji temu: $e');
    }
  }


  Future<void> cancelAppointment(int appointmentId, String reason) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.batalJanjiTemu}/$appointmentId');

    var request = http.MultipartRequest('PUT', url);

    request.fields['alasan_dibatalkan'] = reason;

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    try {
      var response = await request.send();

      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Janji temu berhasil dibatalkan: $respStr');
      } else {
        throw Exception('Gagal membatalkan janji temu. Status code: ${response.statusCode}, Body: $respStr');
      }
    } catch (e) {
      throw Exception('Error saat membatalkan janji temu: $e');
    }
  }

  Future<void> editProfil(String fullName, String email, String noTelp) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'userToken');
    final url = Uri.parse('${Config.apiUrl}${Config.editProfil}');

    var request = http.MultipartRequest('PUT', url);

    request.fields['alasan_dibatalkan'] = fullName;
  }

  Future<List<Content>> fetchContents() async {
    http.Response response = await http.get(Uri.parse('${Config.apiUrl}${Config.getContent}'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['code'] == 200) {
        List<dynamic> contentsJson = data['Data'];
        List<Content> contents = contentsJson.map((json) => Content.fromJson(json)).toList();
        return contents;
      } else {
        throw Exception('Failed to load content data');
      }
    } else {
      throw Exception('Failed to reach the server');
    }
  }
}