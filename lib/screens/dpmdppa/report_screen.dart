import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:violence_app/model/report/report_request_model.dart';
import 'package:violence_app/screens/dpmdppa/form_report.dart';
import 'package:flutter/scheduler.dart';

import '../../model/report/list_report_model.dart';
import '../../provider/report_provider.dart';
import '../../provider/user_provider.dart';
import '../../styles/color.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../model/report/report_category_model.dart';
import '../../services/api_service.dart';
import 'package:collection/collection.dart';

import '../laporan/detail_report_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<ViolenceCategory> categories = [];
  bool isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('id', timeago.IdMessages());
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).fetchReports();
    });
  }

  Future<void> fetchCategories() async {
    final apiService = APIService();
    try {
      final fetchedCategories = await apiService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
        isLoadingCategories = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isLoadingCategories = false;
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
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
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
                              height: 20,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 20,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 35,
                              width: double.infinity,
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
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, right: 15),
                      child: Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  ViolenceCategory? findCategoryById(int id) {
    return categories.firstWhereOrNull((category) => category.id == id);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Laporan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColor.primaryColor,
          ),
        ),
      ),
      body: Consumer<ReportProvider>(
        builder: (context, reportProvider, child) {
          if (reportProvider.isLoading) {
            return buildReportSkeleton(context);
          } else if (reportProvider.reports == null) {
            return const Center(child: Text('Gagal memuat laporan'));
          } else if (reportProvider.reports!.data.isEmpty) {
            return const Center(child: Text('Laporan Anda masih kosong'));
          } else {
            return ListView.builder(
              itemCount: reportProvider.reports!.data.length,
              itemBuilder: (context, index) {
                ListLaporanModel report = reportProvider.reports!.data[index];
                final timeAgo = timeago.format(report.createdAt, locale: 'id');
                return GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                              child: Image.network(
                                report.violenceCategoryDetail.image!,
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, color: Colors.red);
                                },
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(report.violenceCategoryDetail.categoryName!, style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  const SizedBox(height: 10,),
                                  Text(report.kronologisKasus, style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),maxLines: 2,),
                                  const SizedBox(height: 10,),
                                  Text("Alamat : ${report.alamatTkp}", style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),)
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Text(timeAgo, textAlign: TextAlign.end,
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailReportScreen(noRegistrasi: report.noRegistrasi),
                      ),
                    );
                  },
                );
              },
            );
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
                builder: (context) => const FormReportDPMADPPA(),
              ),
            );
          } else {
            Navigator.of(context).pushNamed('/login', arguments: {'redirectTo': '/add-laporan'});
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
