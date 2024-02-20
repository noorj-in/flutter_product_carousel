import 'package:flutter/material.dart';
import 'package:flutter_product_carousel/src/product_carousel_controller.dart';

class ProductCarouselOptions {
  /// height to set the height of the product carousel
  final double? height;

  /// aspect ratio to set the aspect ratio of the product carousel images by default it is set to 16/9

  final double aspectRatio;

  /// initial page to set the initial page of the product carousel by default it is set to 0

  final int initialPage;

  /// Set to false to disable page snapping, useful for custom scroll behavior.

  final bool pageSnapping;

  /// viewportFraction to set the viewport fraction of the product carousel by default it is set to 1.0

  final double viewportFraction;

  /// scrollDirection to set the scroll direction of the product carousel by default it is set to horizontal

  final Axis scrollDirection;

  /// forwardIcon to set the forward icon of the product carousel by default it will show based on platform type
  /// if platform is iOS, it will show the Icons.arrow_forward_ios
  /// if platform is Android, it will show the Icons.arrow_forward

  final IconData? forwardIcon;

  /// indicatorsColor to set the color of the indicators of the product carousel by default it is set to red,
  /// if you want to change the color of the indicators, you can set the indicatorsColor to the color you want to use for the indicators
  /// but this color will be used for forward and backward indicator icons

  final Color? indicatorsColor;

  /// backwardIcon to set the backward icon of the product carousel by default it will show based on platform type
  /// if platform is iOS, it will show the Icons.arrow_back_ios
  /// if platform is Android, it will show the Icons.arrow_back

  final IconData? backwardIcon;

  /// Preview images to show the images in the expanded view

  final bool previewImages;

  /// showNavigationIcons to show the navigation icons to the left and right of the carousel indicators

  final bool showNavigationIcons;

  /// Is favorite to show the favorite icon
  final bool? isFavorite;

  /// auto play is disabled by default, if you want to enable it, set autoPlay to true, and set the autoPlayTimeInterval to the duration you want to use for the auto play

  final bool autoPlay;

  /// enabledInfiniteScroll to enable the infinite scroll of the carousel images

  final bool enabledInfiniteScroll;

  /// isReverse to set the reverse of the product carousel by default it is set to false

  final bool isReverse;

  /// showShadow to set the shadow for the product carousel by default it is set to true

  final bool showShadow;

  /// auto play time interval to set the time interval for the auto play of the carousel images

  final Duration autoPlayTimeInterval;

  /// auto play duration to set the duration for the auto play of the carousel images

  final Duration autoPlayDuration;

  /// frame change duration to set the duration for the frame change of the carousel images

  final Duration? frameChangeDuration;

  /// By default the box fit is set to fill,
  /// box fit to set the box fit of the images in the carousel widget

  final BoxFit? boxFit;

  /// Determines the physics of the scroll view used to implement the scrolling behavior of the carousel

  final ScrollPhysics? physics;

  /// productCarouselController to set the controller for the product carousel
  /// if you want to use the controller, you can use the productCarouselController to control the carousel
  /// for example, you can use the controller to move to the next page or previous page

  final ProductCarouselController? productCarouselController;

  /// On tap to handle the tap of the product carousel to preview the images,
  /// if you want to use the onTap method you need to call onTap method and set the previewImages to true/false,

  final VoidCallback onTap;

  /// onPageChanged to handle the page change of the product carousel

  Function(int index)? onPageChanged;

  /// To display the favorite icon on the product carousel item, you need to provide the onFavoriteTap method
  /// On favorite tap to handle the favorite tap of the product carousel, if you want to use the favorite tap you need to call onFavoriteTap method,
  /// for example, you can use the onFavoriteTap to favorite the product

  final VoidCallback? onFavoriteTap;

  /// To display the share icon on the product carousel item, you need to provide the onShareTap method
  /// On share tap to handle the share tap, if you want to use the share tap ypu need to call onShareTap method,
  /// for example, you can use the onShareTap to share the product details

  final VoidCallback? onShareTap;

  ProductCarouselOptions({
    this.height,
    this.aspectRatio = 14 / 9,
    this.initialPage = 0,
    this.pageSnapping = true,
    this.viewportFraction = 1.0,
    this.scrollDirection = Axis.horizontal,
    this.previewImages = false,
    this.showNavigationIcons = false,
    this.isReverse = false,
    this.showShadow = true,
    this.isFavorite,
    this.forwardIcon,
    this.backwardIcon,
    this.indicatorsColor = Colors.redAccent,
    this.autoPlay = false,
    this.enabledInfiniteScroll = false,
    this.autoPlayTimeInterval = const Duration(milliseconds: 1000),
    this.autoPlayDuration = const Duration(seconds: 3),
    this.frameChangeDuration = const Duration(milliseconds: 90),
    this.boxFit = BoxFit.fill,
    this.physics,
    this.productCarouselController,
    this.onPageChanged,
    required this.onTap,
    this.onFavoriteTap,
    this.onShareTap,
  });
}
