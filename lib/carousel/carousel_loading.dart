import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:violence_app/styles/color.dart';
import '../model/content_model.dart';
import '../screens/community_screen.dart';
import '../services/api_service.dart';

class CarouselLoading extends StatefulWidget {
  const CarouselLoading({super.key});

  @override
  _CarouselLoadingState createState() => _CarouselLoadingState();
}

class _CarouselLoadingState extends State<CarouselLoading> {
  Future<List<Content>>? futureContents;
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    futureContents = APIService().fetchContents();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth < 600 ? 1.0 : screenWidth < 1200 ? 2.0 : 2.5;

    return Padding(
      padding: const EdgeInsets.all(25),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Content>>(
              future: futureContents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildHorizontalCarouselSkeleton();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return buildCarousel(snapshot.data!, scaleFactor);
                } else {
                  return const Text('No data available');
                }
              },
            ),
            const SizedBox(height: 20),
            buildNavigateSection("Informasi/Artikel", scaleFactor),
            const SizedBox(height: 20),
            buildNavigateSection("Event", scaleFactor),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  CarouselSlider buildCarousel(List<Content> contents, double scaleFactor) {
    return CarouselSlider(
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
      items: contents.map((content) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                content.imageContent,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  content.judul,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16 * scaleFactor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget buildNavigateSection(String title, double scaleFactor) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16 * scaleFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(child: Container()),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CommunityPage()),
            );
          },
          child: Text(
            "Lihat Semua",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16 * scaleFactor,
            ),
          ),
        )
      ],
    );
  }

  Widget buildHorizontalCarouselSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 200.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (_, index) => Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
