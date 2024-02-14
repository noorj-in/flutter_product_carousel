import 'package:flutter/material.dart';
import 'package:flutter_product_carousel/src/carousel.dart';
import 'package:flutter_product_carousel/src/custom_widgets.dart';
import 'package:flutter_product_carousel/src/product_carousel_options.dart';
import 'package:flutter_product_carousel/src/utills.dart';

class ProductCarousel extends StatefulWidget {
  const ProductCarousel({
    super.key,
    required this.imagesList,
    required this.carouselOptions,
  });

  /// imagesList to set the list of images for the product carousel
  final List<String> imagesList;

  /// carouselOptions to set the options for the product carousel

  final ProductCarouselOptions carouselOptions;

  @override
  State<ProductCarousel> createState() => ProductCarouselState();
}

class ProductCarouselState extends State<ProductCarousel> {
  String? assetImage;
  GlobalKey<CarouselState> carouselStateKeyKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (!widget.carouselOptions.previewImages) {
      return Container(
        height: widget.carouselOptions.height,
        // color: Colors.white,
        decoration: cardShadow(),
        child: Stack(
          children: [
            Carousel(
              key: carouselStateKeyKey,
              imagesList: widget.imagesList,
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
                  icon: widget.carouselOptions.isFavorite == true
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red.shade400,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: InteractiveViewer(
                      child: assetImage != null
                          ? extendedImage(
                              url: assetImage ?? '',
                              fit: BoxFit.contain,
                            )
                          : extendedImage(
                              url: widget.imagesList.first,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                color: Colors.grey.shade100,
                child: buildHorizontalProductsImages(
                  imagesList: widget.imagesList,
                  onTap: (index) {
                    setState(() {
                      assetImage = widget.imagesList[index];
                    });
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 10.0,
            right: 10.0,
            child: IconButton(
              onPressed: () {
                widget.carouselOptions.onTap();
              },
              icon: Icon(
                Icons.close_outlined,
                color: Colors.black.withOpacity(0.5),
                size: 30.0,
              ),
            ),
          ),
        ],
      );
    }
  }
}

SingleChildScrollView buildHorizontalProductsImages({
  required List<String> imagesList,
  required Function(int) onTap,
  double? borderRadius,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(
        imagesList.length,
        (index) => GestureDetector(
          onTap: () {
            onTap(index);
          },
          child: Container(
            margin: EdgeInsets.only(
              left: index == 0 ? 16.0 : 0.0,
              right: index == imagesList.length - 1 ? 16.0 : 12.0,
              bottom: 5.0,
              top: 5.0,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 6.0,
            ),
            decoration: cardShadow(borderRadius: borderRadius),
            child: extendedImage(
              url: imagesList[index],
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ),
  );
}
