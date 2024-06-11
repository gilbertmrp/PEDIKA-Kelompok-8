import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:violence_app/config.dart';
import 'package:violence_app/screens/dpmdppa/report_screen.dart';
import 'package:violence_app/styles/color.dart';
import 'package:http/http.dart' as http;

import '../../model/report/report_category_model.dart';
import '../../model/wilayah/pelaporan/cities.dart';
import '../../model/wilayah/pelaporan/districts.dart';
import '../../model/wilayah/pelaporan/provincies.dart';
import '../../model/wilayah/pelaporan/sub_districts.dart';
import '../../navigationBar/bottom_bar.dart';
import '../../services/api_service.dart';
import '../../utils/loading_dialog.dart';
import '../beranda_screen.dart';
import '../profile/profile_screen.dart';

class FormReportDPMADPPA extends StatefulWidget {
  const FormReportDPMADPPA({Key? key}) : super(key: key);

  @override
  State<FormReportDPMADPPA> createState() => _FormReportDPMADPPAState();
}

class _FormReportDPMADPPAState extends State<FormReportDPMADPPA> with WidgetsBindingObserver {
  int currentStep = 0;
  final _formKeyPengaduan = GlobalKey<FormState>();
  final _formKeyKorban = GlobalKey<FormState>();
  final _formKeyPelaku = GlobalKey<FormState>();

  bool isLoading = true;
  int? selectedCategoryId;
  bool isVictim = false;

  // Pengaduan
  DateTime? tanggalPelaporan;
  final TextEditingController _kategoriLokasiKasus = TextEditingController();
  final TextEditingController _provinsiKasus = TextEditingController();
  final TextEditingController _kabupatenKasus = TextEditingController();
  final TextEditingController _kecamatanKasus = TextEditingController();
  final TextEditingController _desaKasus = TextEditingController();
  final TextEditingController _alamatDetail = TextEditingController();
  final TextEditingController _kronologiKasus = TextEditingController();
  List<Provincies> provinciesPelaporan = [];
  String? provinceIdPelaporan;
  List<Provincies> listOfProvincesPelaporan = [];
  String? cityIdPelaporan;
  List<Cities> listOfCitiesPelaporan = [];
  String? districtIdPelaporan;
  List<Districts> listOfDistrictsPelaporan = [];
  String? subDistrictIdPelaporan;
  List<SubDistricts> listOfSubDistrictsPelaporan = [];
  Future<void> _loadProvincesPelaporan() async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> provincesJson = json.decode(response.body);
      setState(() {
        provinciesPelaporan = provincesJson.map((json) => Provincies.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<List<Cities>> getRegenciesPelaporan(String provinceId) async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> regenciesJson = json.decode(response.body);
      return regenciesJson.map((json) => Cities.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load regencies');
    }
  }

  Future<List<Districts>> getDistrictsPelaporan(String regencyId) async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/districts/$regencyId.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> districtsJson = json.decode(response.body);
      return districtsJson.map((json) => Districts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load districts');
    }
  }

  Future<List<SubDistricts>> getVillagesPelaporan(String districtId) async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/villages/$districtId.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> villagesJson = json.decode(response.body);
      return villagesJson.map((json) => SubDistricts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load villages');
    }
  }

  void _loadRegenciesPelaporan(String provinceId) async {
    listOfCitiesPelaporan = await getRegenciesPelaporan(provinceId);
    setState(() {});
  }

  void _loadDistrictsPelaporan(String regencyId) async {
    listOfDistrictsPelaporan = await getDistrictsPelaporan(regencyId);
    setState(() {});
  }

  void _loadVillagesPelaporan(String districtId) async {
    listOfSubDistrictsPelaporan = await getVillagesPelaporan(districtId);
    setState(() {});
  }

