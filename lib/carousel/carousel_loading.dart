import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:violence_app/styles/color.dart';

import '../screens/community_screen.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
];

class CarouselLoading extends StatefulWidget {
  CarouselLoading({super.key});

  @override
  _CarouselLoadingState createState() => _CarouselLoadingState();
}

class _CarouselLoadingState extends State<CarouselLoading> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  void navigateToNextPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CommunityPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: imgList.map((item) {
                return Container(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(item, fit: BoxFit.cover, width: 1000),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '"Kekerasan Terhadap perempuan bukanlah budaya, itu kriminal. Kesetaraan tidak bisa datang pada akhirnya, itu adalah sesuatu yang harus kita perjuangkan saat ini."',
                            style: TextStyle(
                              color: Colors.white, // Ganti dengan warna teks yang Anda inginkan
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "~Samantha Power",
                            style: TextStyle(
                              color: Colors.white, // Ganti dengan warna teks yang Anda inginkan
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Informasi/Artikel"),
                Expanded(child: Container()),
                InkWell(
                  onTap: () => navigateToNextPage(context),
                  child: Text("Lihat Semua", style: TextStyle(
                    color: AppColor.primaryColor
                  ),),
                )
              ],
            ),
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: imgList.map((item) {
                return Container(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(item, fit: BoxFit.cover, width: 1000),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Seri dokumen Kunci 13. Laporan Independen Komnas Perempuan Kepada Pelapor Khusus PBB Tentang Hak Atas Kesehatan dan Hak Atas Pangan',
                            style: TextStyle(
                                color: Colors.white, // Ganti dengan warna teks yang Anda inginkan
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Event"),
                Expanded(child: Container()),
                InkWell(
                  onTap: () => navigateToNextPage(context),
                  child: Text("Lihat Semua", style: TextStyle(
                      color: AppColor.primaryColor
                  ),),
                )
              ],
            ),
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: imgList
                  .map((item) => Container(
                child: Center(
                  child:
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(item, fit: BoxFit.cover, width: 1000)),
                ),
              ))
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
