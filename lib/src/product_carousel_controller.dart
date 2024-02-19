import 'package:flutter/cupertino.dart';

abstract class ProductCarouselController {
  /// Moves the page view to the next page.
  /// [duration] is the duration of the animation.
  /// [curve] is the curve of the animation.
  Future<void> nextPage({Duration? duration, Curve? curve});

  /// Moves the page view to the previous page.
  /// [duration] is the duration of the animation.
  /// [curve] is the curve of the animation.
  Future<void> previousPage({Duration? duration, Curve? curve});

  /// Factory constructor for the ProductCarouselController
  factory ProductCarouselController() {
    return ProductCarouselControllerImpl();
  }
}

class ProductCarouselControllerImpl implements ProductCarouselController {
  /// The page controller for the carousel
  PageController? pageController;

  /// Moves the page view to the next page.
  @override
  Future<void> nextPage({Duration? duration, Curve? curve}) async {
    await pageController?.nextPage(
        duration: duration ?? const Duration(milliseconds: 600),
        curve: curve ?? Curves.easeInToLinear);
  }

  /// Moves the page view to the previous page.
  @override
  Future<void> previousPage({Duration? duration, Curve? curve}) async {
    await pageController?.previousPage(
        duration: duration ?? const Duration(milliseconds: 600),
        curve: curve ?? Curves.easeInToLinear);
  }
}
