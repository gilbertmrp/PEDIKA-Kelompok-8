import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:violence_app/model/appointment_request_model.dart';
import 'package:violence_app/screens/appointment/cancel_appointment_screen.dart';
import 'package:violence_app/screens/appointment/form_appointment_screen.dart';

import '../../main.dart';
import '../../navigationBar/bottom_bar.dart';
import '../../provider/appointment_provider.dart';
import '../../provider/internet_provider.dart';
import '../../provider/user_provider.dart';
import '../../services/api_service.dart';
import '../../styles/color.dart';
import '../beranda_screen.dart';
import '../dpmdppa/report_screen.dart';
import '../profile/profile_screen.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _controller.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppointmentProvider>(context, listen: false).fetchAppointments();
  }


  void _validateInput() {
    final text = _controller.text;
    int charCount = _countWords(text);
    bool isValid = charCount >= 8;
    _isButtonEnabled.value = isValid;
  }

  int _countWords(String text) {
    return text.replaceAll(' ', '').length;
  }

  void checkConnectionAndReload() {
    final internetProvider = Provider.of<InternetProvider>(context, listen: false);
    if (internetProvider.hasInternet) {
      setState(() {
        APIService().fetchAppointments();
      });
    }
  }

  Widget buildReportSkeleton(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 25,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 30,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 40,)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final internetProvider = Provider.of<InternetProvider>(context);

    if (!internetProvider.hasInternet) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Permintaan Pertemuan", style: TextStyle(color: AppColor.descColor, fontSize: 17, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
          backgroundColor: AppColor.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const BottomNavigationWidget(initialIndex: 2, pages: [HomePage(), ReportScreen(), ProfilePage()],)),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ),
          body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/no_wifi.png', width: 100,),
                    const SizedBox(width: 10,),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Yah, internetnya mati", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                          SizedBox(height: 10,),
                          Text("Cek koneksi Wi-Fi atau kuota internetmu dan coba lagi, ya.", style: TextStyle(fontSize: 16, color: Colors.black),),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: checkConnectionAndReload,
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: AppColor.primaryColor),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Permintaan Pertemuan" ,style:
        TextStyle(
          color: AppColor.descColor,
          fontSize: 17,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),),
          backgroundColor: AppColor.primaryColor,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            if (Navigator.canPop(navigatorKey.currentState!.context)) {
              navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const BottomNavigationWidget(initialIndex: 2, pages: [HomePage(), ReportScreen(), ProfilePage()],)),
                    (Route<dynamic> route) => false,
              );
            } else {
              navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const BottomNavigationWidget(initialIndex: 2, pages: [HomePage(), ReportScreen(), ProfilePage()],)),
                    (Route<dynamic> route) => false,
              );
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed('/prosedur-janji-temu');
            },
            icon: const Icon(
              Icons.question_mark,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: FutureBuilder<List<AppointmentRequestModel>>(
        future: APIService().fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildReportSkeleton(context);
          } else if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat data: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var appointment = snapshot.data![index];
                String tanggal = DateFormat('d MMMM yyyy', 'id').format(DateTime.parse(appointment.waktuDimulai));
                String jamMulai = DateFormat('EEEE, HH:mm', 'id_ID').format(DateTime.parse(appointment.waktuDimulai));
                String jamSelesai = DateFormat('HH:mm', 'id_ID').format(DateTime.parse(appointment.waktuSelesai));
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(tanggal),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(width: 5),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DPMDPPPA Kabupaten Toba',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Jl. Siliwangi No.1, Kec. Balige, Toba, Sumatera Utara',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 11,
                                  ),
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                          appointment.status == "Belum disetujui" ?
                          TextButton(
                            onPressed: null,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              primary: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Belum Disetujui', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                          ) : appointment.status == "Disetujui" ?
                          TextButton(
                            onPressed: null,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              primary: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Disetujui', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ) : appointment.status == "Ditolak" ?
                          TextButton(
                            onPressed: null,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              primary: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Ditolak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          ) : appointment.status == "Dibatalkan" ?
                          TextButton(
                            onPressed: null,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              primary: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Dibatalkan', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ) :
                              Container()
                        ],
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 5,),
                          Text('${jamMulai} - ${jamSelesai} WIB', style: const TextStyle(fontSize: 14, color: Colors.black),),
                          Expanded(child: Container()),
                          if(appointment.status == "Belum disetujui" || appointment.status == "Disetujui" || appointment.status == "Ditolak" || appointment.status == "Dibatalkan")
                            Ink(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: appointment.status == "Belum disetujui"
                                    ? BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))
                                    : BorderRadius.all(Radius.circular(8)),
                              ),
                              child: InkWell(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                onTap: () {
                                  showAppointmentDetailsDialog(context, appointment);
                                  print("View button pressed");
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(Icons.remove_red_eye_rounded, color: Colors.white),
                                ),
                              ),
                            ),
                          if(appointment.status == "Belum disetujui")
                            Ink(
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3C538),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/edit-janji-temu');
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(Icons.edit, color: Colors.white),
                                ),
                              ),
                            ),
                          if(appointment.status == "Belum disetujui")
                            Ink(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                              ),
                              child: InkWell(
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                                onTap: () {
                                  var appointment = snapshot.data![index];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CancelAppointmentScreen(
                                          appointmentId: appointment.id,
                                          waktuDimulai: appointment.waktuDimulai,
                                          waktuSelesai: appointment.waktuSelesai,
                                          details: appointment.keperluanKonsultasi
                                      ),
                                    ),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Tidak ada data janji temu yang ditemukan"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          if (userProvider.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormAppointmentScreen(),
              ),
            );
          } else {
            Navigator.of(context).pushNamed('/login', arguments: {'redirectTo': '/janji-temu'});
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  void showAppointmentDetailsDialog(BuildContext context, AppointmentRequestModel appointment) {
    String formattedDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.parse(appointment.waktuDimulai));
    String jamMulai = DateFormat('HH:mm', 'id_ID').format(DateTime.parse(appointment.waktuDimulai));
    String jamSelesai = DateFormat('HH:mm', 'id_ID').format(DateTime.parse(appointment.waktuSelesai));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: AppColor.primaryColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Flexible(
                child: Text(appointment.keperluanKonsultasi),
              ),
              Text('Waktu: ${formattedDate} Pukul ${jamMulai} - ${jamSelesai} WIB'),
            ],
          ),
        );
      },
    );
  }
}
