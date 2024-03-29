import 'dart:math';
import 'package:flutter/material.dart';

class ProductImage360View extends StatefulWidget {
  const ProductImage360View({
    required Key key,
    required this.imageList,
    required this.onCloseTap,
    this.frameChangeDuration = const Duration(milliseconds: 90),
  }) : super(key: key);

  /// imageList to set the list of images for the 360 degree view of the product
  final List<ImageProvider> imageList;

  /// frameChangeDuration to set the duration for the frame change of the 360 degree view of the product

  final Duration frameChangeDuration;

  /// onCloseTap to provide the callback function to close the 360 degree view of the product
  final Function(bool) onCloseTap;

  @override
  State<ProductImage360View> createState() => _ProductImage360ViewState();
}

class _ProductImage360ViewState extends State<ProductImage360View>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

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

  /// rotationIndex to set the index of the image in the list of images for the 360 degree view of the product
  int rotationIndex = 0;

  /// frameSensitivity to set the sensitivity of the frame change of the 360 degree view of the product
  int frameSensitivity = 2;

  /// localPosition to set the local position of the frame change of the 360 degree view of the product
  double localPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation!,
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    localPosition = 0.0;
                  },
                  onVerticalDragEnd: (details) {
                    localPosition = 0.0;
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0) {
                      handlePositive180DegreeRotation(details);
                    } else if (details.delta.dx < 0) {
                      handleNegative180DegreeRotation(details);
                    }
                  },
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0) {
                      handlePositive180DegreeRotation(details,
                          isVertical: true);
                    } else if (details.delta.dy < 0) {
                      handleNegative180DegreeRotation(details,
                          isVertical: true);
                    }
                  },
                  child: Image(
                    image: widget.imageList[rotationIndex],
                    gaplessPlayback: true,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: IconButton(
              onPressed: () => widget.onCloseTap(false),
              icon: Icon(
                Icons.close_outlined,
                color: Colors.black.withOpacity(0.5),
                size: MediaQuery.of(context).size.height * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// handlePositive180DegreeRotation to handle the positive 180 degree rotation of the 360 degree view of the product
  /// details to get the details of the drag update of the 360 degree view of the product
  Future<void> handlePositive180DegreeRotation(DragUpdateDetails details,
      {bool isVertical = false}) async {
    int? currentIndex = rotationIndex;
    await Future.delayed(widget.frameChangeDuration);
    if ((localPosition +
            (pow(4, (6 - frameSensitivity)) / (widget.imageList.length))) <=
        (isVertical ? details.localPosition.dy : details.localPosition.dx)) {
      rotationIndex = rotationIndex + 1;
      localPosition =
          isVertical ? details.localPosition.dy : details.localPosition.dx;
    }
    if (currentIndex != rotationIndex) {
      setState(() {
        if (rotationIndex < widget.imageList.length - 1) {
          rotationIndex = rotationIndex;
        } else {
          rotationIndex = 0;
        }
      });
    }
  }

  /// handleNegative180DegreeRotation to handle the negative 180 degree rotation of the 360 degree view of the product
  /// details to get the details of the drag update of the 360 degree view of the product
  Future<void> handleNegative180DegreeRotation(DragUpdateDetails details,
      {bool isVertical = false}) async {
    double distanceDifference =
        ((isVertical ? details.localPosition.dy : details.localPosition.dx) -
            localPosition);
    int? currentIndex = rotationIndex;
    await Future.delayed(widget.frameChangeDuration);

    if (distanceDifference < 0) {
      distanceDifference = (-distanceDifference);
    }
    if (distanceDifference >=
        (pow(4, (6 - frameSensitivity)) / (widget.imageList.length))) {
      rotationIndex = rotationIndex - 1;
      localPosition =
          isVertical ? details.localPosition.dy : details.localPosition.dx;
    }
    if (currentIndex != rotationIndex) {
      setState(() {
        if (rotationIndex > 0) {
          rotationIndex = rotationIndex;
        } else {
          rotationIndex = widget.imageList.length - 1;
        }
      });
    }
  }
}
