import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:violence_app/screens/appointment/appointment_screen.dart';
import 'package:violence_app/screens/laporan/component/report_list_enter.dart';
import 'package:violence_app/screens/laporan/laporan_anda_screen.dart';
import 'package:violence_app/services/api_service.dart';
import 'package:violence_app/utils/loading_dialog.dart';

import '../../styles/color.dart';

class ReportCancelScreen extends StatefulWidget {
  final String noRegistrasi;

  const ReportCancelScreen({
    Key? key,
    required this.noRegistrasi,
  }) : super(key: key);

  @override
  State<ReportCancelScreen> createState() => _ReportCancelScreenState();
}

class _ReportCancelScreenState extends State<ReportCancelScreen> {
  final TextEditingController _cancelReport = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _handleCancel() async {
    showLoadingAnimated(context);
    try {
      await APIService().cancelReport(widget.noRegistrasi, _cancelReport.text);
      Fluttertoast.showToast(
          msg: "Laporan berhasil dibatalkan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LaporanScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Laporan gagal dibatalkan: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } finally {
      closeLoadingDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembatalan Laporan", style: TextStyle(
          color: AppColor.descColor,
          fontSize: 17,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        )),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Alasan Pembatalan", style: TextStyle(fontSize: 12)),
              TextFormField(
                controller: _cancelReport,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan alasan pembatalan';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleCancel,
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(AppColor.primaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: AppColor.primaryColor)
                            )
                        )
                    ),
                    child: const Text(
                      'Kirim',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
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
}
