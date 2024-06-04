import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:violence_app/screens/dpmdppa/report_cancel_screen.dart';
import 'package:violence_app/screens/laporan/component/tracking_detail_page.dart';
import '../../model/report/full_report_model.dart';
import '../../provider/report_provider.dart';
import '../../styles/color.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailReportScreen extends StatefulWidget {
  final String noRegistrasi;

  DetailReportScreen({
    Key? key,
    required this.noRegistrasi,
  }) : super(key: key);

  @override
  _DetailReportScreenState createState() => _DetailReportScreenState();
}

class _DetailReportScreenState extends State<DetailReportScreen> {
  Future<DetailResponseModel>? reportDetailFuture;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).fetchDetailReports(widget.noRegistrasi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan", style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600
        ),),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Consumer<ReportProvider>(
        builder: (context, reportProvider, child) {
          if (reportProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (reportProvider.errorMessage != null) {
            return Center(child: Text('Error: ${reportProvider.errorMessage}'));
          } else if (reportProvider.detailReport != null) {
            final detail = reportProvider.detailReport!.data;
            final jam = DateFormat('d MMMM yyyy', 'id').format(detail.createdAt);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrackingPage(noRegistrasi: widget.noRegistrasi),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.local_shipping, color: Colors.grey[600], size: 36),
                      title: Text("Status: ${detail.status}", style: const TextStyle(fontSize: 16)),
                      subtitle: const Text("Tekan untuk melihat"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                  if (detail.violenceCategory.image != null) Image.network(
                    detail.violenceCategory.image!,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 5,),
                                Text(jam, textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                            Expanded(child: Container()),
                            Text(detail.noRegistrasi),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Text("Kategori Kasus : ${detail.violenceCategory?.categoryName}"),
                        const SizedBox(height: 10,),
                        const Text("Detail Laporan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                        const Text("Nama Lengkap: ",style: TextStyle(fontWeight: FontWeight.w500),),
                        Text(detail.user.full_name ?? 'Unknown'),
                        const SizedBox(height: 10,),
                        const Text("Alamat: ", style: TextStyle(fontWeight: FontWeight.w500),),
                        Text(detail.alamatTkp ?? 'Unknown'),
                        const SizedBox(height: 10,),
                        const Text("Kronologis: ", style: TextStyle(fontWeight: FontWeight.w500),),
                        Text(detail.kronologisKasus ?? 'No details provided.'),
                        Text("Kategori Kekerasan: ${detail.violenceCategory?.categoryName ?? 'Unknown'}"),
                        const SizedBox(height: 20,),
                        if(detail.status == "Laporan masuk")
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportCancelScreen(noRegistrasi: widget.noRegistrasi),
                                    ),
                                  );
                                },
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
                                  'Batalkan Laporan',
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
                ],
              ),
            );
          } else {
            return const Center(child: Text('Tidak ada data yang tersedia'));
          }
        },
      ),
    );
  }
}
