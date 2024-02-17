library imageview360;

import 'dart:math';
import 'package:flutter/material.dart';

class ProductImage360View extends StatefulWidget {
  const ProductImage360View({
    required Key key,
    required this.imageList,
    required this.onCloseTap,
    this.frameChangeDuration = const Duration(milliseconds: 90),
  }) : super(key: key);

  final List<ImageProvider> imageList;

  // By default true. If set to false, the gestures to rotate the image will be disabed.

  // By default 1. Based on the value the frameSensitivity of swipe gesture increases and decreases proportionally

  // By default Duration(milliseconds: 80). The time interval between shifting from one image frame to other.
  final Duration frameChangeDuration;

  final Function(bool) onCloseTap;

  // Callback function to provide you the index of current image when image frame is changed.

  @override
  State<ProductImage360View> createState() => _ProductImage360ViewState();
}

class _ProductImage360ViewState extends State<ProductImage360View> {
  String? assetImage;
  int rotationIndex = 0;
  int frameSensitivity = 2;
  double localPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                    handlePositive180DegreeRotation(details, isVertical: true);
                  } else if (details.delta.dy < 0) {
                    handleNegative180DegreeRotation(details, isVertical: true);
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
    );
  }

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
    // Check to ignore rebuild of widget is index is same
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
    // Check to ignore rebuild of widget is index is same
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
