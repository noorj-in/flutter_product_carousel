import 'package:flutter/material.dart';
import 'package:flutter_product_carousel/src/product_carousel_controller.dart';

class ProductCarouselOptions {
  final double? height;

  final double aspectRatio;

  final int initialPage;

  /// Set to false to disable page snapping, useful for custom scroll behavior.

  final bool pageSnapping;

  final double viewportFraction;

  final Axis scrollDirection;

  //Preview images to show the images in the expanded view
  final bool previewImages;

  /// showNavigationIcons to show the navigation icons to the left and right of the carousel indicators
  final bool showNavigationIcons;

  /// Is favorite to show the favorite icon
  final bool? isFavorite;

  /// auto play is disabled by default, if you want to enable it, set autoPlay to true, and set the autoPlayTimeInterval to the duration you want to use for the auto play

  final bool autoPlay;

  final bool enabledInfiniteScroll;

  /// auto play time interval to set the time interval for the auto play of the carousel images

  final Duration autoPlayTimeInterval;

  /// By default the box fit is set to fill,
  /// box fit to set the box fit of the images in the carousel widget

  final BoxFit? boxFit;

  ///Determines the physics of the scroll
  final ScrollPhysics? physics;

  final ProductCarouselController? productCarouselController;

  ///On tap to handle the tap of the product carousel
  final VoidCallback onTap;

  /// onPageChanged to handle the page change of the product carousel
  Function(int index)? onPageChanged;


  //On favorite tap to handle the favorite tap
  final VoidCallback? onFavoriteTap;

  ProductCarouselOptions({
    this.height,
    this.aspectRatio = 16 / 9,
    this.initialPage = 0,
    this.pageSnapping = true,
    this.viewportFraction = 1.0,
    this.scrollDirection = Axis.horizontal,
    this.previewImages = false,
    this.showNavigationIcons = false,
    this.isFavorite,
    this.autoPlay = false,
    this.enabledInfiniteScroll = false,
    this.autoPlayTimeInterval = const Duration(milliseconds: 1000),
    this.boxFit = BoxFit.fill,
    this.physics,
    this.productCarouselController,
    this.onPageChanged,
    required this.onTap,
    required this.onFavoriteTap,
  });
}
