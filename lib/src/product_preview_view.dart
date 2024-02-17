import 'package:flutter/material.dart';
import 'package:flutter_product_carousel/src/custom_widgets.dart';
import 'package:flutter_product_carousel/src/product_carousel_options.dart';
import 'package:flutter_product_carousel/src/utils.dart';

class ProductPreview extends StatefulWidget {
  const ProductPreview(
      {super.key,
      required this.imagesList,
      required this.carouselOptions,
      this.multiImagesList});

  final List<String> imagesList;

  final List<ImageProvider>? multiImagesList;

  final ProductCarouselOptions carouselOptions;

  @override
  State<ProductPreview> createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  String? assetImage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation =
        CurvedAnimation(parent: _controller!, curve: Curves.fastOutSlowIn);
    _controller?.forward();
  }

  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation!,
      child: Stack(
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
      ),
    );
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
}
