import 'package:flutter/material.dart';
import 'package:flutter_product_carousel/src/carousel.dart';
import 'package:flutter_product_carousel/src/product_carousel_options.dart';
import 'package:flutter_product_carousel/src/product_preview_view.dart';
import 'package:flutter_product_carousel/src/utils.dart';

class ProductCarousel extends StatefulWidget {
  const ProductCarousel({
    super.key,
    required this.imagesList,
    this.multiImagesList,
    required this.carouselOptions,
  });

  /// imagesList to set the list of images for the product carousel
  final List<String> imagesList;

  /// multiImagesList to set the list of images for the 360 degree view of the product carousel
  /// you should provide the list of sequence of images to view the 360 degree view of the product
  /// for example: if you have 36 images to view the 360 degree view of the product, then you should provide the list of 36 images
  final List<ImageProvider>? multiImagesList;

  /// carouselOptions to set the options for the product carousel

  final ProductCarouselOptions carouselOptions;

  @override
  State<ProductCarousel> createState() => ProductCarouselState();
}

class ProductCarouselState extends State<ProductCarousel> {
  GlobalKey<CarouselState> carouselStateKeyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (!widget.carouselOptions.previewImages) {
      return Container(
        height: widget.carouselOptions.height,
        decoration: widget.carouselOptions.showShadow ? cardShadow() : null,
        child: Stack(
          children: [
            Carousel(
              key: carouselStateKeyKey,
              imagesList: widget.imagesList,
              multiImagesList: widget.multiImagesList ?? [],
              onTap: (_) {
                widget.carouselOptions.onTap();
              },
              boxFit: BoxFit.contain,
              productCarouselOptions: widget.carouselOptions,
              productCarouselController:
                  widget.carouselOptions.productCarouselController,
            ),
            if (!widget.carouselOptions.previewImages &&
                widget.carouselOptions.onFavoriteTap != null)
              Positioned(
                top: 10.0,
                right: 10.0,
                child: IconButton(
                  onPressed: () {
                    widget.carouselOptions.onFavoriteTap!();
                  },
                  iconSize: MediaQuery.of(context).size.width * 0.08,
                  icon: widget.carouselOptions.isFavorite == true
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red.shade400,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.grey.shade800,
                        ),
                ),
              ),
            if (!widget.carouselOptions.previewImages &&
                widget.carouselOptions.onShareTap != null)
              Positioned(
                top: 60.0,
                right: 15.0,
                child: IconButton(
                  onPressed: () {
                    widget.carouselOptions.onShareTap!();
                  },
                  iconSize: MediaQuery.of(context).size.width * 0.08,
                  icon: Icon(
                    Icons.share_outlined,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
          ],
        ),
      );
    } else {
      return ProductPreview(
        imagesList: widget.imagesList,
        multiImagesList: widget.multiImagesList ?? [],
        carouselOptions: widget.carouselOptions,
      );
    }
  }
}
