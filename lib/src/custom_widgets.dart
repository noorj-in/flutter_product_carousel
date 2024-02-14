import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// Returns an extended image with the specified url, height, width and fit
/// [icon] is the icon of the button
/// [color] renders the color on button, default color is blue
/// [size] size of the icon, default size is 20.0
/// [callBack] fires an event on user taps on button
Widget iconButton({
  required IconData icon,
  Color? color,
  double? size,
  required VoidCallback callBack,
}) {
  return IconButton(
    onPressed: callBack,
    icon: Icon(
      icon,
      color: color ?? Colors.red,
      size: size ?? 20.0,
    ),
  );
}

/// Returns an extended image with the specified url, height, width and fit
/// [url] is the image url / asset path
/// [height] is the height of the image
/// [width] is the width of the image
ExtendedImage extendedImage({
  required String url,
  double? height,
  double? width,
  BoxFit? fit,
}) {
  if (url.startsWith('assets/')) {
    return ExtendedImage.asset(
      url,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
    );
  } else {
    return ExtendedImage.network(
      url,
      fit: fit ?? BoxFit.cover,
      cache: true,
      height: height,
      width: width,
      cacheMaxAge: const Duration(hours: 1),
      cacheRawData: true,
      enableMemoryCache: false,
      enableLoadState: false,
      handleLoadingProgress: true,
      printError: false,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              fit: fit ?? BoxFit.cover,
            );
          case LoadState.failed:
            return GestureDetector(
              onTap: () {
                state.reLoadImage();
              },
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.error),
                    Text('load image failed, click to reload'),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
