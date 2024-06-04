import 'package:flutter/material.dart';
import 'package:violence_app/screens/laporan/component/report_list_cancel.dart';
import '../../main.dart';
import '../../styles/color.dart';
import 'component/report_list_enter.dart';
import 'component/report_list_done.dart';
import 'component/report_list_process.dart';


class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: LaporanScreenStf(),
    );
  }
}

class LaporanScreenStf extends StatefulWidget {
  const LaporanScreenStf({super.key});

  @override
  State<LaporanScreenStf> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreenStf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan", style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600
        ),),
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: (){
            if (Navigator.canPop(navigatorKey.currentState!.context)) {
              navigatorKey.currentState!.pop();
            } else {
              navigatorKey.currentState!.pushReplacementNamed('/homepage');
            }
          },
        ),
        bottom: const TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            Tab(text: 'Laporan Masuk'),
            Tab(text: 'Dalam Proses'),
            Tab(text: 'Selesai'),
            Tab(text: 'Dibatalkan'),
          ],
          indicatorColor: Colors.lightGreenAccent,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
        ),
      ),
      body: const TabBarView(
        children: [
          ReportListEnter(),
          ReportListProcess(),
          ReportListDone(),
          ReportListCancel()
        ],
      ),
    );
  }
}



