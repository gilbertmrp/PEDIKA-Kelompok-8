import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/report/full_report_model.dart';
import '../../../model/report/tracking_report_model.dart';
import '../../../provider/report_provider.dart';
import '../../../styles/color.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingPage extends StatefulWidget {
  final String noRegistrasi;

  TrackingPage({
    Key? key,
    required this.noRegistrasi,
  }) : super(key: key);

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  Future<DetailResponseModel>? reportDetailFuture;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).fetchDetailReports(widget.noRegistrasi);
    });
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('HH:mm', 'id_ID').format(date);
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return "Invalid date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan", style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600
        )),
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
            List<TrackingLaporanModel> sortedTracking = List<TrackingLaporanModel>.from(detail.trackingLaporan);
            sortedTracking.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
            return ListView.builder(
              itemCount: sortedTracking.length,
              itemBuilder: (context, index) {
                final tracking = sortedTracking[index];
                String jam = DateFormat('HH:mm', 'id_ID').format(tracking.updatedAt);
                return Column(
                  children: [
                    ListTile(
                      leading: Text(jam, style: const TextStyle(fontSize: 12.0, color: Colors.grey)),
                      title: Text(tracking.keterangan, style: const TextStyle(fontSize: 14.0)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tracking.documents
                            .map((url) => buildContent(url))
                            .toList(),
                      ),
                      isThreeLine: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                    ),
                    ListTile(
                      leading: Text(jam, style: const TextStyle(fontSize: 12.0, color: Colors.grey)),
                      title: const Text("Laporan masuk", style: TextStyle(fontSize: 14.0)),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(child: Text('Tidak ada data yang tersedia'));
          }
        },
      ),
    );
  }

  Widget buildContent(String url) {
    if (url.endsWith(".pdf")) {
      return TextButton(
        child: Text("Open PDF"),
        onPressed: () => _launchURL(url),
      );
    } else {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Text("Failed to load image"),
      );
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
