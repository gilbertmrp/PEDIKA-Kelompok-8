class Config {
  static const String apiUrl = "https://backend-pedika-app-golang-production-5377.up.railway.app";
  // static const String apiUrl = "http://172.27.69.222:8080";
  static const String AREA_API = "https://emsifa.github.io/api-wilayah-indonesia/api/";
  static const String PROVINCES = "provinces";
  static const String CITIES = "regencies";
  static const String DISTRICTS = "districts";
  static const String SUB_DISTRICTS = "villages";

  // Autentikasi
  static const String loginAPI = "/api/user/login";
  static const String registerAPI = "/api/user/register";
  static const String forgotPassdword = "/api/masyarakat/lupa-sandi";
  static const String userProfileAPI = "/api/masyarakat/profile";

  // Form DPMADPPA
  static const String getFormAPIDPMADPPA = "/api/pelaporan-masyarakat-ke-dinas/";
  static const String postFormAPIDPMADPPA = "/api/pelaporan-masyarakat-ke-dinas/";
  static const String getFormByIdAPIDPMADPPA = "/api/pelaporan-masyarakat-ke-dinas/";

  static const String getFormAPIPolice = "/api/pelaporan-masyarakat-ke-polisi/";
  static const String postFormAPIPolice = "/api/pelaporan-masyarakat-ke-polisi/";
  static const String getFormByIdAPIPolice = "/api/pelaporan-masyarakat-ke-polisi/";


  static const String getViolenceCategory = "/api/masyarakat/kategori-kekerasan";

  static const String postReport = "/api/masyarakat/buat-laporan";
  static const String postReportKorban = "/api/masyarakat/create-korban-kekerasan";
  static const String getReportByUser = "/api/masyarakat/laporans";
  static const String getDetailReportByUser = "/api/masyarakat/detail-laporan";
  static const String cancelReport = "/api/masyarakat/batalkan-laporan";

  static const String createJanjiTemu = "/api/masyarakat/create-janjitemu";
  static const String getJanjiTemu = "/api/masyarakat/janjitemus";
  static const String editJanjiTemu = "/api/masyarakat/edit-janjitemu";
  static const String batalJanjiTemu = "/api/masyarakat/batal-janjitemu";

  static const String editProfil = "/api/masyarakat/edit-profile";

  static const String getContent = "/api/publik-content";
}
