import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> images;
  final double height;
  final BorderRadius? borderRadius;

  const ImageCarousel({
    super.key,
    required this.images,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CarouselSlider(
              options: CarouselOptions(
                height: height,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false, 
                viewportFraction: 1.0, 
                 padEnds: false),
              items: images.map((img){
                return ClipRRect(
                    child: SizedBox.expand(
                      child: Image.network(
                        img,
                        fit: height < 200 ? BoxFit.fitWidth : BoxFit.cover,
                        //width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, color: Colors.grey)
                           )
                         ),
                      ),
                    );
                  }).toList()
                ),
              );
  }
}
