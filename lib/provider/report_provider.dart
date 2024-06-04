import 'package:flutter/cupertino.dart';
import 'package:violence_app/model/report/list_report_model.dart';
import '../model/report/full_report_model.dart';
import '../services/api_service.dart';

class ReportProvider with ChangeNotifier {
  ResponseModel? reports;
  bool isLoading = false;
  String? errorMessage;

  DetailResponseModel? detailReport;

  Future<void> fetchReports() async {
    _setLoading(true);
    try {
      reports = await APIService().fetchUserReports();
      _setLoading(false);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> fetchDetailReports(String noRegistrasi) async {
    _setLoading(true);
    try {
      detailReport = await APIService().getFullReportDetails(noRegistrasi);
      _setLoading(false);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> fetchReportsByLaporanMasuk() async {
    _setLoading(true);
    try {
      var allReports = await APIService().fetchUserReports();
      if (allReports != null && allReports.data != null) {
        var filteredReports = allReports.data!.where((report) => report.status == "Laporan masuk").toList();
        reports = ResponseModel(
          code: allReports.code,
          status: allReports.status,
          message: "Filtered by Laporan masuk",
          data: filteredReports,
        );
      }
      _setLoading(false);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> fetchReportsByLaporanProses() async {
    isLoading = true;
    notifyListeners();
    try {
      var allReports = await APIService().fetchUserReports();
      var filteredReports = allReports.data.where((report) => report.status == "Diproses").toList();
      reports = ResponseModel(
        code: allReports.code,
        status: allReports.status,
        message: allReports.message,
        data: filteredReports,
      );
    } catch (e) {
      // handle exception
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReportsByLaporanSelesai() async {
    isLoading = true;
    notifyListeners();
    try {
      var allReports = await APIService().fetchUserReports();
      var filteredReports = allReports.data.where((report) => report.status == "Selesai").toList();
      reports = ResponseModel(
        code: allReports.code,
        status: allReports.status,
        message: allReports.message,
        data: filteredReports,
      );
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void _handleError(e) {
    errorMessage = e.toString();
    isLoading = false;
    notifyListeners();
  }
}