  //Korban
  final TextEditingController _nikKorban = TextEditingController();
  final TextEditingController _namaKorban = TextEditingController();
  final TextEditingController _usiaKorban = TextEditingController();
  final TextEditingController _provinsiKorban = TextEditingController();
  final TextEditingController _kabupatenKorban = TextEditingController();
  final TextEditingController _kecamatanKorban = TextEditingController();
  final TextEditingController _desaKorban = TextEditingController();
  final TextEditingController _alamatDetailKorban = TextEditingController();
  String? _jenisKelaminKorban;
  final TextEditingController _agamaKorban = TextEditingController();
  final TextEditingController _noTelpKorban = TextEditingController();
  final TextEditingController _pendidikanKorban = TextEditingController();
  final TextEditingController _pekerjaanKorban = TextEditingController();
  final TextEditingController _statusPerkawinanKorban = TextEditingController();
  final TextEditingController _kebangsaanKorban = TextEditingController();
  final TextEditingController _hubunganDenganPelaku = TextEditingController();
  final TextEditingController _keteranganLainnya = TextEditingController();
  List<Provincies> provinciesKorban = [];
  String? provinceIdKorban;
  List<Provincies> listOfProvincesKorban = [];
  String? cityIdKorban;
  List<Cities> listOfCitiesKorban = [];
  String? districtIdKorban;
  List<Districts> listOfDistrictsKorban = [];
  String? subDistrictIdKorban;
  List<SubDistricts> listOfSubDistrictsKorban = [];
  Future<void> _loadProvincesKorban() async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> provincesJson = json.decode(response.body);
      setState(() {
        provinciesKorban = provincesJson.map((json) => Provincies.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<List<Cities>> getRegenciesKorban(String provinceId) async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> regenciesJson = json.decode(response.body);
      return regenciesJson.map((json) => Cities.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load regencies');
    }
  }

  Future<List<Districts>> getDistrictsKorban(String regencyId) async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/districts/$regencyId.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> districtsJson = json.decode(response.body);
      return districtsJson.map((json) => Districts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load districts');
    }
  }

  Future<List<SubDistricts>> getVillagesKorban(String districtId) async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/villages/$districtId.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> villagesJson = json.decode(response.body);
      return villagesJson.map((json) => SubDistricts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load villages');
    }
  }

  void _loadRegenciesKorban(String provinceId) async {
    listOfCitiesPelaporan = await getRegenciesPelaporan(provinceId);
    setState(() {});
  }

  void _loadDistrictsKorban(String regencyId) async {
    listOfDistrictsPelaporan = await getDistrictsPelaporan(regencyId);
    setState(() {});
  }

  void _loadVillagesKorban(String districtId) async {
    listOfSubDistrictsPelaporan = await getVillagesPelaporan(districtId);
    setState(() {});
  }

  void _handleGenderChangeKorban(String? value) {
    setState(() {
      _jenisKelaminKorban = value;
    });
  }

  //Pelaku
  final TextEditingController _nikPelaku = TextEditingController();
  final TextEditingController _namaPelaku = TextEditingController();
  final TextEditingController _usiaPelaku = TextEditingController();
  final TextEditingController _provinsiPelaku = TextEditingController();
  final TextEditingController _kabupatenPelaku = TextEditingController();
  final TextEditingController _kecamatanPelaku = TextEditingController();
  final TextEditingController _desaPelaku = TextEditingController();
  final TextEditingController _alamatDetailPelaku = TextEditingController();
  String? _jenisKelaminPelaku;
  final TextEditingController _agamaPelaku = TextEditingController();
  final TextEditingController _noTelpPelaku = TextEditingController();
  final TextEditingController _pendidikanPelaku = TextEditingController();
  final TextEditingController _pekerjaanPelaku = TextEditingController();
  final TextEditingController _statusPerkawinanPelaku = TextEditingController();
  final TextEditingController _kebangsaanPelaku = TextEditingController();
  final TextEditingController _hubunganDenganKorban = TextEditingController();
  final TextEditingController _keteranganLainnyaPelaku = TextEditingController();
  List<Provincies> provinciesPelaku = [];
  File? _imagePelaku;
  String? provinceIdPelaku;
  List<Provincies> listOfProvincesPelaku = [];
  String? cityIdPelaku;
  List<Cities> listOfCitiesPelaku = [];
  String? districtIdPelaku;
  List<Districts> listOfDistrictsPelaku = [];
  String? subDistrictIdPelaku;
  List<SubDistricts> listOfSubDistrictsPelaku = [];

