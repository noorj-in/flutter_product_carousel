import 'package:flutter/material.dart';

/// cardShadow to set the shadow for the Card/container

BoxDecoration cardShadow({double? borderRadius, Color? color}) => BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius ?? 25.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          spreadRadius: 0,
          blurRadius: 4,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.grey.shade200,
          spreadRadius: 0,
          blurRadius: 6,
          offset: const Offset(0, 0),
        ),
      ],
    );

/// getCurrentIndex to get the current index of the page view based on the pageScrollOffset and length of the images
int getCurrentIndex(int index, int pageScrollOffset, int length) {
  if (length == 0) return 0;
  int result = (index - pageScrollOffset) % length;
  return result < 0 ? length + result : result;
}
