import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../styles/color.dart';

class AppointmentProcedure extends StatefulWidget {
  const AppointmentProcedure({super.key});

  @override
  State<AppointmentProcedure> createState() => _AppointmentProcedureState();
}

class _AppointmentProcedureState extends State<AppointmentProcedure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tentang Janji Temu" ,style:
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
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/bg_appointment.png'),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, size: 25),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DPMDPPPA Kabupaten Toba',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              'Jl. Siliwangi No.1, Kec. Balige, Toba, Sumatera Utara',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              softWrap: true,
                            ),
                            const SizedBox(height: 4.0),
                            GestureDetector(
                              onTap: () {
                                print('Lihat di Map');
                              },
                              child: const Text(
                                'Lihat di Map',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.access_time, size: 25),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Senin - Jumat, "08:00 - 17:00"',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            GestureDetector(
                              onTap: () {
                                _launchURL;
                              },
                              child: const Text(
                                'Lihat jadwal',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  const Text('Tentang', style:
                  TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),),
                  const Text('Waktunya untuk bertindak dan membuat perubahan! Gunakan fitur request janji temu kami sekarang juga untuk mendapatkan bantuan yang Anda butuhkan dalam kasus kekerasan yang Anda alami. Jangan biarkan kesulitan menghalangi keadilan. Isi formulir dengan cerdas, tentukan waktu yang tepat, dan saksikan bagaimana kami memproses permintaan Anda dengan cepat dan efisien. Ayo, jangan tunda lagi, inisiatif Anda dapat membuat perbedaan besar. Aplikasi ini adalah alat Anda untuk memperjuangkan keadilan. Ajukan pertemuan Anda sekarang dan mari bersama-sama melawan kekerasan!'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://www.google.com/maps/search/?api=1&query=52.32,4.917';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