  Future<void> _pickImagePelaku() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePelaku = File(image.path);
      });
    }
  }

  Future<void> _loadProvincesPelaku() async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> provincesJson = json.decode(response.body);
      setState(() {
        provinciesPelaku = provincesJson.map((json) => Provincies.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<List<Cities>> getRegenciesPelaku(String provinceId) async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> regenciesJson = json.decode(response.body);
      return regenciesJson.map((json) => Cities.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load regencies');
    }
  }

  Future<List<Districts>> getDistrictsPelaku(String regencyId) async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/districts/$regencyId.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> districtsJson = json.decode(response.body);
      return districtsJson.map((json) => Districts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load districts');
    }
  }

  Future<List<SubDistricts>> getVillagesPelaku(String districtId) async {
    var url = Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/villages/$districtId.json');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> villagesJson = json.decode(response.body);
      return villagesJson.map((json) => SubDistricts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load villages');
    }
  }

  void _loadRegenciesPelaku(String provinceId) async {
    listOfCitiesPelaporan = await getRegenciesPelaporan(provinceId);
    setState(() {});
  }

  void _loadDistrictsPelaku(String regencyId) async {
    listOfDistrictsPelaporan = await getDistrictsPelaporan(regencyId);
    setState(() {});
  }

  void _loadVillagesPelaku(String districtId) async {
    listOfSubDistrictsPelaporan = await getVillagesPelaporan(districtId);
    setState(() {});
  }

  void _handleGenderChangePelaku(String? value) {
    setState(() {
      _jenisKelaminPelaku = value;
    });
  }

  late List<CameraDescription> cameras;
  late CameraController cameraController;
  File? imageFile;
  ImageProvider? imagePreview;
  Future<void>? _initializeCameraFuture;
  double currentZoomLevel = 1.0;
  double maxZoomLevel = 1.0;
  bool isFlashOn = false;
  bool isRecording = false;
  XFile? videoFile;
  List<ViolenceCategory> categories = [];
  ViolenceCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    WidgetsBinding.instance.addObserver(this);
    _initializeCameraFuture = initializeCamera();
    _loadProvincesPelaporan();
    _loadProvincesKorban();
    _loadProvincesPelaku();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!cameraController.value.isInitialized ||
        cameraController.value.isRecordingVideo) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraFuture = initializeCamera();
    }
  }

  Future<void> _fetchCategories() async {
    try {
      var fetchedCategories = await APIService().fetchCategories();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.medium);

    await cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    await cameraController.setFocusMode(FocusMode.auto);
    maxZoomLevel = await cameraController.getMaxZoomLevel();

    setState(() {});
  }

  Future<void> setZoomLevel(double zoomLevel) async {
    final double newZoomLevel = zoomLevel.clamp(1.0, maxZoomLevel);

    if (cameraController.value.isInitialized) {
      await cameraController.setZoomLevel(newZoomLevel);
      setState(() {
        currentZoomLevel = newZoomLevel;
      });
    }
  }

  Widget cameraPreviewWidget() {
    if (cameraController.value.isInitialized) {
      return AspectRatio(
        aspectRatio: cameraController.value.aspectRatio,
        child: CameraPreview(cameraController),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  void setImagePreview(XFile xFile) {
    File file = File(xFile.path);
    setState(() {
      imageFile = file;
      imagePreview = FileImage(file);
      print('Preview diupdate dengan file baru: ${file.path}');
    });
  }


  Widget imageTakenWidget() {
    if (imageFile != null) {
      return Image(
        key: UniqueKey(),
        image: FileImage(imageFile!),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 450,
        fit: BoxFit.cover,
      );
    } else {
      return const Text('Tidak ada gambar yang diambil.');
    }
  }

  Future<void> takePicture() async {
    if (!cameraController.value.isInitialized) {
      print('Kontroler kamera belum diinisialisasi');
      return;
    }

    if (cameraController.value.isTakingPicture) {
      print('Kamera sedang mengambil gambar');
      return;
    }

    try {
      XFile xFile = await cameraController.takePicture();
      print('Gambar diambil: ${xFile.path}');
      setImagePreview(xFile);
    } catch (e) {
      print(e);
    }
  }

  Future<void> toggleFlash() async {
    if (cameraController.value.isInitialized) {
      setState(() {
        isFlashOn = !isFlashOn;
      });
      if (isFlashOn) {
        await cameraController.setFlashMode(FlashMode.torch);
      } else {
        await cameraController.setFlashMode(FlashMode.off);
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }


  Future<void> pickVideoFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      // Lakukan sesuatu dengan file video
    }
  }

  Future<void> startVideoRecording() async {
    if (cameraController.value.isInitialized &&
        !cameraController.value.isRecordingVideo) {
      try {
        await cameraController.startVideoRecording();
        setState(() {
          isRecording = true;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> stopVideoRecording() async {
    if (cameraController.value.isRecordingVideo) {
      try {
        XFile video = await cameraController.stopVideoRecording();
        setState(() {
          isRecording = false;
          videoFile = video;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: tanggalPelaporan ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        tanggalPelaporan = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Buat Laporan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColor.descColor,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Stepper(
        steps: getSteps(),
        type: StepperType.horizontal,
        currentStep: currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Container();
        },
      ),
    );
  }

  List<Step> getSteps() => [
    Step(
      title: const Text(''),
      content: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category.categoryName!),
            leading: const Icon(Icons.category),
            selected: selectedCategoryId == category.id,
            onTap: () {
              _onStepContinue();
              setState(() {
                selectedCategoryId = category.id;
                print(selectedCategoryId);
              });
            },
            tileColor: selectedCategoryId == category.id ? Colors.blue[100] : Colors.white,
          );
        },
      ),
      state: stepState(0),
      isActive: currentStep >= 0,
    ),
    Step(
      title: const Text(''),
      content: SingleChildScrollView(
        child: Form(
          key: _formKeyPengaduan,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Isi Data Pengaduan",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const Text("*Wajib mengisi semua form",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.red
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text("Tanggal Kejadian",
                    style: TextStyle(
                        fontSize: 12
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ListTile(
                    title: Text("Tanggal Kejadian: ${tanggalPelaporan != null ? DateFormat('yyyy/MM/dd').format(tanggalPelaporan!) : 'Pilih tanggal'}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                  const SizedBox(height: 10,),
                  const Text("Kategori Lokasi Kasus",
                    style: TextStyle(
                        fontSize: 12
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _kategoriLokasiKasus,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Kategori Lokasi Kasus',
                        hintStyle: TextStyle(color: Colors.grey)),
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi tidak boleh kosong';
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  provinciesPelaporan.isEmpty
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<String>(
                    value: provinceIdPelaporan,
                    decoration: const InputDecoration(
                      labelText: "Provinsi",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        provinceIdPelaporan = newValue!;
                        _provinsiKasus.text = provinciesPelaporan.firstWhere((province) => province.id == newValue).name!;
                        cityIdPelaporan = null;
                        districtIdPelaporan = null;
                        subDistrictIdPelaporan = null;
                        listOfCitiesPelaporan = [];
                        listOfDistrictsPelaporan = [];
                        listOfSubDistrictsPelaporan = [];
                        _loadRegenciesPelaporan(newValue);
                      });
                    },
                    items: provinciesPelaporan.map<DropdownMenuItem<String>>((Provincies province) {
                      return DropdownMenuItem<String>(
                        value: province.id,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 48,
                          ),
                          child: Text(province.name!, overflow: TextOverflow.ellipsis),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: cityIdPelaporan,
                    decoration: const InputDecoration(
                      labelText: "Kabupaten/Kota",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        cityIdPelaporan = newValue!;
                        _kabupatenKasus.text = listOfCitiesPelaporan.firstWhere((city) => city.id == newValue).name!;
                        districtIdPelaporan = null;
                        subDistrictIdPelaporan = null;
                        listOfDistrictsPelaporan = [];
                        listOfSubDistrictsPelaporan = [];
                        _loadDistrictsPelaporan(newValue);
                      });
                    },
                    items: listOfCitiesPelaporan.map<DropdownMenuItem<String>>((Cities city) {
                      return DropdownMenuItem<String>(
                        value: city.id,
                        child: Text(city.name!, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: districtIdPelaporan,
                    decoration: const InputDecoration(
                      labelText: "Kecamatan",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        districtIdPelaporan = newValue!;
                        _kecamatanKasus.text = listOfDistrictsPelaporan.firstWhere((district) => district.id == newValue).name!;
                        _loadVillagesPelaporan(newValue);
                        listOfSubDistrictsPelaporan = [];
                        subDistrictIdPelaporan = null;
                      });
                    },
                    items: listOfDistrictsPelaporan.map<DropdownMenuItem<String>>((Districts districts) {
                      return DropdownMenuItem<String>(
                        value: districts.id,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 48, // Menyesuaikan lebar
                          ),
                          child: Text(districts.name!, overflow: TextOverflow.ellipsis),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: subDistrictIdPelaporan,
                    decoration: const InputDecoration(
                      labelText: "Desa",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        subDistrictIdPelaporan = newValue!;
                        _desaKasus.text = listOfSubDistrictsPelaporan.firstWhere((subDistrict) => subDistrict.id == newValue).name!;
                      });
                    },
                    items: listOfSubDistrictsPelaporan.map<DropdownMenuItem<String>>((SubDistricts subDistricts) {
                      return DropdownMenuItem<String>(
                        value: subDistricts.id,
                        child: Text(subDistricts.name!, maxLines: 1,),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10,),
                  const Text("Alamat Detail",
                    style: TextStyle(
                        fontSize: 12
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _alamatDetail,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Alamat Detail',
                        hintStyle: TextStyle(color: Colors.grey)),
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi tidak boleh kosong';
                      }
                    },
                  ),
                  const SizedBox(height: 10,),
                  const Text("Kronologi Kasus",
                    style: TextStyle(
                        fontSize: 12
                    ),
                  ),
                  const SizedBox(height: 10,),
                  // ISIAN
                  TextFormField(
                    controller: _kronologiKasus,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder()),
                    maxLines: 8,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Isi tidak boleh kosong';
                      }
                    },
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () {
                              _onStepCancel();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppColor.primaryColor,
                              onPrimary: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ), child: const Text("Kembali"),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () {
                                _onStepContinue();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppColor.primaryColor,
                                onPrimary: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ), child: const Text("Lanjutkan"),
                            ),
                          )
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      state: stepState(1),
      isActive: currentStep >= 1,
    ),
    Step(
      title: const Text(''),
      content: FutureBuilder<void>(
        future: _initializeCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      flex: 2,
                      child: Text(
                        "Ambil foto/video",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        "*Maksimal 1 menit",
                        style: TextStyle(fontSize: 10, color: AppColor.dangerColor),
                      ),
                    ),
                    Flexible(
                        flex: 1,
                        child: InkWell(
                          child: Text(
                            "Lewati",
                            style: TextStyle(fontSize: 12, color: AppColor.primaryColor, fontWeight: FontWeight.bold),
                          ),
                          onTap: (){
                            setState(() {
                              currentStep = 3;
                            });
                          },
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (imageFile == null) ...[
                  SizedBox(
                    height: 450,
                    width: MediaQuery.of(context).size.width,
                    child: cameraPreviewWidget(),
                  ),
                  Slider(
                    min: 1.0,
                    max: maxZoomLevel,
                    value: currentZoomLevel,
                    onChanged: (zoomLevel) {
                      setZoomLevel(zoomLevel);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 50,
                        icon: Icon(
                          Icons.image,
                          color: AppColor.primaryColor,
                        ),
                        onPressed: pickImageFromGallery,
                      ),
                      GestureDetector(
                        onLongPress: startVideoRecording,
                        onLongPressUp: stopVideoRecording,
                        child: IconButton(
                          iconSize: 50,
                          icon: Icon(
                            Icons.circle_outlined,
                            color: AppColor.primaryColor,
                          ),
                          onPressed: () {
                            if (!isRecording) {
                              takePicture();
                            }
                          },
                        ),
                      ),
                      IconButton(
                        iconSize: 50,
                        icon: Icon(
                          isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: AppColor.primaryColor,
                        ),
                        onPressed: toggleFlash,
                      ),
                    ],
                  )
                ] else ...[
                  imageTakenWidget(),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          side: BorderSide(color: AppColor.primaryColor, width: 2),
                          textStyle: const TextStyle(fontSize: 15),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)
                            ),
                          ),
                        ),
                        onPressed: (() {
                          setState(() {
                            imageFile = null;
                            imagePreview = null;
                          });
                        }),
                        child: const Text('Hapus'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _onStepContinue,
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.primaryColor,
                          textStyle: const TextStyle(fontSize: 15),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 12.0),
                        ),
                        child: const Text('Gunakan'),
                      ),
                    ],
                  ),
                ],
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      state: stepState(2),
      isActive: currentStep >= 2,
    ),
    Step(
      title: const Text(''),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(imageFile != null) ...[
            Stack(
              children: [
                Image.file(
                  File(imageFile!.path),
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          imageFile = null;
                          imagePreview = null;
                          currentStep = 2;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColor.primaryColor,
                        onPrimary: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      child: const Text("Ubah"),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[

          ],
          const SizedBox(height: 20,),
          Row(
            children: [
              const Text("Kategori Laporan", style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),),
              Expanded(child: Container()),
              InkWell(
                child: Text("Ubah", style: TextStyle(
                  fontSize: 12,
                  color: AppColor.primaryColor,
                ),),
                onTap: () {
                  setState(() {
                    currentStep = 0;
                  });
                },
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: const Text("Kasus Perempuan", style: TextStyle(
              fontSize: 12,
            ),),
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text("Detail Laporan", style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),),
              Expanded(child: Container()),
              InkWell(
                child: Text("Ubah", style: TextStyle(
                  fontSize: 12,
                  color: AppColor.primaryColor,
                ),),
                onTap: () {
                  setState(() {
                    currentStep = 1;
                  });
                },
              ),
            ],
          ),
          Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nama Lengkap", style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 5,),
                  Text(_namaKorban.text, style: const TextStyle(
                    fontSize: 12,
                  ),),
                  const SizedBox(height: 15,),
                  const Text("Alamat", style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 5,),
                  // Text(_alamatPelapor.text, style: const TextStyle(
                  //   fontSize: 12,
                  // ),),
                  const SizedBox(height: 15,),
                  const Text("Ringkasan Kejadian", style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 5,),
                  Text(_kronologiKasus.text, style: const TextStyle(
                    fontSize: 12,
                  ),),
                  const SizedBox(height: 15,),
                  const Text("Rentang Usia", style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),),
                  const SizedBox(height: 15,),
                  const Text("Jenis Kelamin", style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),),
                ],
              )
          ),
          const SizedBox(height: 10,),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submitReport,
              style: ElevatedButton.styleFrom(
                primary: AppColor.primaryColor,
                onPrimary: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              child: const Text("Laporkan"),
            ),
          )
        ],
      ),
      state: stepState(3),
      isActive: currentStep >= 3,
    ),
  ];

  StepState stepState(int step) {
    if (currentStep > step) {
      return StepState.complete;
    } else if (currentStep == step) {
      return StepState.indexed;
    } else {
      return StepState.indexed;
    }
  }

  void _onStepContinue() {
    bool isFormValid = _formKeyPengaduan.currentState!.validate();

    if (currentStep < (getSteps().length - 1)) {
      setState(() {
        currentStep += 1;
      });
    }
  }

  void _onStepCancel() {
    if (currentStep > 0) {
      setState(() {
        currentStep -= 1;
      });
    }
  }

  Future<void> submitReport() async {
    int? idKategoriKekerasan = selectedCategoryId;
    DateTime? tanggalKejadian = tanggalPelaporan;
    String? lokasiKasus = _kategoriLokasiKasus.text;
    String? kronologi = _kronologiKasus.text;
    String? provinsi = _provinsiKasus.text;
    String? kabupaten = _kabupatenKasus.text;
    String? kecamatan = _kecamatanKasus.text;
    String? desa = _desaKasus.text;
    String? alamatTkp = "$provinsi, $kabupaten, $kecamatan, $desa";
    String? alamatDetailTkp = _alamatDetail.text;

    try {
      showLoadingAnimated(context);

      var response = await APIService().submitReport(
        idKategoriKekerasan!,
        tanggalKejadian!,
        lokasiKasus,
        kronologi,
        alamatDetailTkp,
        alamatTkp,
        [imageFile!],
      );

      if (response.code == 201) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomNavigationWidget(initialIndex: 1, pages: [
            HomePage(), ReportScreen(), ProfilePage()
          ])),
              (Route<dynamic> route) => false,
        );
        print("Laporan berhasil dikirim.");
      } else {
        print("Gagal mengirim laporan: ${response.message}");
      }
    } catch (e) {
      print('Error saat mengirim laporan: $e');
    } finally {
      closeLoadingDialog(context);
    }
  }
}
