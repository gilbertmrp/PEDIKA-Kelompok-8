import 'package:flutter/material.dart';
import '../styles/color.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi", style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600
        )),
        centerTitle: true, // Memastikan judul di tengah
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 30,
                    child: Icon(Icons.notifications, color: Colors.white, size: 30,),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Laporan masuk"),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text("Oleh pihak DPMDPPA", style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(child: Container()),
                            const Text("2 Jam lalu"),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.grey,),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 30,
                    child: Icon(Icons.notifications, color: Colors.white, size: 30,),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sosialisasi Pencegahan Kekerasan Kabupaten Toba"),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text("Oleh pihak DPMDPPA", style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(child: Container()),
                            const Text("3 Jam lalu"),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
